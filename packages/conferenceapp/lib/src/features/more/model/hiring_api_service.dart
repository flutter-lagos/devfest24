import 'package:cave/cave.dart';

final class HiringApiService {
  final ConferenceNetworkClient _networkClient;

  const HiringApiService(this._networkClient);

  Future<Either<Devfest2024Exception, String>> uploadUserResume(
      String resumeUrl, String userId) async {
    final response = await _networkClient.call(
      path: ConferenceApis.instance.updateUserProfile(userId),
      method: RequestMethod.patch,
      body: {'resume_url': resumeUrl},
    );

    return await processData(
      (p0) => switch (p0) {
        Map data => (data as Map<String, dynamic>)['resume_url'],
        _ => ''
      },
      response,
    );
  }
}
