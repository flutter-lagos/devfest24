import 'dart:developer';
import 'dart:io';

import 'package:cave/cave.dart';
import 'package:flutter/foundation.dart';

const errorWithCacheDataStatusCode = 282;

class AuthorizedClientInterceptor extends Interceptor {
  final ConferenceAppStorageService storage;

  const AuthorizedClientInterceptor(this.storage);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final idToken = await storage.userToken;
    if (idToken.isNotEmpty) {
      options.headers.addAll({'Authorization': 'Bearer $idToken'});
    }
    if (options.uri.toString().toLowerCase().contains('github')) {
      options.headers.remove('Authorization');
    }
    super.onRequest(options, handler);
  }
}

class CacheClientInterceptor extends Interceptor {
  final CacheManager cacheManager;

  const CacheClientInterceptor(
    this.cacheManager, {
    this.cacheDuration,
    required this.forceRefresh,
  });

  static const _cacheSuccessStatusCode = 220;
  final Duration? cacheDuration;
  final bool forceRefresh;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.method == 'GET') {
      final storeKey = CacheManagerUtils.composeKeyFromUrl(
        options.path,
        requestMethod: RequestMethod.get.name,
        queryParams: options.queryParameters,
      );

      if (forceRefresh) {
        await cacheManager.invalidateCacheItem(storeKey);
      }

      if (!(cacheManager.cacheItemExpired(storeKey))) {
        final cacheData = cacheManager.getSync(storeKey)!.data;
        return handler.resolve(
          Response(
            requestOptions: options,
            data: cacheData,
            statusCode: _cacheSuccessStatusCode,
          ),
        );
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == _cacheSuccessStatusCode) {
      super.onResponse(response.copyWith(statusCode: 200), handler);
    }

    final getRequest = response.requestOptions.method == 'GET';

    if (getRequest) {
      final isSuccessfulResponse =
          (response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300;
      final storeKey = CacheManagerUtils.composeKeyFromUrl(
        response.requestOptions.path,
        requestMethod: RequestMethod.get.name,
        queryParams: response.requestOptions.queryParameters,
      );
      if (isSuccessfulResponse &&
          response.statusCode != errorWithCacheDataStatusCode) {
        final item = CacheItem.persistentStore(
          key: storeKey,
          data: response.data,
          duration: cacheDuration ?? const Duration(hours: 1),
        );
        await cacheManager.set(item);
        return super.onResponse(response, handler);
      }
    }

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final getRequest = err.requestOptions.method == 'GET';
    if (getRequest && err.response?.statusCode != 401) {
      final storeKey = CacheManagerUtils.composeKeyFromUrl(
        err.requestOptions.path,
        requestMethod: RequestMethod.get.name,
        queryParams: err.requestOptions.queryParameters,
      );
      if (cacheManager.getSync(storeKey) case final item?) {
        log('returning cache data with error for $storeKey');
        return handler.resolve(err.response!.copyWith(
          statusCode: errorWithCacheDataStatusCode,
          data: {'errorObject': err.response?.data, 'cachedObject': item.data},
        ));
      }
    }

    super.onError(err, handler);
  }
}

///This function used for those devices which doesnot support
/// newer ssl certificate and disabled in web
void fixBadCertificate({required Dio dio}) {
  if (!kIsWeb) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        // Don't trust any certificate just because their root cert is trusted.
        final HttpClient client =
            HttpClient(context: SecurityContext(withTrustedRoots: false));
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
      validateCertificate: (cert, host, port) => true,
    );
  }
}

extension on Response {
  Response copyWith({
    int? statusCode,
    RequestOptions? requestOptions,
    dynamic data,
    Headers? headers,
    String? statusMessage = 'nil',
    bool? isRedirect,
    List<RedirectRecord>? redirects,
    Map<String, dynamic>? extra,
  }) =>
      Response(
        data: data ?? this.data,
        requestOptions: requestOptions ?? this.requestOptions,
        statusCode: statusCode ?? this.statusCode,
        statusMessage:
            statusMessage == 'nil' ? this.statusMessage : statusMessage,
        isRedirect: isRedirect ?? this.isRedirect,
        redirects: redirects ?? this.redirects,
        headers: headers ?? this.headers,
        extra: extra ?? this.extra,
      );
}
