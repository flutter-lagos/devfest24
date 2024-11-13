import 'package:cave/cave.dart';
import 'package:flutter/foundation.dart';

class ConferenceNetworkClient {
  const ConferenceNetworkClient();

  Dio get _instance {
    final dioInstance = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 40),
        receiveTimeout: const Duration(minutes: 2),
      ),
    );
    dioInstance.interceptors.addAll(
      [
        const AuthorizedClientInterceptor(ConferenceAppStorageService.instance),
        if (kDebugMode)
          LogInterceptor(
            responseBody: true,
            error: true,
            request: true,
            requestBody: true,
            requestHeader: true,
            responseHeader: true,
          ),
      ],
    );
    fixBadCertificate(dio: dioInstance);
    return dioInstance;
  }

  Future<Either<Devfest2024Exception, Response>> call({
    required String path,
    required RequestMethod method,
    dynamic body = const {},
    Map<String, dynamic> queryParams = const {},
    Options? options,
    CancelToken? cancelToken,
    Duration? cacheDuration,
    bool forceRefresh = false,
  }) async {
    return await _instance.call(
      path: path,
      method: method,
      body: body,
      queryParams: queryParams,
      options: options,
      cancelToken: cancelToken,
      cacheDuration: cacheDuration,
      forceRefresh: forceRefresh,
    );
  }
}

enum RequestMethod { get, post, put, patch, delete }

extension CallX on Dio {
  Future<Either<Devfest2024Exception, Response>> call({
    required String path,
    required RequestMethod method,
    dynamic body = const {},
    Map<String, dynamic> queryParams = const {},
    Options? options,
    CancelToken? cancelToken,
    Duration? cacheDuration,
    bool forceRefresh = false,
  }) async {
    try {
      interceptors.add(
        CacheClientInterceptor(
          CacheManager.instance,
          cacheDuration: cacheDuration,
          forceRefresh: forceRefresh,
        ),
      );

      final response = await switch (method) {
        RequestMethod.get => get(
            path,
            queryParameters: queryParams,
            options: options,
            cancelToken: cancelToken,
          ),
        RequestMethod.post => post(
            path,
            data: body,
            queryParameters: queryParams,
            options: options,
            cancelToken: cancelToken,
          ),
        RequestMethod.put => put(
            path,
            queryParameters: queryParams,
            data: body,
            options: options,
            cancelToken: cancelToken,
          ),
        RequestMethod.patch => patch(
            path,
            queryParameters: queryParams,
            data: body,
            options: options,
            cancelToken: cancelToken,
          ),
        RequestMethod.delete => delete(
            path,
            queryParameters: queryParams,
            data: body,
            options: options,
            cancelToken: cancelToken,
          ),
      };

      return Right(response);
    } on DioException catch (exception) {
      switch (exception.type) {
        case DioExceptionType.badResponse:
          final error =
              Devfest2024Exception.fromErrorResponse(exception.response!);

          return Left(error);
        case DioExceptionType.connectionError:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return const Left(
            ClientException(
                detail:
                    'Error establishing connection to the server. Please try again'),
          );
        case _:
          return Left(ClientException(
              detail: exception.message ?? 'An error occurred'));
      }
    } on Exception catch (e) {
      return Left(GroundException(e.toString()));
    }
  }
}
