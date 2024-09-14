import 'dart:math';

import 'package:cave/cave.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum HideFenceBorder {
  none,
  top,
  right,
  bottom,
  left,
  all;
}

final class Block extends Equatable {
  final double width;
  final double height;
  final HideFenceBorder hideFenceBorder;
  final String? entranceLabel;
  final TextStyle? entranceLabelStyle;
  final String blockLabel;
  final TextStyle? blockLabelStyle;
  final Color? blockColor;
  final Offset? position;
  final List<Offset> openingPositions;

  const Block({
    this.width = 100,
    this.height = 100,
    this.hideFenceBorder = HideFenceBorder.none,
    this.entranceLabel,
    this.entranceLabelStyle,
    required this.blockLabel,
    this.blockLabelStyle,
    this.blockColor,
    this.position,
    this.openingPositions = const [],
  });

  factory Block.fromContext(
    BuildContext context, {
    double width = 100,
    double height = 100,
    HideFenceBorder hideFenceBorder = HideFenceBorder.none,
    String? entranceLabel,
    TextStyle? entranceLabelStyle,
    required String blockLabel,
    TextStyle? blockLabelStyle,
    Color? blockColor,
    Offset? position,
    List<Offset> openingPositions = const [],
  }) {
    return Block(
      entranceLabel: entranceLabel,
      blockLabel: blockLabel,
      blockColor: blockColor,
      height: height,
      width: width,
      hideFenceBorder: hideFenceBorder,
      entranceLabelStyle: DevfestTheme.of(context)
          .textTheme
          ?.bodyBody4Regular
          ?.medium
          .merge(entranceLabelStyle),
      blockLabelStyle: DevfestTheme.of(context)
          .textTheme
          ?.bodyBody2Regular
          ?.semi
          .merge(blockLabelStyle),
      position: position,
      openingPositions: openingPositions,
    );
  }

  @override
  List<Object?> get props => [
        width,
        height,
        hideFenceBorder,
        entranceLabel,
        entranceLabelStyle,
        blockLabel,
        blockLabelStyle,
        blockColor,
        position,
        openingPositions,
      ];
}

class MapLayoutDelegate extends MultiChildLayoutDelegate {
  final List<Block> blocks;

  MapLayoutDelegate({
    this.blocks = const [],
  });

  double _sumBlocHeightsToIndex(int index) {
    double sum = 0;
    for (int i = 0; i < index; i++) {
      sum += blocks[i].height;
    }
    return sum;
  }

  @override
  void performLayout(Size size) {
    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      final childId = i;
      final childSize = Size(block.width, block.height);
      final currentSize = layoutChild(childId, BoxConstraints.tight(childSize));

      final childOffset = Offset(
        block.position?.dx ?? 0,
        size.height -
            currentSize.height -
            (block.position?.dy ?? _sumBlocHeightsToIndex(i)),
      );

      positionChild(childId, childOffset);
    }
  }

  @override
  bool shouldRelayout(MapLayoutDelegate oldDelegate) {
    return oldDelegate.blocks != blocks;
  }
}

class MapBlockPainter extends CustomPainter {
  final Block block;

  const MapBlockPainter({required this.block});

  static const double _fenceStrokeWidth = 1.5;
  static final double _openingRadius = 32.h;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBlock(canvas, size);
  }

  void _drawBlock(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = block.blockColor ?? DevfestColors.grey10
      ..style = PaintingStyle.fill;

    final entranceLabelExists = block.entranceLabel != null;
    const textHeightFactor = 20.0;
    final textPainter = TextPainter(
      text: TextSpan(
        text: block.entranceLabel ?? '',
        style: block.entranceLabelStyle ??
            const TextStyle(
              color: DevfestColors.grey10,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // render entrance label
    if (entranceLabelExists) {
      canvas.save();
      canvas.rotate(_getDegInRad(-90));
      textPainter.paint(
        canvas,
        Offset(-(size.height + textPainter.width) / 2,
            size.width - textHeightFactor),
      );

      canvas.restore();
    }

    // 5 is padding between entrance label and block
    final blockStartFromEnd =
        entranceLabelExists ? textHeightFactor + 5.0 : 0.0;
    final blockWidth = size.width - blockStartFromEnd;

    assert(() {
      final openingPositionAligned = () {
        return block.openingPositions.map((openingPosition) {
          // opening position must be aligned correctly at the horizontal edges of the block
          if (openingPosition.dx == 0 ||
              openingPosition.dx - blockStartFromEnd == blockWidth) {
            return openingPosition.dy >= 0 && openingPosition.dy <= size.height;
          }

          // opening position must be aligned correctly at the vertical edges of the block
          if (openingPosition.dy == 0 || openingPosition.dy == size.height) {
            return openingPosition.dx >= 0 &&
                openingPosition.dx - blockStartFromEnd <= blockWidth;
          }

          return false;
        }).fold(true, (prev, current) => prev && current);
      }();

      if (!openingPositionAligned) {
        throw FlutterError(
          'Opening position must be aligned correctly at the edges of the block',
        );
      }
      return openingPositionAligned;
    }());

    // paint inside
    late Path path;
    if (entranceLabelExists) {
      path = Path()
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(blockWidth, size.height)
        ..lineTo(blockWidth, size.height * 0.75)
        ..arcToPoint(Offset(blockWidth, size.height * 0.25),
            radius: const Radius.circular(22))
        ..lineTo(blockWidth, 0)
        ..close();
    } else {
      path = Path()
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(blockWidth, size.height)
        ..lineTo(blockWidth, 0)
        ..close();
    }
    canvas.drawPath(path, paint);

    // paint border
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _fenceStrokeWidth;

    path = switch (block.hideFenceBorder) {
      HideFenceBorder.none => _getPathWithOpenings(
          block.openingPositions,
          Size(blockWidth, size.height),
          _defaultAllowedEdges,
          blockStartFromEnd,
        ),
      HideFenceBorder.top => _getPathWithOpenings(
          block.openingPositions,
          Size(blockWidth, size.height),
          _defaultAllowedEdges.copyWith(top: false),
          blockStartFromEnd,
        ),
      HideFenceBorder.right => _getPathWithOpenings(
          block.openingPositions,
          Size(blockWidth, size.height),
          _defaultAllowedEdges.copyWith(right: false),
          blockStartFromEnd,
        ),
      HideFenceBorder.bottom => _getPathWithOpenings(
          block.openingPositions,
          Size(blockWidth, size.height),
          _defaultAllowedEdges.copyWith(bottom: false),
          blockStartFromEnd,
        ),
      HideFenceBorder.left => _getPathWithOpenings(
          block.openingPositions,
          Size(blockWidth, size.height),
          _defaultAllowedEdges.copyWith(left: false),
          blockStartFromEnd,
        ),
      HideFenceBorder.all => _getPathWithOpenings(
          [],
          Size(blockWidth, size.height),
          (left: false, right: false, top: false, bottom: false),
        ),
    };

    canvas.drawPath(path, paint);

    canvas.save();
    // render block label
    final labelPainter = TextPainter(
      text: TextSpan(
        text: block.blockLabel,
        style: block.blockLabelStyle ??
            const TextStyle(
              color: DevfestColors.grey10,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
      ),
      textDirection: TextDirection.ltr,
    );

    labelPainter.layout();
    // render block label
    if (labelPainter.width > blockWidth) {
      canvas.rotate(_getDegInRad(-90));
      labelPainter.paint(
        canvas,
        Offset(-(size.height + labelPainter.width) / 2,
            (blockWidth - labelPainter.height) / 2),
      );
    } else {
      labelPainter.paint(
        canvas,
        Offset((blockWidth - labelPainter.width) / 2,
            (size.height - labelPainter.height) / 2),
      );
    }

    canvas.restore();
  }

  double _getDegInRad(double angle) {
    return angle * (pi / 180);
  }

  Path _getPathWithOpenings(List<Offset> openings, Size size,
      [_AllowedEdges edges = _defaultAllowedEdges,
      double horizontalPaddingFactor = 0]) {
    final path = Path();

    if (edges.left) {
      final edgeOpenings = openings.where((opening) => opening.dx == 0).toList()
        ..sort((a, b) => a.dy.compareTo(b.dy));

      if (edgeOpenings.isNotEmpty) {
        path.moveTo(0, 0);
        for (int i = 0; i < edgeOpenings.length; i++) {
          path.lineTo(0, edgeOpenings[i].dy);
          path.moveTo(0, edgeOpenings[i].dy + _openingRadius);
        }
        path.lineTo(0, size.height);
      } else {
        path.moveTo(0, 0);
        path.lineTo(0, size.height);
      }
    } else {
      path.moveTo(0, 0);
      path.moveTo(0, size.height);
    }

    if (edges.bottom) {
      final bottomEdgeOpenings = openings
          .where((opening) => opening.dy == size.height)
          .toList()
        ..sort((a, b) => a.dx.compareTo(b.dx));

      if (bottomEdgeOpenings.isNotEmpty) {
        path.moveTo(0, size.height);
        for (int i = 0; i < bottomEdgeOpenings.length; i++) {
          path.lineTo(
              bottomEdgeOpenings[i].dx - horizontalPaddingFactor, size.height);
          path.moveTo(
              bottomEdgeOpenings[i].dx -
                  horizontalPaddingFactor +
                  _openingRadius,
              size.height);
        }
        path.lineTo(size.width, size.height);
      } else {
        path.moveTo(0, size.height);
        path.lineTo(size.width, size.height);
      }
    } else {
      path.moveTo(0, size.height);
      path.moveTo(size.width, size.height);
    }

    if (edges.right) {
      final edgeOpenings = openings
          .where(
              (opening) => opening.dx - horizontalPaddingFactor == size.width)
          .toList()
        ..sort((a, b) => b.dy.compareTo(a.dy));

      if (edgeOpenings.isNotEmpty) {
        path.moveTo(size.width, size.height);
        for (int i = 0; i < edgeOpenings.length; i++) {
          path.lineTo(size.width, edgeOpenings[i].dy + _openingRadius);
          path.moveTo(size.width, edgeOpenings[i].dy);
        }
        path.lineTo(size.width, 0);
      } else {
        path.lineTo(size.width, 0);
      }
    } else {
      path.moveTo(size.width, size.height);
      path.moveTo(size.width, 0);
    }

    if (edges.top) {
      final topEdgeOpenings = openings
          .where((opening) => opening.dy == 0)
          .toList()
        ..sort((a, b) => b.dx.compareTo(a.dx));

      if (topEdgeOpenings.isNotEmpty) {
        path.moveTo(size.width, 0);
        for (int i = 0; i < topEdgeOpenings.length; i++) {
          path.lineTo(
              topEdgeOpenings[i].dx - horizontalPaddingFactor + _openingRadius,
              0);
          path.moveTo(topEdgeOpenings[i].dx - horizontalPaddingFactor, 0);
        }

        path.lineTo(0, 0);
      } else {
        path.moveTo(size.width, 0);
        path.lineTo(0, 0);
      }
    } else {
      path.moveTo(size.width, 0);
      path.moveTo(0, 0);
    }

    return path;
  }

  @override
  bool shouldRepaint(MapBlockPainter oldDelegate) {
    return oldDelegate.block != block;
  }
}

typedef _AllowedEdges = ({bool left, bool right, bool top, bool bottom});

const _AllowedEdges _defaultAllowedEdges =
    (left: true, right: true, top: true, bottom: true);

extension on _AllowedEdges {
  _AllowedEdges copyWith({
    bool? left,
    bool? right,
    bool? top,
    bool? bottom,
  }) {
    return (
      left: left ?? this.left,
      right: right ?? this.right,
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
    );
  }
}