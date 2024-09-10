import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

enum ScheduleTileType { session, breakout }

class ConferenceScheduleTile extends StatefulWidget {
  const ConferenceScheduleTile({
    super.key,
    this.onTap,
    required this.type,
  });

  final VoidCallback? onTap;
  final ScheduleTileType type;

  @override
  State<ConferenceScheduleTile> createState() => _ConferenceScheduleTileState();
}

class _ConferenceScheduleTileState extends State<ConferenceScheduleTile> {
  double maxHeightOfTile = 0;
  final _expandedTileKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
      final RenderBox renderBox =
          _expandedTileKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        maxHeightOfTile = renderBox.size.height;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        maxHeightOfTile = 0;
      });

      Future.microtask(() {
        final RenderBox renderBox =
            _expandedTileKey.currentContext!.findRenderObject() as RenderBox;
        if (maxHeightOfTile != renderBox.size.height) {
          setState(() {
            maxHeightOfTile = renderBox.size.height;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('hh:mm a');

    return InkWell(
      onTap: widget.onTap,
      borderRadius: const BorderRadius.horizontal(
        right: Radius.circular(Constants.verticalGutter),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeightOfTile == 0 ? double.infinity : maxHeightOfTile,
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(
                      DateTime.now().subtract(const Duration(hours: 5))),
                  style: DevfestTheme.of(context)
                      .textTheme
                      ?.bodyBody4Medium
                      ?.medium,
                ),
                Text(
                  dateFormat.format(DateTime.now()),
                  style: DevfestTheme.of(context)
                      .textTheme
                      ?.bodyBody4Medium
                      ?.medium,
                ),
              ],
            ),
            (Constants.horizontalGutter * 1.5).horizontalSpace,
            Expanded(
              key: _expandedTileKey,
              child: switch (widget.type) {
                ScheduleTileType.session => const _SessionInfo(),
                ScheduleTileType.breakout => const _BreakoutScheduleInfo(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionInfo extends StatelessWidget {
  const _SessionInfo();

  @override
  Widget build(BuildContext context) {
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
                  'mobile development'.toUpperCase(),
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
              'Appreciating the usefulness of football memes in decoding intent',
              style: DevfestTheme.of(context)
                  .textTheme
                  ?.bodyBody1Semibold
                  ?.semi
                  .applyColor(DevfestColors.grey10.possibleDarkVariant),
            ),
            Constants.smallVerticalGutter.verticalSpace,
            Text(
              'Celebrate the women tech makers at their annual breakfast',
              style: DevfestTheme.of(context)
                  .textTheme
                  ?.bodyBody2Medium
                  ?.semi
                  .applyColor(DevfestColors.grey50.possibleDarkVariant),
            ),
            Constants.verticalGutter.verticalSpace,
            const SpeakerInfo(
              name: 'Samuel Abada',
              shortBio: 'Flutter Engineer, Tesla',
              avatarUrl: '',
            ),
            Constants.verticalGutter.verticalSpace,
            const IconText(IconsaxOutline.location, 'Hall A'),
          ],
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
        const Material(
          color: DevfestColors.primariesGreen80,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Constants.smallVerticalGutter),
            ),
            side: BorderSide(color: DevfestColors.primariesBlue50, width: 2),
          ),
          child: Padding(
            padding: EdgeInsets.all(2),
            child: FlutterLogo(size: 48),
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

class FavouriteIcon extends StatelessWidget {
  const FavouriteIcon({super.key, this.isFavourite = false, this.onTap});

  final bool isFavourite;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: isFavourite ? 'Remove from favourites' : 'Add to favourites',
      ),
      child: Material(
        borderRadius: const BorderRadius.all(
            Radius.circular(Constants.smallVerticalGutter)),
        color: DevfestColors.primariesYellow90.possibleDarkVariant,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(
              Radius.circular(Constants.smallVerticalGutter)),
          child: Padding(
            padding: const EdgeInsets.all(Constants.largeVerticalGutter / 4).r,
            child: Icon(
              isFavourite ? IconsaxBold.star : IconsaxOutline.star,
              color: DevfestColors.grey50.possibleDarkVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _BreakoutScheduleInfo extends StatelessWidget {
  const _BreakoutScheduleInfo();

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius:
            const BorderRadius.all(Radius.circular(Constants.verticalGutter)),
        side: BorderSide(
            color: DevfestColors.grey70.possibleDarkVariant, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(Constants.verticalGutter.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Initials(initial: 'W'),
            Constants.verticalGutter.verticalSpace,
            Text(
              '😘  Women Tech Makers Breakfast',
              style:
                  DevfestTheme.of(context).textTheme?.titleTitle2Semibold?.semi,
            ),
            Constants.smallVerticalGutter.verticalSpace,
            Text(
              'Celebrate the women tech makers at their annual breakfast',
              style: DevfestTheme.of(context)
                  .textTheme
                  ?.bodyBody2Medium
                  ?.medium
                  .copyWith(color: DevfestColors.grey50.possibleDarkVariant),
            ),
            Constants.verticalGutter.verticalSpace,
            const IconText(IconsaxOutline.location, 'Hall A'),
          ],
        ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DevfestColors.primariesBlue80.possibleDarkVariant,
      borderRadius: const BorderRadius.all(
          Radius.circular(Constants.smallVerticalGutter)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Constants.smallVerticalGutter,
          horizontal: Constants.largeVerticalGutter / 2,
        ).r,
        child: Text(
          initial.toUpperCase(),
          textAlign: TextAlign.center,
          style: DevfestTheme.of(context)
              .textTheme
              ?.titleTitle1Semibold
              ?.semi
              .copyWith(
                  color: DevfestColors.primariesBlue20.possibleDarkVariant,
                  height: 1.34),
        ),
      ),
    );
  }
}