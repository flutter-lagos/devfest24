import 'package:cave/cave.dart';
import 'package:devfest24/src/features/dashboard/model/model.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'ui_state.dart';

final scheduleViewModelNotifier =
    AutoDisposeNotifierProvider<ScheduleViewModel, ScheduleUiState>(
  () => ScheduleViewModel(),
);

final dayOneScheduleProvider = Provider.autoDispose<List<SessionEvent>>(
  (ref) {
    final schedule = ref.watch(scheduleViewModelNotifier
        .select((vm) => vm.schedule.schedule[Day.day1]));

    if (schedule == null) return [];
    final sessions = <SessionEvent>[
      ...schedule.general.fold(
          <SessionEvent>[],
          (prev, session) => [
                ...prev,
                ...session.events.map((event) => SessionEvent(
                    venue: event.venue,
                    title: event.title,
                    startTime: session.startTime,
                    endTime: session.endTime,
                    duration: session.duration,
                    facilitator: event.facilitator,
                    panelists: event.panelists,
                    eventType: EventType.general))
              ]),
      ...schedule.breakouts.fold(
          <SessionEvent>[],
          (prev, session) => [
                ...prev,
                ...session.events.map((event) => SessionEvent(
                    venue: session.venue,
                    title: event.title,
                    startTime: event.startTime,
                    endTime: event.endTime,
                    duration: event.duration,
                    facilitator: event.facilitator,
                    category: session.category,
                    panelists: [],
                    eventType: EventType.breakout))
              ]),
      ...schedule.postBreakout.fold(
          <SessionEvent>[],
          (prev, session) => [
                ...prev,
                ...session.events.map((event) => SessionEvent(
                    venue: event.venue,
                    title: event.title,
                    startTime: session.startTime,
                    endTime: session.endTime,
                    duration: session.duration,
                    facilitator: event.facilitator,
                    panelists: event.panelists,
                    eventType: EventType.postBreakout))
              ]),
    ];
    return sessions;
  },
  dependencies: [scheduleViewModelNotifier],
);

final dayTwoScheduleProvider = Provider.autoDispose<List<SessionEvent>>(
  (ref) {
    final schedule = ref.watch(scheduleViewModelNotifier
        .select((vm) => vm.schedule.schedule[Day.day2]));

    if (schedule == null) return [];
    final sessions = <SessionEvent>[
      ...schedule.general.fold(
          <SessionEvent>[],
          (prev, session) => [
                ...prev,
                ...session.events.map((event) => SessionEvent(
                    venue: event.venue,
                    title: event.title,
                    startTime: session.startTime,
                    endTime: session.endTime,
                    duration: session.duration,
                    facilitator: event.facilitator,
                    panelists: event.panelists,
                    eventType: EventType.general))
              ]),
      ...schedule.breakouts.fold(
          <SessionEvent>[],
          (prev, session) => [
                ...prev,
                ...session.events.map((event) => SessionEvent(
                    venue: session.venue,
                    title: event.title,
                    startTime: event.startTime,
                    endTime: event.endTime,
                    duration: event.duration,
                    category: session.category,
                    facilitator: event.facilitator,
                    panelists: [],
                    eventType: EventType.breakout))
              ]),
      ...schedule.postBreakout.fold(
          <SessionEvent>[],
          (prev, session) => [
                ...prev,
                ...session.events.map((event) => SessionEvent(
                    venue: event.venue,
                    title: event.title,
                    startTime: session.startTime,
                    endTime: session.endTime,
                    duration: session.duration,
                    facilitator: event.facilitator,
                    panelists: event.panelists,
                    eventType: EventType.postBreakout))
              ]),
    ];
    return sessions;
  },
  dependencies: [scheduleViewModelNotifier],
);

final class ScheduleViewModel extends AutoDisposeNotifier<ScheduleUiState> {
  late DashboardApiService _apiService;

  @override
  ScheduleUiState build() {
    _apiService = const DashboardApiService(ConferenceNetworkClient());
    return ScheduleUiState.initial();
  }

  Future<void> fetchSchedule({bool refresh = false}) async {
    await launch(state.ref, (model) async {
      state = model.emit(state.copyWith(uiState: UiState.loading));
      final result = await _apiService.getSchedule(refresh: refresh);

      state = model.emit(
        result.fold((left) {
          if (left is WithCachedDataException) {
            return state.copyWith(
              uiState: UiState.error,
              error: left,
              schedule: left.result as ScheduleDto,
            );
          }

          return state.copyWith(uiState: UiState.error, error: left);
        },
            (right) =>
                state.copyWith(uiState: UiState.success, schedule: right)),
      );
    });
  }
}

enum EventType {
  general,
  breakout,
  postBreakout;
}

final class SessionEvent extends Equatable {
  final VenueDto venue;
  final String title;
  final String startTime;
  final String endTime;
  final int duration;
  final String facilitator;
  final String category;
  final List<String> panelists;
  final EventType eventType;

  const SessionEvent({
    required this.venue,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.category = '',
    required this.duration,
    required this.facilitator,
    required this.panelists,
    required this.eventType,
  });

  @override
  List<Object?> get props => [
        venue,
        title,
        startTime,
        endTime,
        duration,
        facilitator,
        panelists,
        eventType,
      ];
}
