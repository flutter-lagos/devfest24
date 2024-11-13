import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteerapp/src/features/home/application/check_in_view_model.dart';
import 'package:volunteerapp/src/features/home/application/user_seach_view_model.dart';
import 'package:volunteerapp/src/features/home/model/model.dart';
import 'package:volunteerapp/src/features/search/presentation/widgets.dart/widgets.dart';

class CheckInAttendeeModal extends ConsumerStatefulWidget {
  const CheckInAttendeeModal({super.key, required this.attendee});
  final AttendeeResult attendee;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CheckInAttendeeModalState();
}

class _CheckInAttendeeModalState extends ConsumerState<CheckInAttendeeModal> {
  @override
  Widget build(BuildContext context) {
    ref.listen(checkInVMNotifier, (previous, next) {
      if (next.uiState.isSuccess) {
        Navigator.of(context).pop();

        showCheckinSuccessBottomModal(context,
            attendee: ref.watch(usersearchVM).selectedAttendee);
        return;
      }
    });
    return Padding(
      padding: EdgeInsets.fromLTRB(16.0.w, 0.0, 16.0.w, 16.0.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConfirmCheckInModalHeader(fullName: widget.attendee.fullname),
          Constants.smallVerticalGutter.verticalSpace,
          StatefulBuilder(builder: (context, StateSetter setModalState) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    DevfestCheckbox(
                      semanticLabel: 'Select Female Gender',
                      value: ref.watch(checkInVMNotifier
                          .select((vm) => vm.gender == 'female')),
                      onChanged: (value) {
                        ref
                            .read(checkInVMNotifier.notifier)
                            .onGenderChanged('female');

                        setModalState(() {});
                      },
                    ),
                    8.horizontalSpace,
                    Text(
                      'Female',
                      style: DevfestTheme.of(context)
                          .textTheme!
                          .bodyBody2Medium!
                          .copyWith(color: DevfestColors.grey60),
                    ),
                  ],
                ),
                35.horizontalSpace,
                Row(
                  children: [
                    DevfestCheckbox(
                      semanticLabel: 'Select Male Gender',
                      value: ref.watch(checkInVMNotifier).gender == 'male',
                      onChanged: (value) {
                        ref
                            .read(checkInVMNotifier.notifier)
                            .onGenderChanged('male');
                        setModalState(() {});
                      },
                    ),
                    8.horizontalSpace,
                    Text(
                      'Male',
                      style: DevfestTheme.of(context)
                          .textTheme!
                          .bodyBody2Medium!
                          .copyWith(color: DevfestColors.grey60),
                    ),
                  ],
                ),
              ],
            );
          }),
          Constants.verticalGutter.verticalSpace,
          DevfestOutlinedButton(
            onPressed: () {
              ref.read(checkInVMNotifier.notifier).onGenderChanged('');

              Navigator.of(context).pop();
            },
            title: Text(
              'Cancel',
              style: DevfestTheme.of(context)
                  .textTheme
                  ?.buttonMediumBold
                  ?.copyWith(color: DevfestColors.grey10),
            ),
          ),
          Constants.verticalGutter.verticalSpace,
          Consumer(builder: (context, ref, _) {
            return DevfestFilledButton(
              onPressed: () {
                ref
                    .read(checkInVMNotifier.notifier)
                    .checkInUser(context, widget.attendee.id);
              },
              title: ref.watch(
                      checkInVMNotifier.select((vm) => vm.uiState.isLoading))
                  ? CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      backgroundColor: Colors.white,
                      strokeWidth: 2.0,
                    )
                  : Text(
                      'Yes check in',
                      style: DevfestTheme.of(context)
                          .textTheme
                          ?.buttonMediumBold
                          ?.copyWith(color: DevfestColors.grey100),
                    ),
            );
          }),
        ],
      ),
    );
  }
}
