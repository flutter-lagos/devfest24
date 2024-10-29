import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';

import '../../../dashboard/model/model.dart';

class ConferenceSponsorTile extends StatelessWidget {
  const ConferenceSponsorTile(
      {super.key, required this.sponsor, this.linkOnTap});

  final SponsorDto sponsor;
  final VoidCallback? linkOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minHeight: 160.r),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: DevfestColors.inverseGradientGradient,
              color: Colors.green,
              borderRadius: BorderRadius.all(
                  Radius.circular(Constants.smallVerticalGutter)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Constants.smallVerticalGutter).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SponsorTierTag(sponsor.category),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                            vertical: Constants.largeVerticalGutter)
                        .h,
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: sponsor.logoUrl,
                        height: 122.h,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: _SponsorLinkTag(linkOnTap),
                  )
                ],
              ),
            ),
          ),
        ),
        Constants.smallVerticalGutter.verticalSpace,
        Text(
          sponsor.name,
          style: DevfestTheme.of(context)
              .textTheme
              ?.bodyBody1Medium
              ?.medium
              .applyColor(DevfestColors.grey30.possibleDarkVariant),
        ),
      ],
    );
  }
}

class _SponsorTierTag extends StatelessWidget {
  const _SponsorTierTag(this.tagName);

  final String tagName;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DevfestColors.backgroundSoftLight,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(Constants.smallVerticalGutter)),
        side: BorderSide(
          color: DevfestColors.grey100,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
                horizontal: Constants.horizontalGutter,
                vertical: Constants.smallVerticalGutter / 2)
            .r,
        child: Text(
          tagName,
          style: DevfestTheme.of(context)
              .textTheme
              ?.bodyBody3Medium
              ?.medium
              .applyColor(DevfestColors.grey100),
        ),
      ),
    );
  }
}

class _SponsorLinkTag extends StatelessWidget {
  const _SponsorLinkTag(this.onTap);

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DevfestColors.backgroundSoftLight,
      shape: const CircleBorder(
        side: BorderSide(color: DevfestColors.grey100),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(
          side: BorderSide(color: DevfestColors.grey100),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Constants.largeVerticalGutter / 4).r,
          child: Icon(
            IconsaxOutline.link,
            size: 12.r,
            color: DevfestColors.grey100,
          ),
        ),
      ),
    );
  }
}
