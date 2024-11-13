import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:cave/ui_utils/container_properties.dart';
import 'package:devfest24/src/features/dashboard/application/application.dart';
import 'package:devfest24/src/features/speakers/presentation/widgets/speaker_social_media.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:devfest24/src/shared/widgets/speaker_talk_info_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart'
    hide Text, List, Key, Radius, Brightness, Map;

import '../../../dashboard/model/model.dart';
import 'package:collection/collection.dart';

class SpeakerDetailsScreen extends ConsumerStatefulWidget {
  static const route = '/home/speaker-details';

  const SpeakerDetailsScreen({super.key, required this.speaker});

  final SpeakerDto speaker;

  @override
  ConsumerState<SpeakerDetailsScreen> createState() =>
      _SpeakerDetailsScreenState();
}

class _SpeakerDetailsScreenState extends ConsumerState<SpeakerDetailsScreen> {
  late bool isDayOne = widget.speaker.day == 1;

  @override
  Widget build(BuildContext context) {
    final session = isDayOne
        ? ref.watch(dayOneScheduleProvider.select((sessions) =>
            sessions.firstWhereOrNull(
                (session) => session.title == widget.speaker.sessionTitle)))
        : ref.watch(dayTwoScheduleProvider.select((sessions) =>
            sessions.firstWhereOrNull(
                (session) => session.title == widget.speaker.sessionTitle)));
    return Scaffold(
      appBar: AppBar(
        leading: GoBackButton(
          onTap: context.pop,
        ),
        leadingWidth: 120.w,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w).add(
            EdgeInsets.only(bottom: MediaQuery.viewPaddingOf(context).bottom)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  color: DevfestColors.success70),
              child: Wrap(
                spacing: 8,
                children: [
                  const Icon(IconsaxBold.people),
                  Text(
                    '${session?.venue.size ?? 'N\\A'} Slots',
                    style: DevfestTheme.of(context)
                        .textTheme
                        ?.bodyBody2Medium
                        ?.medium,
                  ),
                ],
              ),
            ),
            Constants.verticalGutter.verticalSpace,
            Padding(
              padding: EdgeInsets.only(right: 32.w),
              child: Text(
                widget.speaker.sessionTitle,
                style: DevfestTheme.of(context)
                    .textTheme
                    ?.titleTitle2Semibold
                    ?.semi,
              ),
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
                  padding: EdgeInsets.all(2),
                  child: Semantics(
                    label: 'Speaker Image',
                    child: CachedNetworkImage(
                      imageUrl: widget.speaker.imageUrl,
                      height: 56.h,
                      width: 56.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Constants.horizontalGutter.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.speaker.name,
                        style: DevfestTheme.of(context)
                            .textTheme
                            ?.bodyBody1Semibold
                            ?.semi,
                      ),
                      Constants.smallVerticalGutter.verticalSpace,
                      Text(
                        widget.speaker.title,
                        style: DevfestTheme.of(context)
                            .textTheme
                            ?.bodyBody2Medium
                            ?.semi
                            .applyColor(DevfestColors.grey50),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Constants.verticalGutter.verticalSpace,
            Wrap(
              spacing: 8,
              children: [
                SpeakersTalkInfoPill(
                  icon: IconsaxOutline.clock,
                  title: session?.startTime ?? 'N\\A',
                ),
                SpeakersTalkInfoPill(
                  icon: IconsaxOutline.location,
                  title: session?.venue.name ?? 'N\\A',
                ),
              ],
            ),
            Constants.largeVerticalGutter.verticalSpace,
            Text(
              'SPEAKER BIO',
              style: DevfestTheme.of(context)
                  .textTheme
                  ?.bodyBody3Medium
                  ?.semi
                  .applyColor(DevfestColors.grey50),
            ),
            Constants.verticalGutter.verticalSpace,
            Text(
              widget.speaker.bio,
              style: DevfestTheme.of(context).textTheme?.bodyBody2Medium?.semi,
            ),
            Constants.largeVerticalGutter.verticalSpace,
            Text(
              'SPEAKER SOCIALS',
              style: DevfestTheme.of(context)
                  .textTheme
                  ?.bodyBody3Medium
                  ?.semi
                  .applyColor(DevfestColors.grey50),
            ),
            Constants.verticalGutter.verticalSpace,
            Wrap(
              spacing: 16.w,
              runSpacing: 16.h,
              children: widget.speaker.links.entries.map((entry) {
                final icon = switch (entry.key.toLowerCase()) {
                  'github' => Github(),
                  'linkedin' => Linkedin(),
                  'twitter' => Twitter(),
                  'facebook' => Facebook(),
                  'dribble' => Dribbble(),
                  _ => Icon(IconsaxOutline.link_21,
                      semanticLabel: 'Social Media Link'),
                };

                return SpeakerSocialMedia(
                    icon: icon,
                    onTap: () => launchWebUrl(entry.value.toString()));
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
