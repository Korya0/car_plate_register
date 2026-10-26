# Network & REST API Architecture

Use this reference when the project connects to a remote REST API backend via Dio and Retrofit.

---

## 1. Constants & Fake API Switch

### `lib/core/network/api_constants.dart`
```dart
abstract final class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com/api/v1',
  );

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
```

### `lib/core/config/app_config.dart` (Mock vs Real API Switch)
```dart
abstract final class AppConfig {
  /// true  → Features register their in-memory Fake sources (backend in development).
  /// false → Features register their real Retrofit sources.
  /// Toggle without code changes: flutter run --dart-define=USE_FAKE_API=false
  static const bool useFakeApi = bool.fromEnvironment('USE_FAKE_API', defaultValue: false);
}
```

---

## 2. Dio Factory & Interceptors (`DioFactory`)

### `lib/core/network/dio_factory.dart`
```dart
import 'package:dio/dio.dart';
import 'package:{{APP_PACKAGE}}/core/network/api_constants.dart';
import 'package:{{APP_PACKAGE}}/core/utils/app_logger.dart';

abstract final class DioFactory {
  static Dio create({
    required AppLogger logger,
    Future<String?> Function()? readToken,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (readToken != null) {
      dio.interceptors.add(_AuthInterceptor(readToken));
    }

    dio.interceptors.add(_LoggingInterceptor(logger));
    return dio;
  }
}

class _AuthInterceptor extends Interceptor {
  const _AuthInterceptor(this._readToken);
  final Future<String?> Function() _readToken;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class _LoggingInterceptor extends Interceptor {
  const _LoggingInterceptor(this._logger);
  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.debug('--> ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.debug('<-- ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.error('API Error: ${err.message}', error: err, stackTrace: err.stackTrace);
    handler.next(err);
  }
}
```

---

## 3. Safe API Calls (`safeApiCall`)

Centralized helper mapping Dio exceptions to sealed `Failure` objects within the `Result<T>` pattern:

```dart
Future<Result<T>> safeApiCall<T>(Future<T> Function() call) async {
  try {
    final response = await call();
    return Result.success(response);
  } on DioException catch (e) {
    return Result.failure(
      switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.connectionError =>
          const NetworkFailure(message: 'No internet connection'),
        _ => UnknownFailure(message: e.response?.data?['message']?.toString() ?? 'An unexpected error occurred'),
      },
    );
  } catch (e, st) {
    return Result.failure(UnknownFailure(message: 'An unexpected error occurred'));
  }
}
```
