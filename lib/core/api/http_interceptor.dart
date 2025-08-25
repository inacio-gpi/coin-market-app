import 'package:coin_market_app/core/api/http_client_adapter.dart';
import 'package:coin_market_app/core/utils/logger.dart';

abstract class HttpInterceptor {
  Future<HttpRequest> onRequest(HttpRequest request);
  Future<HttpResponse> onResponse(HttpRequest request, HttpResponse response);
  Future<HttpResponse> onError(HttpRequest request, Object error);
}

class LoggingInterceptor implements HttpInterceptor {
  final bool logRequest;
  final bool logResponse;
  final bool logErrors;

  const LoggingInterceptor({
    this.logRequest = true,
    this.logResponse = true,
    this.logErrors = true,
  });

  @override
  Future<HttpRequest> onRequest(HttpRequest request) async {
    if (logRequest) {
      AppLogger.info(
        'HTTP Request: ${request.method.name.toUpperCase()} ${request.fullUrl}',
        tag: 'HTTP',
      );

      if (request.headers != null && request.headers!.isNotEmpty) {
        AppLogger.debug('Headers: ${request.headers}', tag: 'HTTP');
      }

      if (request.body != null) {
        AppLogger.debug('Body: ${request.body}', tag: 'HTTP');
      }
    }

    return request;
  }

  @override
  Future<HttpResponse> onResponse(
    HttpRequest request,
    HttpResponse response,
  ) async {
    if (logResponse) {
      AppLogger.info(
        'HTTP Response: ${response.statusCode} for ${request.method.name.toUpperCase()} ${request.fullUrl}',
        tag: 'HTTP',
      );

      if (response.body != null && response.body!.isNotEmpty) {
        AppLogger.debug('Response Body: ${response.body}', tag: 'HTTP');
      }
    }

    return response;
  }

  @override
  Future<HttpResponse> onError(HttpRequest request, Object error) async {
    if (logErrors) {
      AppLogger.error(
        'HTTP Error for ${request.method.name.toUpperCase()} ${request.fullUrl}: $error',
        tag: 'HTTP',
      );
    }

    return HttpResponse(statusCode: 500, body: 'Request failed: $error');
  }
}

class ApiKeyInterceptor implements HttpInterceptor {
  final String apiKey;
  final String headerName;

  const ApiKeyInterceptor({
    required this.apiKey,
    this.headerName = 'X-CMC_PRO_API_KEY',
  });

  @override
  Future<HttpRequest> onRequest(HttpRequest request) async {
    final headers = Map<String, String>.from(request.headers ?? {});
    headers[headerName] = apiKey;

    return HttpRequest(
      url: request.url,
      method: request.method,
      headers: headers,
      body: request.body,
      queryParameters: request.queryParameters,
      timeout: request.timeout,
    );
  }

  @override
  Future<HttpResponse> onResponse(
    HttpRequest request,
    HttpResponse response,
  ) async {
    return response;
  }

  @override
  Future<HttpResponse> onError(HttpRequest request, Object error) async {
    return HttpResponse(statusCode: 500, body: 'Request failed: $error');
  }
}

class InterceptorManager {
  final List<HttpInterceptor> interceptors;

  const InterceptorManager(this.interceptors);

  Future<HttpRequest> applyRequestInterceptors(HttpRequest request) async {
    HttpRequest currentRequest = request;

    for (final interceptor in interceptors) {
      currentRequest = await interceptor.onRequest(currentRequest);
    }

    return currentRequest;
  }

  Future<HttpResponse> applyResponseInterceptors(
    HttpRequest request,
    HttpResponse response,
  ) async {
    HttpResponse currentResponse = response;

    for (final interceptor in interceptors) {
      currentResponse = await interceptor.onResponse(request, currentResponse);
    }

    return currentResponse;
  }

  Future<HttpResponse> applyErrorInterceptors(
    HttpRequest request,
    Object error,
  ) async {
    HttpResponse errorResponse = HttpResponse(
      statusCode: 500,
      body: 'Request failed: $error',
    );

    for (final interceptor in interceptors) {
      errorResponse = await interceptor.onError(request, error);
    }

    return errorResponse;
  }
}
