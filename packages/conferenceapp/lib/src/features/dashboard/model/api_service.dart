import 'dart:convert';

import 'package:cave/cave.dart';
import 'schedule_dto.dart';
import 'sponsors_dto.dart';
import 'speakers_dto.dart';
import 'profile_dto.dart';

final class DashboardApiService {
  const DashboardApiService(this._networkClient);

  final ConferenceNetworkClient _networkClient;

  FutureDevfest2024ExceptionOr<ProfileResponseDto> fetchUserProfile(
      {bool refresh = false}) async {
    final response = await _networkClient.call(
      path: ConferenceApis.instance.getUserProfile,
      method: RequestMethod.get,
      forceRefresh: refresh,
    );

    return await processData((p0) => ProfileResponseDto.fromJson(p0), response);
  }

  FutureDevfest2024ExceptionOr<SponsorsDto> getSponsors(
      {bool refresh = false}) async {
    final response = await _networkClient.call(
      path: ConferenceApis.instance.getEventSponsors,
      method: RequestMethod.get,
      forceRefresh: refresh,
    );

    return await processData((p0) {
      final result = p0 is String ? jsonDecode(p0) : p0;
      return SponsorsDto.fromJson(result);
    }, response);
  }

  FutureDevfest2024ExceptionOr<SpeakersDto> getSpeakers(
      {bool refresh = false}) async {
    final response = await _networkClient.call(
      path: ConferenceApis.instance.getSpeakers,
      method: RequestMethod.get,
      forceRefresh: refresh,
    );

    return await processData((p0) {
      final result = p0 is String ? jsonDecode(p0) : p0;
      return SpeakersDto.fromJson(result);
    }, response);
  }

  FutureDevfest2024ExceptionOr<ScheduleDto> getSchedule(
      {bool refresh = false}) async {
    final response = await _networkClient.call(
      path: ConferenceApis.instance.getSchedule,
      method: RequestMethod.get,
      forceRefresh: refresh,
    );

    return await processData((p0) {
      final result = p0 is String ? jsonDecode(p0) : p0;
      return ScheduleDto.fromJson(result);
    }, response);
  }
}
