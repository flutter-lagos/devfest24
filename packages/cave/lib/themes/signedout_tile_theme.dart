import 'package:cave/themes/colors.dart';
import 'package:flutter/material.dart';

@immutable
class DevfestUserHeaderTile extends ThemeExtension<DevfestUserHeaderTile> {
  final BoxBorder? border;
  final Color titleColor;
  final Color subtitleColor;

  const DevfestUserHeaderTile._({
    this.border,
    required this.titleColor,
    required this.subtitleColor,
  });

  const DevfestUserHeaderTile.light()
      : this._(
          titleColor: DevfestColors.grey100,
          subtitleColor: DevfestColors.grey100,
        );

  DevfestUserHeaderTile.dark()
      : this._(
          border: Border.all(
            color: DevfestColors.backgroundLight,
            width: 1,
          ),
          titleColor: DevfestColors.backgroundLight,
          subtitleColor: DevfestColors.grey60,
        );

  @override
  DevfestUserHeaderTile copyWith({
    ShapeBorder? shape,
    Color? backgroundColor,
    TextStyle? textStyle,
    BoxBorder? border,
    Color? titleColor,
    Color? subtitleColor,
  }) {
    return DevfestUserHeaderTile._(
      border: border ?? this.border,
      titleColor: titleColor ?? this.titleColor,
      subtitleColor: subtitleColor ?? this.subtitleColor,
    );
  }

  @override
  DevfestUserHeaderTile lerp(
      covariant ThemeExtension<DevfestUserHeaderTile>? other, double t) {
    if (other is! DevfestUserHeaderTile) return this;

    return DevfestUserHeaderTile._(
      border: BoxBorder.lerp(border, other.border, t)!,
      titleColor: Color.lerp(titleColor, other.titleColor, t)!,
      subtitleColor: Color.lerp(subtitleColor, other.subtitleColor, t)!,
    );
  }
}
