import 'package:cave/cave.dart';
import 'package:volunteerapp/src/features/onboarding/model/sign_in_response_dto.dart';
import 'package:volunteerapp/src/shared/ui_model/ui_state_model.dart';

final class SignInState extends Devfest2024UiState {
  final String email;
  final String ticketId;
  final SignInResponseDto user;
  const SignInState({super.uiState, super.error, required this.user,required this.email,required this.ticketId});
  SignInState.initial() : this(uiState: UiState.idle,error:const EmptyException() ,user: SignInResponseDto.empty(),ticketId: '',email: 
     '',);

  SignInState copyWith(
      {UiState? uiState,
      Devfest2024Exception? error,
      SignInResponseDto? user,
      String? ticketId,
      String? email,
      }) {
    return SignInState(
      user: user ?? this.user,
      uiState: uiState ?? this.uiState,
      error: error ?? this.error,
      email: email ?? this.email,
      ticketId: ticketId ?? this.ticketId,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
