import 'dart:convert';

import 'package:cave/cave.dart';
import 'package:volunteerapp/src/features/home/model/model.dart';

final class VolunteerHomeApiService {
  final ConferenceNetworkClient _networkClient;

  const VolunteerHomeApiService(this._networkClient);

  Future<Either<Devfest2024Exception, AttendeeSearchResponseDto>>
      searchAttendees(String search) async {
    final response = await _networkClient.call(
        path: ConferenceApis.instance.getAttendees,
        method: RequestMethod.get,
        queryParams: {'q': search});

    return await processData(
      (p0) {
        // final result = jsonDecode(p0['items']);
        return AttendeeSearchResponseDto.fromJson(p0['items']);
      },
      response,
    );
  }

  Future<Either<Devfest2024Exception, AttendeesResponseDto>>
      getAttendees() async {
    final response = await _networkClient.call(
      path: ConferenceApis.instance.getAttendees,
      method: RequestMethod.get,
    );

    return await processData(
      (p0) {
        // final result = jsonDecode(p0['items']);
        return AttendeesResponseDto.fromJson(p0['items']);
      },
      response,
    );
  }

  Future<Either<Devfest2024Exception, CheckInUserResponseDto>> checkInUser(
      CheckUserInRequestDto dto) async {
    final response = await _networkClient.call(
        path: ConferenceApis.instance.postCheckUserIn,
        method: RequestMethod.post,
        body: dto.toJson());

    return await processData(
      (p0) {
        final result = jsonDecode(p0);
        return CheckInUserResponseDto.fromJson(result);
      },
      response,
    );
  }

  Future<Either<Devfest2024Exception, String>> logout() async {
    final response = await _networkClient.call(
      path: ConferenceApis.instance.volunteerLogout,
      method: RequestMethod.delete,
    );

    return await processData(
      (p0) => 'Logged out',
      response,
    );
  }
}
