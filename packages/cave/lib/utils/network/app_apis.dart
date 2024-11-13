final class ConferenceApis {
  final String baseUrl;

  const ConferenceApis._(this.baseUrl);

  static const ConferenceApis instance =
      ConferenceApis._(String.fromEnvironment('BASE_URL'));

  String get postInitiateUserSession => '$baseUrl/users/sessions';

  String get getUserProfile => '$baseUrl/users/profile';

  String get getEventSessions => '$baseUrl/events/sessions';

  String get getEventSponsors =>
      'https://gist.githubusercontent.com/Mastersam07/8a29cbf07339cf222d24c9f57d4af33e/raw/6901c7612048f5b9471f719d99391303fd63447c/sponsors.json';

  String get postReserveSession => '$baseUrl/events/reservations';

  String deleteSession(String id) => '$baseUrl/events/reservations/$id';

  String get getSpeakers =>
      'https://raw.githubusercontent.com/GDG-W/Gotham/refs/heads/v2/src/app/speakers/data/speakers.json';

  String get getSchedule =>
      'https://raw.githubusercontent.com/GDG-W/Gotham/a40964c56dadc6b8b7b1399143ae31af4138b895/src/app/schedule/data/schedule.json';

  String getSingleSession(String id) => '$baseUrl/events/sessions/$id';

  //Volunteer endpoints

  String get postSignin => '$baseUrl/volunteers/sessions';
  String get getAttendees => '$baseUrl/users/';
  String get postCheckUserIn => '$baseUrl/volunteers/checkins';
  String get volunteerLogout => '$baseUrl/volunteers/sessions';
  String get getHealthChecker => baseUrl;
}
