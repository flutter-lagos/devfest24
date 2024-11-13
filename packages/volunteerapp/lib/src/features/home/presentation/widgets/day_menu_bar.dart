import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteerapp/src/features/home/application/check_in_view_model.dart';
import 'package:volunteerapp/src/shared/extensions.dart';

class DayMenuBar extends ConsumerStatefulWidget {
  const DayMenuBar({
    super.key,
  });

  @override
  ConsumerState<DayMenuBar> createState() => _DayMenuBarState();
}

class _DayMenuBarState extends ConsumerState<DayMenuBar> {
  String selectedDay = 'Day 1';
  @override
  Widget build(BuildContext context) {
    return MenuBar(
      style: MenuStyle(
        elevation: WidgetStateProperty.all(0),
        padding:
            WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 10.h)),
        alignment: Alignment.center,
        backgroundColor:
            WidgetStateProperty.all(DevfestColors.primariesYellow90),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(56),
          ),
        ),
      ),
      children: [
        SubmenuButton(
          menuStyle: MenuStyle(
            padding:
                WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 10.h)),
            elevation: WidgetStateProperty.all(5),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            backgroundColor: WidgetStateProperty.all(
                DevfestTheme.of(context).backgroundColor),
          ),
          menuChildren: [
            MenuItemButton(
              onPressed: () {
                setState(() {
                  selectedDay = 'Day 1';
                });
                ref.read(checkInVMNotifier.notifier).onDayChanged(1);
              },
              child: Text(
                'Day 1',
                style: DevfestTheme.of(context)
                    .textTheme
                    ?.bodyBody3Medium
                    ?.medium
                    .applyColor(DevfestColors.grey10.possibleDarkVariant),
              ),
            ),
            MenuItemButton(
              onPressed: () {
                setState(() {
                  selectedDay = 'Day 2';
                });
                ref.read(checkInVMNotifier.notifier).onDayChanged(2);
              },
              child: Text(
                'Day 2',
                style: DevfestTheme.of(context)
                    .textTheme
                    ?.bodyBody3Medium
                    ?.medium
                    .applyColor(DevfestColors.grey10.possibleDarkVariant),
              ),
            )
          ],
          child: Row(
            children: [
              Text(selectedDay),
              Constants.horizontalGutter.horizontalSpace,
              const Icon(
                IconsaxOutline.arrow_down_1,
                color: DevfestColors.grey10,
              ),
            ],
          ),
        )
      ],
    );
  }
}
