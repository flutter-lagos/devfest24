import 'package:cave/cave.dart';
import 'package:devfest24/src/features/dashboard/model/model.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:flutter/material.dart';

extension DevfestColorsX on Color {
  ///  utility extension used on colors when prototyping from light-mode
  ///  converts colors passed in light mode to their respective dark-mode
  ///  variants
  Color get possibleDarkVariant {
    final context = Devfest2024Router.rootNavigatorKey.currentContext;
    if (context == null) return this;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isDarkMode) {
      return switch (this) {
        DevfestColors.grey40 || DevfestColors.grey60 => DevfestColors.grey70,
        DevfestColors.grey10 => DevfestColors.backgroundLight,
        DevfestColors.grey70 => DevfestColors.grey50,
        // DevfestColors.grey50 =>
        DevfestColors.primariesYellow90 => DevfestColors.grey40,
        DevfestColors.primariesYellow100 => DevfestColors.backgroundDark,
        _ => this,
      };
    }

    return this;
  }
}

extension ListX<E> on List<E> {
  List<E> safeSublist(int length) {
    try {
      return sublist(0, length);
    } on RangeError {
      return this;
    }
  }
}

extension SpeakerNames on List<SpeakerDto> {
  String get getNames => getSpeakerNames(this);
  String getSpeakerNames(List<SpeakerDto> speakers) {
    final names = speakers.map((speaker) => speaker.fullname).toList();
    return names.join(', ');
  }
}