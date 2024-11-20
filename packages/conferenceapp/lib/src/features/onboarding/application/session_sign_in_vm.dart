import 'package:cave/cave.dart';
import 'package:devfest24/src/shared/shared.dart';
import '../model/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
part 'session_sign_in_state.dart';

final sessionSignInVMNotifier =
    AutoDisposeNotifierProvider<SessionSignInViewModel, SessionSignInState>(
        () => SessionSignInViewModel());

final class SessionSignInViewModel
    extends AutoDisposeNotifier<SessionSignInState> {
  late OnboardingApiService _apiService;

  @override
  SessionSignInState build() {
    _apiService = const OnboardingApiService(ConferenceNetworkClient());
    return const SessionSignInState();
  }

  void emailAddressOnChanged(String input) {
    state = state.copyWith(email: input);
  }

  void ticketIdOnChanged(String input) {
    state = state.copyWith(ticketId: input);
  }

  Future<void> initialiseUserSession() async {
    if (state.email.isNotEmpty && state.ticketId.isNotEmpty) {
      await launch(state.ref, (model) async {
        state = state.copyWith(uiState: UiState.loading);
        final dto = InitiateSessionRequestDto(
            ticketId: state.ticketId, emailAddress: state.email);
        final tokenResult = await _apiService.initiateUserSession(dto);

        state = model.emit(
          await tokenResult.fold(
            (left) => state.copyWith(uiState: UiState.error, error: left),
            (right) async {
              await ConferenceAppStorageService.instance.setUserToken(right);
              return state.copyWith(uiState: UiState.success);
            },
          ),
        );
      });
    }
  }
}
