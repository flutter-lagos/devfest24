final class ConferenceApis {
  final String baseUrl;

  const ConferenceApis._(this.baseUrl);

  static const ConferenceApis instance =
      ConferenceApis._("https://asgard.devfestlagos.com");

  String get postInitiateUserSession => '$baseUrl/users/sessions';

  String get getUserProfile => '$baseUrl/users/profile';

  String updateUserProfile(String userId) => '$baseUrl/users/$userId';

  String get getEventSponsors =>
      'https://devfestlagos.com/app-assets/sponsors.json';

  String get getSpeakers => 'https://devfestlagos.com/app-assets/speakers.json';

  String get getSchedule => 'https://devfestlagos.com/app-assets/schedule.json';
}
