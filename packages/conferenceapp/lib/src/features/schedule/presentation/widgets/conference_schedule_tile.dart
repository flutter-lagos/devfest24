// ignore_for_file: depend_on_referenced_packages

import 'package:cave/cave.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/application/application.dart';
import 'package:collection/collection.dart';

enum ScheduleTileType { breakOut, general }

class ConferenceScheduleTile extends StatefulWidget {
  const ConferenceScheduleTile({
    super.key,
    this.onTap,
    required this.session,
  });

  final VoidCallback? onTap;

  final SessionEvent session;

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
      final RenderBox? renderBox =
          _expandedTileKey.currentContext?.findRenderObject() as RenderBox?;
      if (!mounted) return;
      setState(() {
        if (renderBox != null) maxHeightOfTile = renderBox.size.height;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      maxHeightOfTile = 0;

      Future.microtask(() {
        final RenderBox? renderBox =
            _expandedTileKey.currentContext?.findRenderObject() as RenderBox?;
        if (!mounted || renderBox == null) return;
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
                  widget.session.startTime,
                  style: DevfestTheme.of(context)
                      .textTheme
                      ?.bodyBody4Medium
                      ?.medium,
                ),
                Text(
                  widget.session.endTime,
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
              child: switch (widget.session.eventType) {
                EventType.breakout => _BreakoutScheduleInfo(widget.session),
                EventType.general ||
                EventType.postBreakout =>
                  _GeneralScheduleInfo(widget.session),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BreakoutScheduleInfo extends ConsumerWidget {
  const _BreakoutScheduleInfo(this.session);

  final SessionEvent session;

  @override
  Widget build(BuildContext context, ref) {
    final speakerInfo = ref.watch(speakersViewModelNotifier.select((vm) => vm
        .speakers
        .firstWhereOrNull((speaker) => speaker.id == session.facilitator)));
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
                  session.category.toUpperCase(),
                  style: DevfestTheme.of(context)
                      .textTheme
                      ?.bodyBody3Medium
                      ?.medium
                      .applyColor(DevfestColors.grey60.possibleDarkVariant),
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
            SpeakerInfo(
              name: speakerInfo?.name.toTitleCase ??
                  session.facilitator.split("-").join(" ").toTitleCase,
              shortBio: speakerInfo?.shortbio ?? '',
              avatarUrl: speakerInfo?.imageUrl ?? '',
            ),
            Constants.verticalGutter.verticalSpace,
            IconText(IconsaxOutline.location, session.venue.name.capitalize),
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
            child: Semantics(
              label: 'Speaker avatar',
              child: CachedNetworkImage(
                imageUrl: avatarUrl,
                height: 48.h,
                width: 48.w,
                fit: BoxFit.cover,
              ),
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

class _GeneralScheduleInfo extends StatelessWidget {
  const _GeneralScheduleInfo(this.session);

  final SessionEvent session;

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
              maxLines: null,
              // overflow: TextOverflow.ellipsis,
              style:
                  DevfestTheme.of(context).textTheme?.titleTitle2Semibold?.semi,
            ),
            Constants.verticalGutter.verticalSpace,
            IconText(IconsaxOutline.location, session.venue.name.capitalize),
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
