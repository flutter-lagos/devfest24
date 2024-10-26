import 'package:cave/cave.dart';
import 'package:cave/constants.dart';
import 'package:devfest24/src/features/schedule/presentation/presentation.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/application/application.dart';

class ScheduleHomeScreen extends ConsumerStatefulWidget {
  const ScheduleHomeScreen({super.key});

  @override
  ConsumerState<ScheduleHomeScreen> createState() => _ScheduleHomeScreenState();
}

class _ScheduleHomeScreenState extends ConsumerState<ScheduleHomeScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(dayOneSessionsProvider, (_, next) {});
    ref.listenManual(dayTwoSessionsProvider, (_, next) {});
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
                .read(agendasViewModelNotifier.notifier)
                .fetchAgenda(refresh: true);
          },
          child: CustomScrollView(
            slivers: [
              SliverAgendaHeader(
                title: const Text('📆 Schedule'),
                subtitle: const Text(
                  'Our schedule is packed with incredible content all for you!!',
                ),
                onFilterSelected: () {},
                onEventDayChanged: (_) {},
              ),
              SliverList.separated(
                itemBuilder: (context, index) {
                  final session = ref.watch(dayOneSessionsProvider)[index];
                  final agenda = ref
                      .watch(agendasViewModelNotifier)
                      .agendas
                      .firstWhere((agenda) => session.periodId == agenda.id);
                  return ConferenceScheduleTile(
                    start: agenda.start!,
                    duration: agenda.duration,
                    session: session,
                    type: session.categories.isEmpty
                        ? ScheduleTileType.breakout
                        : ScheduleTileType.session,
                    onTap: () {
                      context.goNamed(ScheduleDetailsScreen.route);
                    },
                  );
                },
                separatorBuilder: (context, index) =>
                    Constants.verticalGutter.verticalSpace,
                itemCount: ref.watch(dayOneSessionsProvider).length,
              ),
              SliverToBoxAdapter(child: Constants.verticalGutter.verticalSpace),
            ],
          ),
        ),
      ),
    );
  }
}
