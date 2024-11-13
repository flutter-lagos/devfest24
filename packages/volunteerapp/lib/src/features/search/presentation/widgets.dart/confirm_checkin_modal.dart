import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteerapp/src/features/home/application/check_in_view_model.dart';
import 'package:volunteerapp/src/features/search/presentation/screens/search_screen.dart';
import 'package:volunteerapp/src/shared/shared.dart';

Future<void> confirmCheckInModal(BuildContext context,
    {required Map<dynamic, dynamic> option, Gender? gender,required ValueChanged onFemaleChanged,required ValueChanged onMaleChanged,}) {
  return showDevfestBottomModal(context, children: [
    EmojiContainer(
      emoji: '🧐',
    ),
    SizedBox(
      height: 16,
    ),
    Text(
      'Check In attendee?',
      style: DevfestTheme.of(context)
          .textTheme
          ?.headerH5
          ?.copyWith(color: DevfestColors.grey10),
    ),
    Constants.smallVerticalGutter.verticalSpace,
    
      DefaultTextStyle(
        style: DevfestTheme.of(context)
            .textTheme!
            .bodyBody2Medium!
            .copyWith(color: DevfestColors.grey60),
        child: Text.rich(TextSpan(children: [
          TextSpan(text: 'In order to check in'),
          TextSpan(text: ' ${option['fullname']}, ', style:TextStyle(fontWeight: FontWeight.w700,color: DevfestColors.grey10)),
          TextSpan(text: '\nkindly select their gender below.'),
        ]),
        textAlign: TextAlign.center,
        ),
      ),
      Constants.smallVerticalGutter.verticalSpace,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            
            children: [

              Checkbox(value: gender==Gender.female, onChanged: onFemaleChanged,semanticLabel: 'Select Female Gender',),
              8.horizontalSpace,
              Text('Female',style: DevfestTheme.of(context)
                .textTheme!
                .bodyBody2Medium!
                .copyWith(color: DevfestColors.grey60),),
            ],
          ),
          35.horizontalSpace,
          Row(
            children: [

              Checkbox(value: gender==Gender.male, onChanged: onFemaleChanged,semanticLabel: 'Select Male Gender',),
              8.horizontalSpace,
              Text('Male',style: DevfestTheme.of(context)
                .textTheme!
                .bodyBody2Medium!
                .copyWith(color: DevfestColors.grey60),),
            ],
          ),
         
        ],
      ),
   
    Constants.verticalGutter.verticalSpace,
    DevfestOutlinedButton(
      onPressed: () {
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
    Consumer(
      builder: (context,ref,_) {
        return DevfestFilledButton(
          onPressed: () {
            ref.read(checkInVMNotifier.notifier).checkInUser(context, option['id']);
          },
          title: ref.watch(checkInVMNotifier.select((vm) => vm.uiState.isLoading))
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
      }
    ),
  ]);
}
