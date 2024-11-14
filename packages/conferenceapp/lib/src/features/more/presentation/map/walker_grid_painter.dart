import 'package:cave/cave.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:schematics/schematics.dart';

import 'action.dart';

typedef GridCellRange = ({GridCell start, GridCell end});

class WalkerGridPainter extends CustomPainter {
  WalkerGridPainter({
    required this.grid,
    required this.cellSize,
    required this.progress,
    this.cellTrackRange,
    this.actions = const [],
    this.showPath = false,
  });

  final Grid<int> grid;
  final double cellSize;
  final double progress;
  final GridCellRange? cellTrackRange;
  final List<Action> actions;
  final bool showPath;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _robotWalkPath(canvas, size, grid);
    if (showPath) {
      _paintProgressPath(path, canvas, const HSLColor.fromAHSL(1, 30, 1, 0.5));
    }
    _paintWalker(path, canvas);
  }

  Path _robotWalkPath(Canvas canvas, Size size, Grid<int> grid) {
    Path progressPath = Path();

    if (cellTrackRange != null) {
      final firstYOrigin =
          (size.height / grid.rows * cellTrackRange!.start.row).floorToDouble();
      final firstXOrigin =
          (size.width / grid.columns * cellTrackRange!.start.column)
              .floorToDouble();
      for (int i = 0; i < actions.length; i++) {
        final action = actions[i];

        if (i == 0 && action == Action.doNothing) {
          progressPath.moveTo(
              firstXOrigin + cellSize / 2, firstYOrigin + cellSize / 2);
          continue;
        }

        switch (action) {
          case Action.moveRight:
            progressPath.relativeLineTo(cellSize, 0);
          case Action.moveLeft:
            progressPath.relativeLineTo(-cellSize, 0);
          case Action.moveUp:
            progressPath.relativeLineTo(0, -cellSize);
          case Action.moveDown:
            progressPath.relativeLineTo(0, cellSize);
          case Action.doNothing:
        }
      }
    }

    return progressPath;
  }

  void _paintProgressPath(Path path, Canvas canvas, HSLColor hue) {
    canvas.drawPath(
      path,
      Paint()
        ..color = hue.toColor()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = cellSize,
    );
  }

  void _paintWalker(Path path, Canvas canvas) {
    final pathMetrics = path.computeMetrics();

    for (final pathMetric in pathMetrics) {
      try {
        final extractPath =
            pathMetric.extractPath(0, pathMetric.length * progress);

        final metric = extractPath.computeMetrics().first;
        final tangent = metric.getTangentForOffset(metric.length)!;
        final offset = tangent.position;

        canvas.drawOval(
            Rect.fromCircle(center: offset, radius: cellSize),
            Paint()
              ..style = PaintingStyle.fill
              ..color = DevfestColors.primariesBlue70.withOpacity(1.0));
      } catch (_) {}
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! WalkerGridPainter) return false;

    if (oldDelegate.grid != grid) return true;
    if (oldDelegate.cellSize != cellSize) return true;
    if (oldDelegate.progress != progress) return true;
    if (oldDelegate.cellTrackRange != cellTrackRange) return true;
    if (oldDelegate.actions != actions) return true;
    if (oldDelegate.showPath != showPath) return true;
    return false;
  }
}
