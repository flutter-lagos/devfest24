import 'package:cave/cave.dart';
import 'package:flutter/material.dart';
import 'package:volunteerapp/src/shared/shared.dart';

class ConfirmCheckInModalHeader extends StatelessWidget {
  const ConfirmCheckInModalHeader({super.key, required this.fullName});
  final String fullName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmojiContainer(
          emoji: '🧐',
        ),
        16.verticalSpace,
        Text(
          'Check In attendee?',
          style: DevfestTheme.of(context)
              .textTheme
              ?.headerH5
              ?.copyWith(color: DevfestColors.grey10),
        ),
        8.verticalSpace,
        DefaultTextStyle(
          style: DevfestTheme.of(context)
              .textTheme!
              .bodyBody2Medium!
              .copyWith(color: DevfestColors.grey60),
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: 'In order to check in '),
              TextSpan(
                  text: fullName,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: DevfestColors.grey10)),
              TextSpan(text: '\nkindly select their gender below.'),
            ]),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
