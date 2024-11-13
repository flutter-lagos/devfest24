import 'dart:convert';
import 'package:cave/cave.dart';
import 'package:volunteerapp/src/features/onboarding/model/model.dart';

final class VolunteerOnboardingApiService {
  final ConferenceNetworkClient _networkClient;

  const VolunteerOnboardingApiService(this._networkClient);

  Future<Either<Devfest2024Exception, SignInResponseDto>> signIn(
      SignInRequestDto dto) async {
    final response = await _networkClient.call(
      path: ConferenceApis.instance.postSignin,
      method: RequestMethod.post,
      body: dto.toJson(),
    );

    return await processData(
      (p0) {    
          //final result = jsonDecode(p0);
          return SignInResponseDto.fromJson(p0); 
      },
      response,
    );
  }
}
