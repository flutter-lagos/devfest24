import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../dashboard/model/model.dart';

enum ScheduleTileType { session, breakout }

class ConferenceScheduleTile extends StatefulWidget {
  const ConferenceScheduleTile({
    super.key,
    this.onTap,
    required this.type,
    required this.session,
    required this.start,
    required this.duration,
  });

  final SessionDto session;
  final DateTime start;
  final int duration;
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
                  dateFormat.format(widget.start),
                  style: DevfestTheme.of(context)
                      .textTheme
                      ?.bodyBody4Medium
                      ?.medium,
                ),
                Text(
                  dateFormat.format(
                      widget.start.add(Duration(minutes: widget.duration))),
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
                ScheduleTileType.session => _SessionInfo(widget.session),
                ScheduleTileType.breakout =>
                  _BreakoutScheduleInfo(widget.session),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionInfo extends StatelessWidget {
  const _SessionInfo(this.session);

  final SessionDto session;

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
              name: session.speakers.first.fullname,
              shortBio:
                  '${session.speakers.first.title}, ${session.speakers.first.company}',
              avatarUrl: session.speakers.first.imageUrl,
            ),
            Constants.verticalGutter.verticalSpace,
            IconText(IconsaxOutline.location, session.venue.id),
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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

class _BreakoutScheduleInfo extends StatelessWidget {
  const _BreakoutScheduleInfo(this.session);

  final SessionDto session;

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
            _Initials(initial: session.title[0]),
            Constants.verticalGutter.verticalSpace,
            Text(
              session.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style:
                  DevfestTheme.of(context).textTheme?.titleTitle2Semibold?.semi,
            ),
            Constants.smallVerticalGutter.verticalSpace,
            Text(
              session.descrption,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: DevfestTheme.of(context)
                  .textTheme
                  ?.bodyBody2Medium
                  ?.medium
                  .copyWith(color: DevfestColors.grey50.possibleDarkVariant),
            ),
            Constants.verticalGutter.verticalSpace,
            IconText(IconsaxOutline.location, session.venue.id),
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
