import 'package:cave/cave.dart';
import 'package:devfest24/src/features/dashboard/model/model.dart';
import 'package:devfest24/src/features/speakers/presentation/widgets/widgets.dart';
import 'package:devfest24/src/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/shared.dart';
import '../../../dashboard/application/application.dart';
import '../../../more/presentation/screens/my_qr_code.dart';
import 'screens.dart';

class SpeakersHomeScreen extends ConsumerStatefulWidget {
  const SpeakersHomeScreen({super.key});

  @override
  ConsumerState<SpeakersHomeScreen> createState() => _SpeakersHomeScreenState();
}

class _SpeakersHomeScreenState extends ConsumerState<SpeakersHomeScreen> {
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
        padding: EdgeInsets.symmetric(horizontal: Constants.horizontalMargin.w),
        child: RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(speakersViewModelNotifier.notifier)
                .fetchSpeakers(refresh: true);
          },
          child: CustomScrollView(
            controller: _scrollController,
            key: PageStorageKey('SpeakersPageScrollView'),
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAgendaHeader(
                title: const Text('🎤 Speakers'),
                subtitle: const Text(
                  'Industry veterans ready to share knowledge with you on their experiences',
                ),
                eventDay: _day,
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
                onFilterSelected: () {},
              ),
              [
                ProviderScope(
                  overrides: [
                    _speakersProvider
                        .overrideWithValue(ref.watch(dayOneSpeakersProvider)),
                  ],
                  child: _SpeakersList(),
                ),
                ProviderScope(
                  overrides: [
                    _speakersProvider
                        .overrideWithValue(ref.watch(dayTwoSpeakersProvider)),
                  ],
                  child: _SpeakersList(),
                ),
              ].elementAt(_day.index),
              SliverToBoxAdapter(child: Constants.verticalGutter.verticalSpace),
            ],
          ),
        ),
      ),
    );
  }
}

final _speakersProvider = Provider.autoDispose<List<SpeakerDto>>((ref) {
  throw UnimplementedError();
});

class _SpeakersList extends ConsumerWidget {
  const _SpeakersList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speakers = ref.watch(_speakersProvider);
    return SliverList.separated(
      itemBuilder: (context, index) {
        final speaker = speakers[index];
        return SpeakerTile(
          speaker: speaker,
          onTap: () {
            context.goNamed(
              SpeakerDetailsScreen.route,
              arguments: speaker,
            );
          },
        );
      },
      separatorBuilder: (context, index) =>
          Constants.verticalGutter.verticalSpace,
      itemCount: speakers.length,
    );
  }
}
