final class ConferenceApis {
  final String baseUrl;

  const ConferenceApis._(this.baseUrl);

  static const ConferenceApis instance =
      ConferenceApis._(String.fromEnvironment('BASE_URL'));

  String get postInitiateUserSession => '$baseUrl/users/sessions';

  String get getUserProfile => '$baseUrl/users/profile';

  String get getEventSessions => '$baseUrl/events/sessions';

  String get getEventSponsors =>
      'https://raw.githubusercontent.com/GDG-W/cave/refs/heads/dev/packages/sponsors.json';

  String get postReserveSession => '$baseUrl/events/reservations';

  String deleteSession(String id) => '$baseUrl/events/reservations/$id';

  String get getSpeakers =>
      'https://raw.githubusercontent.com/GDG-W/Gotham/refs/heads/v2/src/app/speakers/data/speakers.json';

  String get getSchedule =>
      'https://raw.githubusercontent.com/GDG-W/Gotham/refs/heads/v2/src/app/schedule/data/schedule.json';

  String getSingleSession(String id) => '$baseUrl/events/sessions/$id';
}
