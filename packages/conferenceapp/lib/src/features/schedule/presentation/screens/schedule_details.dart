import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:cave/ui_utils/container_properties.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:devfest24/src/shared/widgets/speaker_talk_info_pill.dart';
import 'package:flutter/material.dart';

class ScheduleDetailsScreen extends StatelessWidget {
  static const route = '/home/schedule-details';

  const ScheduleDetailsScreen({super.key});

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
              '😘 Women Tech Makers Breakfast',
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
                  'Femi Falana',
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
              'Wake up to reality! Nothing ever goes as planned in this accursed world. The longer you live, the more you realize that the only things that truly exist in this reality are merely pain, suffering and futility. Listen, everywhere you look in this world, wherever there is light, there will always be shadows to be found as well. As long as there is a concept of victors, the vanquished will also exist. The selfish intent of wanting to preserve peace, initiates war and hatred is born in order to protect love. There are nexuses causal relationships that cannot be separated.',
              style: DevfestTheme.of(context).textTheme?.bodyBody2Medium?.semi,
            ),
          ],
        ),
      ),
    );
  }
}
