import 'package:cave/cave.dart';

base class Devfest2024Exception implements Exception {
  const Devfest2024Exception();

  factory Devfest2024Exception.fromErrorResponse(Response error) {
    try {
      final json = error.data as Map<String, dynamic>;

      if (error.statusCode == 401) {
        return UnauthorizedUserException.fromJson(json);
      }

      return ClientException.fromJson(json);
    } catch (_) {
      return const GroundException('An error occurred...');
    }
  }
}
