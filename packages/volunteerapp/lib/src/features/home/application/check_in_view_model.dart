import 'package:cave/cave.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteerapp/src/features/home/application/ui_state.dart';
import 'package:volunteerapp/src/features/home/application/user_seach_view_model.dart';
import 'package:volunteerapp/src/features/home/model/model.dart';
import 'package:volunteerapp/src/features/onboarding/presentation/screens/onboarding_login.dart';

import 'package:volunteerapp/src/features/search/presentation/widgets.dart/widgets.dart';
import 'package:volunteerapp/src/routing/router.dart';
import 'package:volunteerapp/src/shared/shared.dart';

final ConfettiController _contoller =
    ConfettiController(duration: Duration(seconds: 20));
final checkInVMNotifier =
    AutoDisposeNotifierProvider<CheckInViewModel, CheckInState>(
        () => CheckInViewModel());

final class CheckInViewModel extends AutoDisposeNotifier<CheckInState> {
  late VolunteerHomeApiService _apiService;

  @override
  CheckInState build() {
    ref.onDispose(() {
      print('disposed');
    });

    _apiService = const VolunteerHomeApiService(ConferenceNetworkClient());
    return CheckInState.initial();
  }

  void onUserIdChanged(num input) {
    state = state.copyWith(day: input);
  }

  void onDayChanged(num input) {
    state = state.copyWith(day: input);
    print('day ${state.day}');
  }

  void onGenderChanged(String? input) {
    if (input == 'female') {
      state = state.copyWith(gender: 'female');
    } else if (input == 'male') {
      state = state.copyWith(gender: 'male');
    } else {
      state = state.copyWith(gender: '');
    }
  }

  Future<void> checkInUser(BuildContext context, String id) async {
    print('hullo1');
    await launch(state.ref, (model) async {
      state = model.emit(state.copyWith(uiState: UiState.loading));
      final dto = CheckUserInRequestDto(
          userId: id, day: state.day, gender: state.gender);
      final result = await _apiService.checkInUser(dto);
      final selectedAttendee = ref.watch(usersearchVM).selectedAttendee;
      state = model.emit(result
          .fold((left) => state.copyWith(uiState: UiState.error, error: left),
              (right) {
        print('hullo');
        print('right $right');
        Navigator.of(context).pop();
        showDevfestBottomModal(context,
            children: checkInSuccessContent(context,
                attendee: selectedAttendee,
                confetti: ConfettiWidget(
                  confettiController: _contoller,
                  blastDirectionality: BlastDirectionality.explosive,
                )));
        return state.copyWith(
          uiState: UiState.success,
          checkedInattendee: right,
        );
      }));
    });
  }

  Future<void> logout(BuildContext context) async {
    await launch(state.ref, (model) async {
      state = model.emit(state.copyWith(uiState: UiState.loading));

      final result = await _apiService.logout();

      state = model.emit(await result
          .fold((left) => state.copyWith(uiState: UiState.error, error: left),
              (right) async {
        context.goNamed(OnboardingLoginScreen.route);
        return state.copyWith(
          uiState: UiState.success,
        );
      }));
    });
  }
}
