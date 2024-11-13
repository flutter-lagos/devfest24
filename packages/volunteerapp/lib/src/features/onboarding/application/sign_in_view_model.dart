import 'package:cave/cave.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteerapp/src/features/onboarding/application/sign_in_ui_state.dart';
import 'package:volunteerapp/src/features/onboarding/model/model.dart';
import 'package:volunteerapp/src/shared/shared.dart';

final signInVMNotifier =
    AutoDisposeNotifierProvider<SignInViewModel, SignInState>(
        () => SignInViewModel());

final class SignInViewModel extends AutoDisposeNotifier<SignInState> {
  late VolunteerOnboardingApiService _apiService;

  @override
  SignInState build() {
    _apiService =
        const VolunteerOnboardingApiService(ConferenceNetworkClient());
    return SignInState.initial();
  }

  void onEmailChanged(String input) {
    state = state.copyWith(email: input);
  }

  void OnIdChanged(String input) {
    state = state.copyWith(ticketId: input);
  }

  Future<void> signIn() async {
    await launch(state.ref, (model) async {
      state = model.emit(state.copyWith(uiState: UiState.loading));
      final dto =
          SignInRequestDto(id: state.ticketId, emailAddress: state.email);
      final result = await _apiService.signIn(dto);

      state = model.emit(await result
          .fold((left) => state.copyWith(uiState: UiState.error, error: left),
              (right) async {
        await ConferenceAppStorageService.instance.setUserToken(right.token);
        await ConferenceAppStorageService.instance.setuserName(right.fullName);
       
        return state.copyWith(uiState: UiState.success, user: right);
      }));
    });
  }
}
