import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:flutter/material.dart';

class NoResult extends StatelessWidget {
  const NoResult({
    super.key,
    required this.textTheme,
  });

  final DevfestTextTheme? textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42.r,
            backgroundColor: DevfestColors.warning80,
            child: Text(
              "🤨",
              textAlign: TextAlign.center,
              style: textTheme?.bodyBody4Medium?.copyWith(
                color: DevfestColors.grey60,
                fontSize: 42.sp,
              ),
            ),
          ),
          Constants.verticalGutter.verticalSpace,
          Text(
            "Oops, No result",
            textAlign: TextAlign.center,
            style: textTheme?.headerH5?.copyWith(
              color: DevfestColors.grey10,
            ),
          ),
          Constants.smallVerticalGutter.verticalSpace,
          Text(
            "It seems you have encountered a Sodiq.\nThis ticket ID is invalid or cannot be found in our system.",
            textAlign: TextAlign.center,
            style: textTheme?.bodyBody2Medium?.copyWith(
              color: DevfestColors.grey60,
            ),
          ),
        ],
      ),
    );
  }
}
