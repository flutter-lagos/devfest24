import 'package:flutter/material.dart';

import 'bottom_nav_theme.dart';
import 'button_theme.dart';
import 'colors.dart';
import 'signedout_tile_theme.dart';
import 'text_field_theme.dart';
import 'typography.dart';

class DevFestThemeData extends ThemeExtension<DevFestThemeData> {
  /// Create and register new themes here
  final DevfestTextTheme? textTheme;
  final DevfestButtonTheme? buttonTheme;
  final DevfestOutlinedButtonTheme? outlinedButtonTheme;
  final DevfestBottomNavTheme? bottomNavTheme;
  final DevfestTextFieldTheme? textFieldTheme;
  final DevfestUserHeaderTile? headerTileTheme;
  final Color? backgroundColor;
  final Color? onBackgroundColor;

  DevFestThemeData({
    this.textTheme,
    this.backgroundColor,
    this.bottomNavTheme,
    this.buttonTheme,
    this.outlinedButtonTheme,
    this.textFieldTheme,
    this.onBackgroundColor,
    this.headerTileTheme,
  });

  DevFestThemeData.light()
      : this(
            textTheme: DevfestTextTheme.light(),
            backgroundColor: DevfestColors.primariesYellow100,
            buttonTheme: DevfestButtonTheme.light(),
            outlinedButtonTheme: DevfestOutlinedButtonTheme.light(),
            bottomNavTheme: DevfestBottomNavTheme.light(),
            textFieldTheme: DevfestTextFieldTheme.light(),
            onBackgroundColor: DevfestColors.grey10,
            headerTileTheme: DevfestUserHeaderTile.light());

  DevFestThemeData.dark()
      : this(
          textTheme: DevfestTextTheme.dark(),
          backgroundColor: DevfestColors.backgroundDark,
          textFieldTheme: DevfestTextFieldTheme.dark(),
          buttonTheme: DevfestButtonTheme.dark(),
          outlinedButtonTheme: DevfestOutlinedButtonTheme.dark(),
          bottomNavTheme: DevfestBottomNavTheme.dark(),
          onBackgroundColor: DevfestColors.backgroundLight,
          headerTileTheme: DevfestUserHeaderTile.dark(),
        );

  @override
  DevFestThemeData copyWith({
    DevfestTextTheme? textTheme,
    DevfestButtonTheme? buttonTheme,
    DevfestOutlinedButtonTheme? outlinedButtonTheme,
    DevfestBottomNavTheme? bottomNavTheme,
    DevfestTextFieldTheme? textFieldTheme,
    Color? onBackgroundColor,
    DevfestUserHeaderTile? headerTileTheme,
  }) {
    return DevFestThemeData(
      textTheme: textTheme ?? this.textTheme,
      buttonTheme: buttonTheme ?? this.buttonTheme,
      outlinedButtonTheme: outlinedButtonTheme ?? this.outlinedButtonTheme,
      bottomNavTheme: bottomNavTheme ?? this.bottomNavTheme,
      textFieldTheme: textFieldTheme ?? this.textFieldTheme,
      onBackgroundColor: onBackgroundColor ?? this.onBackgroundColor,
      headerTileTheme: headerTileTheme ?? this.headerTileTheme,
    );
  }

  @override
  DevFestThemeData lerp(DevFestThemeData? other, double t) {
    if (other is! DevFestThemeData) return this;
    return DevFestThemeData(
      textTheme: textTheme?.lerp(other.textTheme, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      onBackgroundColor:
          Color.lerp(onBackgroundColor, other.onBackgroundColor, t),
      buttonTheme: buttonTheme?.lerp(other.buttonTheme, t),
      outlinedButtonTheme:
          outlinedButtonTheme?.lerp(other.outlinedButtonTheme, t),
      bottomNavTheme: bottomNavTheme?.lerp(other.bottomNavTheme, t),
      textFieldTheme: textFieldTheme?.lerp(other.textFieldTheme, t),
      headerTileTheme: headerTileTheme?.lerp(other.headerTileTheme, t),
    );
  }
}
