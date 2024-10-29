import 'package:cave/cave.dart';
import 'package:devfest24/src/shared/shared.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/model.dart';

part 'ui_state.dart';

final agendasViewModelNotifier =
    AutoDisposeNotifierProvider<AgendaViewModel, AgendaUiState>(
  () => AgendaViewModel(),
);

final dayOneSessionsProvider = Provider.autoDispose<List<SessionDto>>((ref) {
  return ref.watch(agendasViewModelNotifier.select((vm) => vm.agendas
      .where((agenda) => agenda.start?.day == 15)
      .fold([], (previous, next) => [...previous, ...next.sessions.sessions])));
}, dependencies: [agendasViewModelNotifier]);
final dayTwoSessionsProvider = Provider.autoDispose<List<SessionDto>>((ref) {
  return ref.watch(agendasViewModelNotifier.select((vm) => vm.agendas
      .where((agenda) => agenda.start?.day == 16)
      .fold([], (previous, next) => [...previous, ...next.sessions.sessions])));
}, dependencies: [agendasViewModelNotifier]);

final class AgendaViewModel extends AutoDisposeNotifier<AgendaUiState> {
  late DashboardApiService _apiService;

  @override
  AgendaUiState build() {
    _apiService = const DashboardApiService(ConferenceNetworkClient());
    return const AgendaUiState.initial();
  }

  Future<void> fetchAgenda({bool refresh = false}) async {
    await launch(state.ref, (model) async {
      state = model.emit(state.copyWith(uiState: UiState.loading));
      final result = await _apiService.fetchAgenda(refresh: refresh);

      state = model.emit(
        result.fold(
          (left) {
            if (left is WithCachedDataException) {
              return state.copyWith(
                uiState: UiState.error,
                error: left,
                agendas: (left.result as AgendasDto).agendas,
              );
            }

            return state.copyWith(uiState: UiState.error, error: left);
          },
          (right) =>
              state.copyWith(uiState: UiState.success, agendas: right.agendas),
        ),
      );
    });
  }
}
