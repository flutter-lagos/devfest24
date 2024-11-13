import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:flutter/material.dart';
import 'package:volunteerapp/src/features/home/model/model.dart';
import 'package:volunteerapp/src/features/home/presentation/screens/home_screen.dart';
import 'package:volunteerapp/src/routing/router.dart';
import 'package:volunteerapp/src/shared/shared.dart';

List<Widget> checkInSuccessContent(BuildContext context,
    {required AttendeeResult attendee, required Widget confetti}) {
  return [
    Stack(
      children: [
        Column(
          children: [
            EmojiContainer(
              emoji: '🥳',
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Check In Complete?',
              style: DevfestTheme.of(context)
                  .textTheme
                  ?.headerH5
                  ?.copyWith(color: DevfestColors.grey10),
            ),
            Constants.smallVerticalGutter.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 15.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  gradient: LinearGradient(
                      colors: [Color(0xFFC471ED), Color(0xFF12C2E9)])),
              child: Column(
                children: [
                  Container(
                    width: 64.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: DevfestColors.grey100),
                        color: DevfestColors.grey100.withOpacity(0.3)),
                    child: Center(
                      child: Text(attendee.fullname.getInitials,
                          style: DevfestTheme.of(context)
                              .textTheme
                              ?.headerH5
                              ?.copyWith(color: DevfestColors.grey100)),
                    ),
                  ),
                  Text(attendee.fullname,
                      style: DevfestTheme.of(context)
                          .textTheme
                          ?.titleTitle2Medium),
                  Constants.verticalGutter.verticalSpace,
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 6.h),
                        decoration: BoxDecoration(
                            border: Border.all(color: DevfestColors.grey100),
                            color: DevfestColors.grey100.withOpacity(0.3)),
                        child: Row(
                          children: [
                            Icon(IconsaxOutline.ticket_star),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text('Type: ',
                                style: DevfestTheme.of(context)
                                    .textTheme
                                    ?.headerH5
                                    ?.copyWith(color: DevfestColors.grey100)),
                          ],
                        ),
                      ),
                      Constants.horizontalGutter.horizontalSpace,
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 6.h),
                          decoration: BoxDecoration(
                              border: Border.all(color: DevfestColors.grey100),
                              color: DevfestColors.grey100.withOpacity(0.3)),
                          child: Row(
                            children: [
                              Icon(IconsaxOutline.ticket_2),
                              SizedBox(
                                width: 4.w,
                              ),
                              Flexible(
                                child: Text('ID: ${attendee.id}',
                                    style: DevfestTheme.of(context)
                                        .textTheme
                                        ?.headerH5
                                        ?.copyWith(
                                            color: DevfestColors.grey100)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Constants.verticalGutter.verticalSpace,
            DevfestFilledButton(
              onPressed: () {
                context.goNamed(HomeScreen.route);
              },
              title: Text(
                'Go back home',
                style: DevfestTheme.of(context)
                    .textTheme
                    ?.buttonMediumBold
                    ?.copyWith(color: DevfestColors.grey100),
              ),
            )
          ],
        ),
        confetti
      ],
    )
  ];
}
