import 'package:cave/cave.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/widgets.dart';

class HomeAgendaHeader extends StatelessWidget {
  const HomeAgendaHeader({
    super.key,
    required this.title,
    this.eventDay = EventDay.one,
    this.onEventDayChanged,
    this.onFilterSelected,
  });

  final Widget title;
  final EventDay eventDay;
  final ValueChanged<EventDay>? onEventDayChanged;
  final VoidCallback? onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AgendaHeader(
        onFilterSelected: onFilterSelected,
        title: title,
        titleStyle:
            DevfestTheme.of(context).textTheme?.titleTitle2Semibold?.semi,
        eventDay: eventDay,
        onEventDayChanged: onEventDayChanged,
        gutter: Constants.smallVerticalGutter.verticalSpace,
      ),
    );
  }
}
