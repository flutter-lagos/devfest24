// ignore_for_file: non_constant_identifier_names

import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'header.dart';
import 'tab_button.dart';

enum EventDay {
  one,
  two;
}

class AgendaHeader extends StatelessWidget {
  const AgendaHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.eventDay = EventDay.one,
    this.onEventDayChanged,
    this.onFilterSelected,
    this.gutter,
  });

  final Widget title;
  final Widget? subtitle;
  final TextStyle? titleStyle;
  final EventDay eventDay;
  final ValueChanged<EventDay>? onEventDayChanged;
  final VoidCallback? onFilterSelected;
  final Widget? gutter;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderText(
            title: title,
            titleStyle: titleStyle,
            // titleAction: onFilterSelected == null
            //     ? null
            //     : SizedBox(
            //         width: 87.w,
            //         child: DevfestFilledButton.small(
            //           onPressed: onFilterSelected,
            //           backgroundColor:
            //               DevfestColors.primariesYellow90.possibleDarkVariant,
            //           prefixIcon: Icon(
            //             IconsaxOutline.filter,
            //             color: DevfestTheme.of(context)
            //                 .textTheme
            //                 ?.titleTitle2Semibold
            //                 ?.color,
            //           ),
            //           title: const Text('Filter'),
            //           titleStyle: TextStyle(
            //             color: DevfestTheme.of(context)
            //                 .textTheme
            //                 ?.titleTitle2Semibold
            //                 ?.color,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            subtitle: subtitle,
            subtitleStyle: DevfestTheme.of(context)
                .textTheme
                ?.bodyBody2Medium
                ?.medium
                .applyColor(DevfestColors.grey50.possibleDarkVariant),
          ),
          if (onEventDayChanged != null) ...[
            gutter ?? Constants.largeVerticalGutter.verticalSpace,
            Row(
              children: [
                Flexible(
                  child: DevfestTabButton(
                    title: const Text('Friday'),
                    selected: eventDay == EventDay.one,
                    onTap: () {
                      onEventDayChanged?.call(EventDay.one);
                    },
                  ),
                ),
                Flexible(
                  child: DevfestTabButton(
                    title: const Text('Saturday'),
                    selected: eventDay == EventDay.two,
                    onTap: () {
                      onEventDayChanged?.call(EventDay.two);
                    },
                  ),
                ),
              ],
            ),
          ],
          Constants.verticalGutter.verticalSpace,
        ],
      ),
    );
  }
}

class SliverAgendaHeader extends StatefulWidget {
  const SliverAgendaHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.eventDay = EventDay.one,
    this.onEventDayChanged,
    this.onFilterSelected,
  });

  final Widget title;
  final Widget? subtitle;
  final TextStyle? titleStyle;
  final EventDay eventDay;
  final ValueChanged<EventDay>? onEventDayChanged;
  final VoidCallback? onFilterSelected;

  @override
  State<SliverAgendaHeader> createState() => _SliverAgendaHeaderState();
}

class _SliverAgendaHeaderState extends State<SliverAgendaHeader> {
  ScrollPosition? _position;
  bool? hideHeaders;
  bool? prevHideHeaders;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_position != null) {
      _position!.removeListener(_isScrollingListener);
    }
    _position = Scrollable.maybeOf(context)?.position;
    if (_position != null) {
      _position!.addListener(_isScrollingListener);
    }
  }

  @override
  void dispose() {
    if (_position != null) {
      _position!.isScrollingNotifier.removeListener(_isScrollingListener);
    }
    super.dispose();
  }

  void _handleScrollDirection(ScrollDirection direction) {
    setState(() {
      prevHideHeaders = hideHeaders;
      hideHeaders = switch (direction) {
        ScrollDirection.forward => false,
        ScrollDirection.reverse => true,
        ScrollDirection.idle => null,
      };
    });
  }

  void _isScrollingListener() {
    assert(_position != null);

    if (_position!.isScrollingNotifier.value) {
      _handleScrollDirection(_position!.userScrollDirection);
    } else {
      _handleScrollDirection(_position!.userScrollDirection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverResizingHeader(
      minExtentPrototype: Material(
        color: DevfestTheme.of(context).backgroundColor,
        child: AgendaHeader(
          title: widget.title,
          eventDay: widget.eventDay,
          subtitle: switch (hideHeaders) {
            true => null,
            false => widget.subtitle,
            null => prevHideHeaders == true ? null : widget.subtitle,
          },
          onFilterSelected: switch (hideHeaders) {
            true => null,
            false => widget.onFilterSelected,
            null => prevHideHeaders == true ? null : widget.onFilterSelected,
          },
          onEventDayChanged: widget.onEventDayChanged,
          gutter: switch (hideHeaders) {
            true => Constants.smallVerticalGutter.verticalSpace,
            false => Constants.verticalGutter.verticalSpace,
            null => prevHideHeaders == true
                ? Constants.smallVerticalGutter.verticalSpace
                : Constants.verticalGutter.verticalSpace,
          },
        ),
      ),
      maxExtentPrototype: Material(
        child: AgendaHeader(
          title: widget.title,
          subtitle: switch (hideHeaders) {
            true => null,
            false => widget.subtitle,
            null => prevHideHeaders == true ? null : widget.subtitle,
          },
          titleStyle: widget.titleStyle,
          onFilterSelected: widget.onFilterSelected,
          eventDay: widget.eventDay,
          onEventDayChanged: widget.onEventDayChanged,
          gutter: switch (hideHeaders) {
            true => Constants.smallVerticalGutter.verticalSpace,
            false => Constants.verticalGutter.verticalSpace,
            null => prevHideHeaders == true
                ? Constants.smallVerticalGutter.verticalSpace
                : Constants.verticalGutter.verticalSpace,
          },
        ),
      ),
      child: Material(
        child: AgendaHeader(
          title: widget.title,
          subtitle: switch (hideHeaders) {
            true => null,
            false => widget.subtitle,
            null => prevHideHeaders == true ? null : widget.subtitle,
          },
          titleStyle: widget.titleStyle,
          onFilterSelected: widget.onFilterSelected,
          eventDay: widget.eventDay,
          onEventDayChanged: widget.onEventDayChanged,
          gutter: switch (hideHeaders) {
            true => Constants.smallVerticalGutter.verticalSpace,
            false => Constants.verticalGutter.verticalSpace,
            null => prevHideHeaders == true
                ? Constants.smallVerticalGutter.verticalSpace
                : Constants.verticalGutter.verticalSpace,
          },
        ),
      ),
    );
  }
}
