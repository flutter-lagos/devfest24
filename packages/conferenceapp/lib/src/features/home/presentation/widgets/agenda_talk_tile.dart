import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/features/dashboard/model/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/shared.dart';

class AgendaTalkTile extends StatelessWidget {
  const AgendaTalkTile(
      {super.key, required this.speaker, required this.session, this.onTap});

  final SpeakerDto speaker;
  final SessionDto session;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('hh:mm a');
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(Constants.verticalGutter),
        ),
        side: BorderSide(
          color: DevfestColors.grey70.possibleDarkVariant,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(Constants.verticalGutter),
          ),
          side: BorderSide(
            color: DevfestColors.grey70.possibleDarkVariant,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
                  horizontal: Constants.largeHorizontalGutter, vertical: 14)
              .r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    session.categories.first.toUpperCase(),
                    style: DevfestTheme.of(context)
                        .textTheme
                        ?.bodyBody3Medium
                        ?.medium
                        .applyColor(DevfestColors.grey60.possibleDarkVariant),
                  ),
                  FavouriteIcon(
                    onTap: () {},
                  ),
                ],
              ),
              Constants.verticalGutter.verticalSpace,
              Text(
                session.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: DevfestTheme.of(context)
                    .textTheme
                    ?.bodyBody1Semibold
                    ?.semi
                    .applyColor(DevfestColors.grey10.possibleDarkVariant),
              ),
              Constants.smallVerticalGutter.verticalSpace,
              Text(
                session.descrption,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: DevfestTheme.of(context)
                    .textTheme
                    ?.bodyBody2Medium
                    ?.semi
                    .applyColor(DevfestColors.grey50.possibleDarkVariant),
              ),
              Constants.verticalGutter.verticalSpace,
              SpeakerInfo(
                name: speaker.fullname,
                shortBio: '${speaker.title}, ${speaker.company}',
                avatarUrl: speaker.imageUrl,
              ),
              Constants.verticalGutter.verticalSpace,
              Row(
                children: [
                  IconText(
                    IconsaxOutline.clock,
                    dateFormat.format(DateTime.now()),
                  ),
                  Constants.largeHorizontalGutter.horizontalSpace,
                  const IconText(IconsaxOutline.location, 'Hall A')
                ],
              ),
            ],
          ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Constants.smallVerticalGutter),
            ),
            side: BorderSide(color: DevfestColors.primariesBlue50, width: 2),
          ),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: CachedNetworkImage(
              imageUrl: avatarUrl,
              height: 48,
              width: 48,
            ),
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
