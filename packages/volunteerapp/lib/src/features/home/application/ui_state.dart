import 'package:cave/cave.dart';
import 'package:volunteerapp/src/features/home/model/check_in_dto.dart';
import 'package:volunteerapp/src/features/home/model/user_search_dto.dart';
import 'package:volunteerapp/src/shared/ui_model/ui_state_model.dart';

final class CheckInState extends Devfest2024UiState {
  final String userId;
  final int day;
  final String gender;

  final CheckInUserResponseDto checkedInattendee;
  const CheckInState(
      {super.uiState,
      super.error,
      required this.checkedInattendee,
      required this.day,
      required this.gender,
      required this.userId});
  CheckInState.initial()
      : this(
          uiState: UiState.idle,
          error: const EmptyException(),
          checkedInattendee: CheckInUserResponseDto.empty(),
          userId: '',
          gender: '',
          day: 1,
        );

  CheckInState copyWith(
      {UiState? uiState,
      Devfest2024Exception? error,
      CheckInUserResponseDto? checkedInattendee,
      String? userId,
      int? day,
      String? gender}) {
    return CheckInState(
        userId: userId ?? this.userId,
        uiState: uiState ?? this.uiState,
        error: error ?? this.error,
        day: day ?? this.day,
        gender: gender ?? this.gender,
        checkedInattendee: checkedInattendee ?? this.checkedInattendee);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [userId, uiState, error, day, checkedInattendee, gender];
}

final class UserSearchState extends Devfest2024UiState {
  final String userId;
  final num day;
  final List<AttendeeResult> attendees;
  final List<AttendeeResult> fetchedAttendees;
  final AttendeeResult selectedAttendee;
  const UserSearchState(
      {super.uiState,
      super.error,
      required this.userId,
      required this.day,
      required this.selectedAttendee,
      required this.fetchedAttendees,
      required this.attendees});
  UserSearchState.initial()
      : this(
          uiState: UiState.idle,
          error: const EmptyException(),
          attendees: [],
          fetchedAttendees: [],
          selectedAttendee: AttendeeResult.empty(),
          userId: '',
          day: 1,
        );

  UserSearchState copyWith(
      {UiState? uiState,
      Devfest2024Exception? error,
      List<AttendeeResult>? attendees,
      List<AttendeeResult>? fetchedAttendees,
      String? userId,
      num? day,
      AttendeeResult? selectedAttendee}) {
    return UserSearchState(
        userId: userId ?? this.userId,
        uiState: uiState ?? this.uiState,
        error: error ?? this.error,
        day: day ?? this.day,
        selectedAttendee: selectedAttendee ?? this.selectedAttendee,
        attendees: attendees ?? this.attendees,
        fetchedAttendees: fetchedAttendees ?? this.fetchedAttendees);
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [userId, uiState, error, day, attendees, fetchedAttendees];
}
