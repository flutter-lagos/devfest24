// ignore_for_file: unused_element

import 'dart:math';

import 'package:schematics/schematics.dart';

import 'action.dart';

enum HeuristicFunction {
  manhattan,
  diagonal,
  euclidean;
}

final class MapRobot {
  late Grid<int> _grid;

  final _foundActions = <Action>[];
  bool aStartExecution = false;

  final Map<_Node, _Node?> _cameFrom = {};
  Map<String, Action?> actionMap = {};
  int actionCost = 0;

  MapRobot(Grid<int> grid) {
    _grid = grid;
  }

  Action getAction(GridCell start, GridCell goal,
      [HeuristicFunction hfunc = HeuristicFunction.manhattan]) {
    // execute only once to figure out the optimal path.
    if (!aStartExecution) {
      actionMap.putIfAbsent('above', () => Action.moveUp);
      actionMap.putIfAbsent('below', () => Action.moveDown);
      actionMap.putIfAbsent('left', () => Action.moveLeft);
      actionMap.putIfAbsent('right', () => Action.moveRight);
      actionMap.putIfAbsent('', () => Action.doNothing);

      switch (hfunc) {
        case HeuristicFunction.manhattan:
          _aStar(start, goal, _manhattanDistanceHeuristic);
          break;
        case HeuristicFunction.diagonal:
          _aStar(start, goal, _diagonalDistanceHeuristic);
          break;
        case HeuristicFunction.euclidean:
          _aStar(start, goal, _euclideanDistanceHeuristic);
          break;
      }
      aStartExecution = true;
    } else if (_foundActions.isNotEmpty) {
      return _foundActions.removeLast();
    }

    return Action.doNothing;
  }

  List<Action> get foundActions {
    return _foundActions.reversed.toList();
  }

  void _aStar(GridCell startPosition, GridCell targetPosition,
      int Function(GridCell next, GridCell target) heuristic) {
    if (startPosition == targetPosition) {
      _foundActions.add(Action.doNothing);
      return;
    }

    List<_Node> openList = [];

    final start = _Node(startPosition, 0, '');

    openList.add(start);

    Map<GridCell, int> closeList = {};

    _cameFrom[start] = null;

    closeList[startPosition] = 0;

    while (openList.isNotEmpty) {
      // sort list to get the node with the lowest priority
      openList.sort((a, b) => b.compareTo(a));
      final currentNode = openList.removeLast(); // remove first

      if (currentNode.position == targetPosition) {
        _reconstructPath(currentNode); // find the path
        break;
      }

      // traverse through the neighbouring four positions
      for (final neighbourEntry
          in _grid.getNeighbourPositions(currentNode.position).entries) {
        // Calculating the cost for the path from the starting point to the current
        // position's neighbour node
        final newCost = closeList[currentNode.position]! + 1;

        // extract the position
        final neighbourPosition = neighbourEntry.value;

        // the positioned picked up is not boundary and the position is not impassable
        // and the position was never visited
        if (neighbourPosition != null &&
            _grid.filter(
                neighbourPosition, (state) => state > 0 && state != 30) &&
            !_grid.isCellAtEdge(neighbourPosition) &&
            !_cameFrom.containsPosition(neighbourPosition) &&
            !closeList.containsKey(neighbourPosition)) {
          // add the position in the visited bucket;
          closeList[neighbourPosition] = newCost;

          // calculating the total cost which is f(n) = g(n) + h(n)
          final priority =
              newCost + heuristic(neighbourPosition, targetPosition);

          // create the node object which would contain the new position, the total cost
          // and the direction involved
          final neighbourNode =
              _Node(neighbourPosition, priority, neighbourEntry.key);

          // add the node into the open list so it will sit in the priority queue
          openList.add(neighbourNode);

          // add the node into the visited nodes bucket - to track the direction
          _cameFrom[neighbourNode] = currentNode;
        }
      }
    }

    // ensure we always get a non-empty path
    // if (foundActions.isEmpty) {
    //   _aStar(startPosition, targetPosition, heuristic);
    // }
  }

  void _reconstructPath(_Node target) {
    if (actionMap[target.tileName] != null) {
      _foundActions.add(actionMap[target.tileName]!);
      actionCost += target.priority;
    }
    // backtrack to the start position
    while (_cameFrom[target] != null) {
      target = _cameFrom[target]!;
      _foundActions.add(actionMap[target.tileName]!);
      actionCost += target.priority;
    }

    if (_foundActions.isNotEmpty) {
      _foundActions.removeAt(0);
    }
  }

  int _manhattanDistanceHeuristic(
      GridCell nextPosition, GridCell targetPosition) {
    return (nextPosition.row - targetPosition.row).abs() +
        (nextPosition.column - targetPosition.column).abs();
  }

  int _diagonalDistanceHeuristic(GridCell nextPosition, GridCell targetPosition,
      [int nodeLength = 1, int diagonal = 5]) {
    final dx = (nextPosition.column - targetPosition.column).abs();
    final dy = (nextPosition.row - targetPosition.row).abs();

    return nodeLength * (dx + dy) + (diagonal - 2 * nodeLength) * min(dx, dy);
  }

  int _euclideanDistanceHeuristic(
      GridCell nextPosition, GridCell targetPosition) {
    final dx = (nextPosition.column - targetPosition.column).abs();
    final dy = (nextPosition.row - targetPosition.row).abs();

    return sqrt(dx * dx + dy * dy).toInt();
  }
}

class _Node implements Comparable<_Node> {
  final GridCell position;
  final int priority;
  final String tileName;

  _Node(this.position, this.priority, this.tileName);

  @override
  int compareTo(_Node other) {
    return priority.compareTo(other.priority);
  }

  @override
  String toString() {
    return 'Node(${position.row}, ${position.column}, $priority)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _Node && other.position == position;
  }

  @override
  int get hashCode => position.hashCode ^ priority.hashCode ^ tileName.hashCode;
}

extension on Map<_Node, _Node?> {
  bool containsPosition(GridCell position) {
    return keys.any((element) => element.position == position);
  }
}

extension on Grid {
  bool isCellAtEdge(GridCell cell) {
    for (final neighbor in getNeighbourPositions(cell).entries) {
      if (neighbor.value == null) return true;
      if (filter(neighbor.value!, (state) => state == 0)) return true;
    }

    return false;
  }
}
