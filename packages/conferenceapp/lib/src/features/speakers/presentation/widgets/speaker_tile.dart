import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/features/dashboard/model/model.dart';
import 'package:flutter/material.dart';
import '../../../../shared/shared.dart';

class SpeakerTile extends StatelessWidget {
  const SpeakerTile({super.key, required this.speaker, this.onTap});

  final SpeakerDto speaker;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius:
          const BorderRadius.all(Radius.circular(Constants.verticalGutter)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(
          Radius.circular(Constants.verticalGutter),
        ),
        child: SpeakerInfo(
          name: speaker.fullname,
          shortBio: '${speaker.title}, ${speaker.company}',
          avatarUrl: speaker.imageUrl,
        ),
      ),
    );
  }
}

class SpeakerInfo extends StatelessWidget {
  const SpeakerInfo({
    super.key,
    this.avatarUrl = '',
    required this.name,
    required this.shortBio,
  });

  final String name;
  final String shortBio;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Material(
          color: DevfestColors.primariesGreen80,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Constants.smallVerticalGutter),
            ),
            side: BorderSide(color: DevfestColors.primariesBlue50, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: CachedNetworkImage(
              imageUrl: avatarUrl,
              height: 48.h,
              width: 48.w,
            ),
            // FlutterLogo(size: 48),
          ),
        ),
        Constants.horizontalGutter.horizontalSpace,
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    DevfestTheme.of(context).textTheme?.bodyBody1Semibold?.semi,
              ),
              (Constants.smallVerticalGutter / 2).verticalSpace,
              Text(
                shortBio,
                style: DevfestTheme.of(context)
                    .textTheme
                    ?.bodyBody3Medium
                    ?.medium
                    .applyColor(DevfestColors.grey50.possibleDarkVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
