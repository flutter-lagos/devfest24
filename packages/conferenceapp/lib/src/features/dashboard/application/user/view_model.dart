import 'package:cave/cave.dart';
import 'package:devfest24/src/shared/shared.dart';

import '../../model/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'ui_state.dart';

final userViewModelNotifier =
    AutoDisposeNotifierProvider<UserViewModel, UserUiState>(
        () => UserViewModel());

final class UserViewModel extends AutoDisposeNotifier<UserUiState> {
  late DashboardApiService _apiService;

  @override
  UserUiState build() {
    _apiService = const DashboardApiService(ConferenceNetworkClient());
    return const UserUiState.initial();
  }

  Future<void> fetchUserProfile({bool refresh = false}) async {
    await launch(state.ref, (model) async {
      state = model.emit(state.copyWith(uiState: UiState.loading));
      final result = await _apiService.fetchUserProfile(refresh: refresh);

      state = model.emit(
        await result.fold(
          (left) => state.copyWith(uiState: UiState.error, error: left),
          (right) => state.copyWith(uiState: UiState.success, user: right),
        ),
      );
    }, displayError: false);
  }
}
