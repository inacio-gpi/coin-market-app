import 'package:coin_market_app/core/api/http_client_adapter.dart';
import 'package:coin_market_app/core/api/http_config_wrapper.dart';
import 'package:coin_market_app/core/api/http_interceptor.dart';
import 'package:coin_market_app/core/config/env_config.dart';

class CustomHttpClient {
  final HttpClientAdapter _adapter;
  final HttpConfig _config;
  final InterceptorManager? _interceptorManager;

  const CustomHttpClient({
    required HttpClientAdapter adapter,
    required HttpConfig config,
    InterceptorManager? interceptorManager,
  }) : _adapter = adapter,
       _config = config,
       _interceptorManager = interceptorManager;

  factory CustomHttpClient.withDefaultConfig({
    List<HttpInterceptor>? interceptors,
  }) {
    final config = HttpConfigFactory.createFromEnvironment();
    final adapter = HttpClientFactory.createDefault(
      defaultTimeout: config.timeout,
    );

    final interceptorManager = interceptors != null
        ? InterceptorManager(interceptors)
        : null;

    return CustomHttpClient(
      adapter: adapter,
      config: config,
      interceptorManager: interceptorManager,
    );
  }

  factory CustomHttpClient.coinMarketCap({
    List<HttpInterceptor>? additionalInterceptors,
  }) {
    final config = HttpConfigFactory.createFromEnvironment();

    final List<HttpInterceptor> interceptors = [
      LoggingInterceptor(
        logRequest: EnvConfig.enableLogging,
        logResponse: EnvConfig.enableLogging,
        logErrors: true,
      ),
    ];

    if (EnvConfig.coinMarketCapApiKey != null) {
      interceptors.add(
        ApiKeyInterceptor(apiKey: EnvConfig.coinMarketCapApiKey!),
      );
    }

    if (additionalInterceptors != null) {
      interceptors.addAll(additionalInterceptors);
    }

    final adapter = HttpClientFactory.createDefault(
      defaultTimeout: config.timeout,
    );
    final interceptorManager = InterceptorManager(interceptors);

    return CustomHttpClient(
      adapter: adapter,
      config: config,
      interceptorManager: interceptorManager,
    );
  }

  Future<HttpResponse> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    final url = '${_config.baseUrl}$endpoint';
    final request = HttpRequest.get(
      url,
      headers: {...?_config.headers, ...?headers},
      queryParameters: queryParameters,
      timeout: timeout,
    );

    return await _executeRequest(request);
  }

  Future<HttpResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    final url = '${_config.baseUrl}$endpoint';
    final request = HttpRequest.post(
      url,
      body: body,
      headers: {...?_config.headers, ...?headers},
      queryParameters: queryParameters,
      timeout: timeout,
    );

    return await _executeRequest(request);
  }

  Future<HttpResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    final url = '${_config.baseUrl}$endpoint';
    final request = HttpRequest.put(
      url,
      body: body,
      headers: {...?_config.headers, ...?headers},
      queryParameters: queryParameters,
      timeout: timeout,
    );

    return await _executeRequest(request);
  }

  Future<HttpResponse> delete(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    final url = '${_config.baseUrl}$endpoint';
    final request = HttpRequest.delete(
      url,
      headers: {...?_config.headers, ...?headers},
      queryParameters: queryParameters,
      timeout: timeout,
    );

    return await _executeRequest(request);
  }

  Future<HttpResponse> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    final url = '${_config.baseUrl}$endpoint';
    final request = HttpRequest(
      url: url,
      method: HttpMethod.patch,
      body: body,
      headers: {...?_config.headers, ...?headers},
      queryParameters: queryParameters,
      timeout: timeout,
    );

    return await _executeRequest(request);
  }

  Future<HttpResponse> _executeRequest(HttpRequest request) async {
    try {
      HttpRequest modifiedRequest = request;
      if (_interceptorManager != null) {
        modifiedRequest = await _interceptorManager.applyRequestInterceptors(
          request,
        );
      }

      HttpResponse response = await _adapter.request(modifiedRequest);

      if (_interceptorManager != null) {
        response = await _interceptorManager.applyResponseInterceptors(
          modifiedRequest,
          response,
        );
      }

      return response;
    } catch (error) {
      if (_interceptorManager != null) {
        return await _interceptorManager.applyErrorInterceptors(request, error);
      }

      return HttpResponse(statusCode: 500, body: 'Request failed: $error');
    }
  }

  String get baseUrl => _config.baseUrl;

  Map<String, dynamic>? get defaultHeaders => _config.headers;

  Duration get timeout => _config.timeout;
}
