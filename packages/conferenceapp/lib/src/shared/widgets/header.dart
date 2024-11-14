import 'package:cave/cave.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    super.key,
    this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.titleAction,
  });

  final Widget? title;
  final Widget? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Widget? titleAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...[
          Row(
            children: [
              Expanded(
                child: AnimatedDefaultTextStyle(
                  style: DevfestTheme.of(context)
                      .textTheme!
                      .headerH6!
                      .semi
                      .merge(titleStyle),
                  duration: Constants.kAnimationDur,
                  child: title!,
                ),
              ),
              if (titleAction != null) titleAction!,
            ],
          ),
          SizedBox(height: Constants.smallVerticalGutter.h),
        ],
        if (subtitle != null)
          AnimatedDefaultTextStyle(
            style: DevfestTheme.of(context)
                .textTheme!
                .bodyBody1Medium!
                .medium
                .copyWith(color: DevfestColors.grey40.possibleDarkVariant)
                .merge(subtitleStyle),
            duration: Constants.kAnimationDur,
            child: subtitle!,
          ),
      ],
    );
  }
}
