import 'package:cave/cave.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:volunteerapp/src/routing/routing.dart';

extension DevfestColorsX on Color {
  ///  utility extension used on colors when prototyping from light-mode
  ///  converts colors passed in light mode to their respective dark-mode
  ///  variants
  Color get possibleDarkVariant {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return this;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isDarkMode) {
      return switch (this) {
        DevfestColors.grey40 || DevfestColors.grey60 => DevfestColors.grey70,
        DevfestColors.grey10 => DevfestColors.backgroundLight,
        // DevfestColors.grey50 =>
        DevfestColors.primariesYellow90 => DevfestColors.grey40,
        DevfestColors.primariesYellow100 => DevfestColors.backgroundDark,
        _ => this,
      };
    }

    return this;
  }
}

extension NumberFormatExtension on num {
  String get formattedWithDecimalPattern =>
      NumberFormat.decimalPattern().format(this);
}

extension DateFomatExtension on String {
  String get formattedDate => formatDate(this);

  String formatDate(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();

    // Calculate difference in days
    int dayDifference = now.difference(dateTime).inDays;

    // Format time as "9:45am"
    String formattedTime = DateFormat('h:mma').format(dateTime).toLowerCase();

    if (dayDifference == 0) {
      return 'Today, $formattedTime';
    } else if (dayDifference == 1) {
      return 'Yesterday, $formattedTime';
    } else {
      // For other dates, format as "Sep 16, 9:45am"
      String formattedDate = DateFormat('MMM d').format(dateTime);
      return '$formattedDate, $formattedTime';
    }
  }
}

extension NameInitialsX on String {
  String get getInitials => getNameInitials(this);

  String getNameInitials(String fullName) {
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return names[0][0] + names[1][0];
    } else {
      return names[0][0];
    }
  }
}
