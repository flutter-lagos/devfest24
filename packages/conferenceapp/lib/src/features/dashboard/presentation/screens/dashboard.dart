import 'package:cave/cave.dart';
import 'package:devfest24/src/features/dashboard/application/application.dart';
import 'package:devfest24/src/features/home/presentation/presentation.dart';
import 'package:devfest24/src/features/more/presentation/presentation.dart';
import 'package:devfest24/src/features/schedule/presentation/presentation.dart';
import 'package:devfest24/src/features/speakers/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/shared.dart';

class DashboardScreen extends StatelessWidget {
  static const route = '/home';

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _ViewState._tabs.length,
      child: _View(),
    );
  }
}

class _View extends ConsumerStatefulWidget {
  const _View();

  @override
  ConsumerState<_View> createState() => _ViewState();
}

class _ViewState extends ConsumerState<_View> {
  late int index;
  static const _tabs = [
    KeepAliveWidget(child: HomeScreen()),
    KeepAliveWidget(child: ScheduleHomeScreen()),
    KeepAliveWidget(child: SpeakersHomeScreen()),
    KeepAliveWidget(child: MoreHomeScreen()),
  ];

  void _onPageChanged(int page) {
    DefaultTabController.of(context).index = page;
  }

  void _onPageChangedListener() {
    setState(() {
      index = DefaultTabController.of(context).index;
    });
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Future.wait([
        ref.read(userViewModelNotifier.notifier).fetchUserProfile(),
        ref.read(sponsorsViewModelNotifier.notifier).fetchSponsors(),
        ref.read(speakersViewModelNotifier.notifier).fetchSpeakers(),
        ref.read(agendasViewModelNotifier.notifier).fetchAgenda(),
      ]);
      ConferenceAppStorageService.instance.setIsFirstLaunch(false);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    index = DefaultTabController.of(context).index;
    DefaultTabController.of(context).addListener(_onPageChangedListener);
  }

  @override
  Widget build(BuildContext context) {
    return OverlayScreenLoadingIndicator(
      isLoading:
          ref.watch(userViewModelNotifier.select((vm) => vm.uiState.isLoading)),
      child: Scaffold(
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: _tabs,
        ),
        bottomNavigationBar: DevfestBottomNav(
          index: DefaultTabController.of(context).index,
          onTap: _onPageChanged,
          items: const [
            DevfestBottomNavItem(
              label: 'Home',
              icon: Icon(IconsaxOutline.home_2),
            ),
            DevfestBottomNavItem(
              label: 'Schedule',
              icon: Icon(IconsaxOutline.calendar_1),
            ),
            DevfestBottomNavItem(
              label: 'Speakers',
              icon: Icon(IconsaxOutline.microphone),
            ),
            DevfestBottomNavItem(
              label: 'More',
              icon: Icon(IconsaxOutline.more_square),
            ),
          ],
        ),
      ),
    );
  }
}
