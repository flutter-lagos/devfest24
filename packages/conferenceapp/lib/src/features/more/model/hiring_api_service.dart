import 'package:cave/cave.dart';

final class HiringApiService {
  final ConferenceNetworkClient _networkClient;

  const HiringApiService(this._networkClient);

  Future<Either<Devfest2024Exception, String>> uploadUserResume(
      String resumeUrl) async {
    final response = await _networkClient.call(
      path: ConferenceApis.instance.postInitiateUserSession,
      method: RequestMethod.post,
      // TODO: Use actual body
      body: {'resume': resumeUrl},
    );

    return await processData(
      (p0) => switch (p0) {
        Map data => (data as Map<String, dynamic>)['token'],
        _ => ''
      },
      response,
    );
  }
}
