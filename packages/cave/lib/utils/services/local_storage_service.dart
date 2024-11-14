import 'package:cave/cave.dart';

final class ConferenceAppStorageService {
  const ConferenceAppStorageService._();

  static const instance = ConferenceAppStorageService._();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  IOSOptions _getIosOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  FlutterSecureStorage get _securedStorageInstance => FlutterSecureStorage(
        aOptions: _getAndroidOptions(),
        iOptions: _getIosOptions(),
      );

  SharedPreferencesAsync get _sharedPreferencesInstance =>
      SharedPreferencesAsync();

  Future<void> setUserToken(String token) async {
    return await _securedStorageInstance.write(key: 'user-token', value: token);
  }

  Future<String> get userToken async {
    return await _securedStorageInstance.read(key: 'user-token') ?? '';
  }

  Future<void> setIsFirstLaunch(bool isFirstLaunch) async {
    return await _sharedPreferencesInstance.setBool(
        'is-first-launch', isFirstLaunch);
  }

  Future<bool> get isFirstLaunch async {
    return await _sharedPreferencesInstance.getBool('is-first-launch') ?? true;
  }
}
