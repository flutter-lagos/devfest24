import 'package:cave/cave.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/shared.dart';
import '../../model/model.dart';

part 'ui_state.dart';

final sponsorsViewModelNotifier =
    AutoDisposeNotifierProvider<SponsorsViewModel, SponsorsUiState>(
  () => SponsorsViewModel(),
);

final sponsorsProvider = Provider.autoDispose<List<SponsorDto>>((ref) {
  return ref.watch(sponsorsViewModelNotifier.select((vm) => vm.sponsors));
}, dependencies: [sponsorsViewModelNotifier]);

final class SponsorsViewModel extends AutoDisposeNotifier<SponsorsUiState> {
  late DashboardApiService _apiService;

  @override
  SponsorsUiState build() {
    _apiService = const DashboardApiService(ConferenceNetworkClient());
    return const SponsorsUiState.initial();
  }

  Future<void> fetchSponsors({bool refresh = false}) async {
    await launch(
      state.ref,
      (model) async {
        state = model.emit(state.copyWith(uiState: UiState.loading));
        final result = await _apiService.getSponsors(refresh: refresh);

        state = model.emit(
          result.fold(
            (left) => state.copyWith(uiState: UiState.error, error: left),
            (right) => state.copyWith(
                uiState: UiState.success, sponsors: right.sponsors),
          ),
        );
      },
    );
  }
}
