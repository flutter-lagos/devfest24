import 'package:cave/cave.dart';
import 'package:devfest24/src/shared/shared.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dashboard/application/application.dart';
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

  Future<void> uploadUserResume(String userId) async {
    if (state.resumeLink.isNotEmpty && state.resumeLink.isNotEmpty) {
      await launch(
        state.ref,
        (model) async {
          state = state.copyWith(uiState: UiState.loading);
          final resumeResult =
              await _apiService.uploadUserResume(state.resumeLink, userId);

          state = model.emit(
            await resumeResult.fold(
              (left) => state.copyWith(uiState: UiState.error, error: left),
              (right) async {
                final userVM = ref.read(userViewModelNotifier.notifier);
                final currentUser = userVM.state.user;

                final updatedUser = currentUser.copyWith(resumeUrl: right);

                userVM.state = userVM.state.copyWith(user: updatedUser);

                return state.copyWith(
                    uiState: UiState.success, resumeLink: right);
              },
            ),
          );
        },
      );
    }
  }
}
