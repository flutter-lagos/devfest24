import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:schematics/schematics.dart';

import 'walker_grid_painter.dart';
import 'action.dart';
import 'robot.dart';

class _PathFinderRequest {
  final Completer<List<Action>> completer = Completer();
}

Future<List<Action>> getActions({
  required final Grid<int> grid,
  required final GridCellRange moveRange,
}) {
  return compute<(Grid<int>, GridCellRange), List<Action>>(
    (input) async {
      final job = _PathFinderRequest();
      _acquireActions(job, input.$1, input.$2);
      final result = await job.completer.future;
      return result;
    },
    (grid, moveRange),
  );
}

void _acquireActions(
    _PathFinderRequest job, Grid<int> grid, GridCellRange moveRange) {
  GridCell start = moveRange.start;
  GridCell goal = moveRange.end;

  late MapRobot manhattanRobot;
  late MapRobot euclideanRobot;

  do {
    manhattanRobot = MapRobot(grid);
    euclideanRobot = MapRobot(grid);

    manhattanRobot.getAction(start, goal, HeuristicFunction.manhattan);
    euclideanRobot.getAction(start, goal, HeuristicFunction.euclidean);

    if (manhattanRobot.foundActions.isNotEmpty ||
        euclideanRobot.foundActions.isNotEmpty) {
      final manhattanActions = manhattanRobot.foundActions;
      final euclideanActions = euclideanRobot.foundActions;

      if (manhattanActions.isNotEmpty && euclideanActions.isNotEmpty) {
        final superiorActions =
            min(manhattanRobot.actionCost, euclideanRobot.actionCost) ==
                    manhattanRobot.actionCost
                ? manhattanActions
                : euclideanActions;

        job.completer.complete(superiorActions);
        break;
      } else {
        if (manhattanActions.isEmpty) {
          job.completer.complete(euclideanActions);
          break;
        }
        job.completer.complete(manhattanActions);
        break;
      }
    }
  } while (manhattanRobot.foundActions.isEmpty &&
      euclideanRobot.foundActions.isEmpty);
}
