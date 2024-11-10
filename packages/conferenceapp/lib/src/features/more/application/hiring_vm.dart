import 'package:cave/cave.dart';
import 'package:devfest24/src/shared/shared.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/model.dart';

part 'hiring_state.dart';

final hiringVMNotifier =
    AutoDisposeNotifierProvider<HiringViewModel, HiringState>(
        () => HiringViewModel());

final class HiringViewModel extends AutoDisposeNotifier<HiringState> {
  late HiringApiService _apiService;

  @override
  HiringState build() {
    _apiService = const HiringApiService(ConferenceNetworkClient());
    return const HiringState();
  }

  void resumeChanged(String input) {
    state = state.copyWith(resumeLink: input);
  }

  Future<void> uploadUserResume() async {
    if (state.resumeLink.isNotEmpty && state.resumeLink.isNotEmpty) {
      // TODO: Revisit when upload is live
      await launch(
        state.ref,
        (model) async {
          state = state.copyWith(uiState: UiState.loading);
          final tokenResult =
              await _apiService.uploadUserResume(state.resumeLink);

          state = model.emit(
            await tokenResult.fold(
              (left) => state.copyWith(uiState: UiState.error, error: left),
              (right) => state.copyWith(uiState: UiState.success),
            ),
          );
        },
      );
    }
  }
}
