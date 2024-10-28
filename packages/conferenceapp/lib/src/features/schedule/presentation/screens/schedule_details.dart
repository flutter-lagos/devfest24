import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:cave/ui_utils/container_properties.dart';
import 'package:devfest24/src/features/dashboard/application/agenda/view_model.dart';
import 'package:devfest24/src/features/dashboard/model/model.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:devfest24/src/shared/widgets/speaker_talk_info_pill.dart';
import 'package:flutter/material.dart';

class ScheduleDetailsScreen extends StatelessWidget {
  static const route = '/home/schedule-details';

  const ScheduleDetailsScreen({super.key,required this.session});
  final SessionDto session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(
          onTap: context.pop,
        ),
        leadingWidth: 120.w,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              session.title,
              style:
                  DevfestTheme.of(context).textTheme?.titleTitle2Semibold?.semi,
            ),
            Constants.verticalGutter.verticalSpace,
            Text(
              'HOST',
              style: DevfestTheme.of(context)
                  .textTheme
                  ?.bodyBody3Medium
                  ?.semi
                  .applyColor(DevfestColors.grey50),
            ),
            Constants.verticalGutter.verticalSpace,
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: ContainerProperties.defaultBorderRadius,
                    border: Border.all(
                        color: DevfestColors.primariesBlue60, width: 2),
                  ),
                  child: const FlutterLogo(size: 32),
                ),
                Constants.horizontalGutter.horizontalSpace,
                Text(
                  session.speakers.getNames,
                  style:
                      DevfestTheme.of(context).textTheme?.bodyBody1Medium?.semi,
                ),
              ],
            ),
            Constants.largeVerticalGutter.verticalSpace,
            const Wrap(
              spacing: 8,
              children: [
                SpeakersTalkInfoPill(
                  icon: IconsaxOutline.clock,
                  title: '10:00AM',
                ),
                SpeakersTalkInfoPill(
                  icon: IconsaxOutline.location,
                  title: 'Hall A',
                ),
              ],
            ),
            Constants.largeVerticalGutter.verticalSpace,
            Text(
              'DESCRIPTION',
              style: DevfestTheme.of(context)
                  .textTheme
                  ?.bodyBody3Medium
                  ?.semi
                  .applyColor(DevfestColors.grey50),
            ),
            Constants.verticalGutter.verticalSpace,
            Text(
              session.descrption,
              style: DevfestTheme.of(context).textTheme?.bodyBody2Medium?.semi,
            ),
          ],
        ),
      ),
    );
  }
}
