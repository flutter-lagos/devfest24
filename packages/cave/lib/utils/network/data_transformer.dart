import 'package:cave/cave.dart';
import 'package:flutter/foundation.dart';

typedef Devfest2024ExceptionOr<T> = Either<Devfest2024Exception, T>;
typedef FutureDevfest2024ExceptionOr<T> = Future<Devfest2024ExceptionOr<T>>;

FutureDevfest2024ExceptionOr<E> processData<E>(
  E Function(dynamic json) transformer,
  Devfest2024ExceptionOr<Response> response,
) async {
  if (response.isLeft) return Left(response.left);

  return await compute(
    (message) => _transformResponse(message, (p0) => transformer(p0)),
    response.right.data,
  );
}

Devfest2024ExceptionOr<E> _transformResponse<E>(
    dynamic data, E Function(dynamic) transform) {
  try {
    if (data is Map<String, dynamic> && data.containsKey('errorObject')) {
      return Left(
        WithCachedDataException.fromJson(data, transform),
      );
    }

    return Right(transform(data));
  } on TypeError catch (e) {
    return Left(GroundException(e.toString(), stackTrace: e.stackTrace));
  } on Exception catch (e) {
    return Left(GroundException(e.toString()));
  }
}
