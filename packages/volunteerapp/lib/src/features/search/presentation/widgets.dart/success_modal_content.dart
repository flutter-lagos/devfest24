import 'dart:math';

import 'package:cave/cave.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteerapp/src/features/home/application/check_in_view_model.dart';
import 'package:volunteerapp/src/features/home/application/user_seach_view_model.dart';
import 'package:volunteerapp/src/features/home/model/model.dart';
import 'package:volunteerapp/src/features/home/presentation/screens/home_screen.dart';
import 'package:volunteerapp/src/routing/router.dart';
import 'package:volunteerapp/src/shared/shared.dart';

Future<void> showCheckinSuccessBottomModal(BuildContext context,
    {required AttendeeResult attendee}) async {
  await showModalBottomSheet(
    isScrollControlled: true,
    // constraints: BoxConstraints.loose(Size(MediaQuery.of(context).size.width,
    //     MediaQuery.of(context).size.height * 0.45)),
    isDismissible: false,
    backgroundColor: DevfestColors.warning100,
    showDragHandle: true,
    context: context,
    builder: (context) => CheckInSuccessModal(
      attendee: attendee,
    ),
  );
}

class CheckInSuccessModal extends ConsumerStatefulWidget {
  const CheckInSuccessModal({super.key, required this.attendee});
  final AttendeeResult attendee;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CheckInSuccessModalState();
}

class _CheckInSuccessModalState extends ConsumerState<CheckInSuccessModal> {
  late ConfettiController controller;
  @override
  void initState() {
    controller = ConfettiController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ticketType = widget.attendee.ticketTag == 'day_two'
        ? '2 Day Ticket'
        : '1 Day Ticket';
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.0.w, 0.0, 16.0.w, 16.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EmojiContainer(
                emoji: '🥳',
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Check In Complete',
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
                        child: Text(widget.attendee.fullname.getInitials,
                            style: DevfestTheme.of(context)
                                .textTheme
                                ?.headerH5
                                ?.copyWith(color: DevfestColors.grey100)),
                      ),
                    ),
                    Text(widget.attendee.fullname,
                        style: DevfestTheme.of(context)
                            .textTheme
                            ?.titleTitle2Medium
                            ?.copyWith(color: DevfestColors.grey100)),
                    Constants.verticalGutter.verticalSpace,
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 6.h),
                          decoration: BoxDecoration(
                              border: Border.all(color: DevfestColors.grey100),
                              borderRadius: BorderRadius.circular(56.r),
                              color: DevfestColors.grey100.withOpacity(0.3)),
                          child: Row(
                            children: [
                              Icon(
                                IconsaxOutline.ticket_star,
                                color: DevfestColors.grey100,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text('Type:  $ticketType ',
                                  style: DevfestTheme.of(context)
                                      .textTheme
                                      ?.bodyBody3Medium
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
                                border:
                                    Border.all(color: DevfestColors.grey100),
                                borderRadius: BorderRadius.circular(56.r),
                                color: DevfestColors.grey100.withOpacity(0.3)),
                            child: Row(
                              children: [
                                Icon(
                                  IconsaxOutline.ticket_2,
                                  color: DevfestColors.grey100,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Flexible(
                                  child: Text('ID: ${widget.attendee.id}',
                                      style: DevfestTheme.of(context)
                                          .textTheme
                                          ?.bodyBody3Medium
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
                  ref.read(checkInVMNotifier.notifier).onGenderChanged('');
                  context.goNamed(HomeScreen.route);
                  var day = ref.watch(checkInVMNotifier).day;

                  ref.read(usersearchVM.notifier).getAttendees(day);
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
        ),
        ConfettiWidget(
          confettiController: controller,
          blastDirection: pi / 2,
          emissionFrequency: 0.05,
        )
      ],
    );
  }
}
