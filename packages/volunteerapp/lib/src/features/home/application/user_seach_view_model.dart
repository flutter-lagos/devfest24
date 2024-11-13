import 'package:cave/cave.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteerapp/src/features/home/application/ui_state.dart';
import 'package:volunteerapp/src/features/home/model/user_search_dto.dart';
import 'package:volunteerapp/src/features/home/model/volunteer_home_api_service.dart';
import 'package:volunteerapp/src/shared/shared.dart';

final usersearchVM =
    AutoDisposeNotifierProvider<UserSeachViewModel, UserSearchState>(
        () => UserSeachViewModel());

final class UserSeachViewModel extends AutoDisposeNotifier<UserSearchState> {
  late VolunteerHomeApiService _apiService;

  @override
  UserSearchState build() {
    _apiService = const VolunteerHomeApiService(ConferenceNetworkClient());
    return UserSearchState.initial();
  }

  AttendeeResult getSearchedAttendeeById(
    String id,
  ) {
    final result = state.attendees.firstWhere(
      (e) => e.id == id,
      orElse: () {
        // Handle the case where the attendee is not found
        throw StateError('Attendee with id $id not found');
      },
    );
    return result;
  }

  AttendeeResult getAttendeeById(
    String id,
  ) {
    final result = state.fetchedAttendees.firstWhere(
      (e) => e.id == id,
      orElse: () {
        // Handle the case where the attendee is not found
        throw StateError('Attendee with id $id not found');
      },
    );
    return result;
  }

  void onCheckboxClicked(
    bool isClicked,
    String id,
  ) {
    //get the bool and index
    AttendeeResult updatedResult;
    final attendee = getSearchedAttendeeById(id);
    state = state.copyWith(selectedAttendee: attendee);
  }

  void onHomePageCheckboxClicked(
    bool isClicked,
    String id,
  ) {
    //get the bool and index
    AttendeeResult updatedResult;
    final attendee = getAttendeeById(id);
    state = state.copyWith(selectedAttendee: attendee);
  }

  void clearSearchList() {
    state = state.copyWith(attendees: []);
    print('emptied ${state.attendees.toString()}');
  }

  Future<void> searchAttendee(String searchString) async {
    await launch(state.ref, (model) async {
      state = model.emit(state.copyWith(uiState: UiState.loading));

      final result = await _apiService.searchAttendees(searchString);

      state = model.emit(result
          .fold((left) => state.copyWith(uiState: UiState.error, error: left),
              (right) {
        print(right.toString());
        return state.copyWith(
            uiState: UiState.success, attendees: right.attendeeList);
      }));
    });
  }

  Future<void> getAttendees() async {
    await launch(state.ref, (model) async {
      state = model.emit(state.copyWith(uiState: UiState.loading));

      final result = await _apiService.getAttendees();

      state = model.emit(result
          .fold((left) => state.copyWith(uiState: UiState.error, error: left),
              (right) {
        print(right.toString());
        return state.copyWith(
            uiState: UiState.success, fetchedAttendees: right.attendees);
      }));
    });
  }
}
