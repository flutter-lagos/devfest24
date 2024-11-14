import 'package:cave/cave.dart';
import 'package:devfest24/src/features/schedule/presentation/presentation.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/application/application.dart';
import '../../../more/presentation/screens/my_qr_code.dart';

class ScheduleHomeScreen extends ConsumerStatefulWidget {
  const ScheduleHomeScreen({super.key});

  @override
  ConsumerState<ScheduleHomeScreen> createState() => _ScheduleHomeScreenState();
}

class _ScheduleHomeScreenState extends ConsumerState<ScheduleHomeScreen> {
  EventDay _day = EventDay.one;
  late ScrollController _scrollController;
  Map<int, double> scrollOffsets = {};

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        scrollOffsets[_day.index] = _scrollController.offset;
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100.w,
        leading: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: Constants.horizontalMargin.w),
              child: GdgLogo.normal(),
            ),
          ],
        ),
        actions: [
          CheckInButton(
            isLoggedIn: ref.watch(
                userViewModelNotifier.select((vm) => vm.user.id.isNotEmpty)),
            onCheckInTap: () {
              context.goNamed(MyQrCodeScreen.route);
            },
          ),
          Constants.horizontalMargin.horizontalSpace,
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constants.horizontalMargin)
                .w,
        child: RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(scheduleViewModelNotifier.notifier)
                .fetchSchedule(refresh: true);
          },
          child: CustomScrollView(
            controller: _scrollController,
            key: PageStorageKey('SchedulePageScrollView'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAgendaHeader(
                title: const Text('📆 Schedule'),
                subtitle: const Text(
                  'Our schedule is packed with incredible content all for you!!',
                ),
                eventDay: _day,
                onFilterSelected: () {},
                onEventDayChanged: (day) {
                  setState(() {
                    _day = day;
                  });

                  if (scrollOffsets.containsKey(_day.index)) {
                    _scrollController.jumpTo(scrollOffsets[_day.index]!);
                  } else {
                    _scrollController.jumpTo(0);
                  }
                },
              ),
              [
                SliverList.separated(
                  itemBuilder: (context, index) {
                    final session = ref.watch(dayOneScheduleProvider)[index];
                    return ConferenceScheduleTile(session: session);
                  },
                  separatorBuilder: (context, index) =>
                      Constants.verticalGutter.verticalSpace,
                  itemCount: ref.watch(dayOneScheduleProvider).length,
                ),
                // day two
                SliverList.separated(
                  itemBuilder: (context, index) {
                    final session = ref.watch(dayTwoScheduleProvider)[index];
                    return ConferenceScheduleTile(session: session);
                  },
                  separatorBuilder: (context, index) =>
                      Constants.verticalGutter.verticalSpace,
                  itemCount: ref.watch(dayTwoScheduleProvider).length,
                )
              ].elementAt(_day.index),
              SliverToBoxAdapter(child: Constants.verticalGutter.verticalSpace),
            ],
          ),
        ),
      ),
    );
  }
}
