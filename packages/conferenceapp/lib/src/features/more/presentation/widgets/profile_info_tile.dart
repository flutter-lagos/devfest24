import 'package:cave/cave.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';

class ProfileInfoTile extends StatelessWidget {
  const ProfileInfoTile({super.key, required this.title, required this.info});

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DevfestColors.primariesYellow90.possibleDarkVariant,
      borderRadius:
          const BorderRadius.all(Radius.circular(Constants.horizontalGutter)),
      child: Padding(
        padding: const EdgeInsets.all(Constants.verticalGutter).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style:
                  DevfestTheme.of(context).textTheme?.bodyBody2Semibold?.semi,
            ),
            Constants.smallVerticalGutter.verticalSpace,
            Text(
              info,
              style:
                  DevfestTheme.of(context).textTheme?.bodyBody2Medium?.medium,
            ),
          ],
        ),
      ),
    );
  }
}
