import 'dart:convert';

import 'package:http/http.dart' as http;

enum HttpMethod { get, post, put, delete, patch }

class HttpResponse {
  final int statusCode;
  final String? body;
  final Map<String, String> headers;

  const HttpResponse({
    required this.statusCode,
    this.body,
    this.headers = const {},
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  Map<String, dynamic>? get jsonBody {
    if (body == null) return null;
    try {
      return json.decode(body!) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  List<dynamic>? get jsonListBody {
    if (body == null) return null;
    try {
      return json.decode(body!) as List<dynamic>;
    } catch (e) {
      return null;
    }
  }
}

class HttpRequest {
  final String url;
  final HttpMethod method;
  final Map<String, dynamic>? body;
  final Map<String, String>? headers;
  final Map<String, dynamic>? queryParameters;
  final Duration? timeout;

  const HttpRequest({
    required this.url,
    this.method = HttpMethod.get,
    this.body,
    this.headers,
    this.queryParameters,
    this.timeout,
  });

  factory HttpRequest.get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return HttpRequest(
      url: url,
      method: HttpMethod.get,
      headers: headers,
      queryParameters: queryParameters,
      timeout: timeout,
    );
  }

  factory HttpRequest.post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return HttpRequest(
      url: url,
      method: HttpMethod.post,
      body: body,
      headers: headers,
      queryParameters: queryParameters,
      timeout: timeout,
    );
  }

  factory HttpRequest.put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return HttpRequest(
      url: url,
      method: HttpMethod.put,
      body: body,
      headers: headers,
      queryParameters: queryParameters,
      timeout: timeout,
    );
  }

  factory HttpRequest.delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return HttpRequest(
      url: url,
      method: HttpMethod.delete,
      headers: headers,
      queryParameters: queryParameters,
      timeout: timeout,
    );
  }
  String get fullUrl {
    if (queryParameters == null || queryParameters!.isEmpty) {
      return url;
    }

    final uri = Uri.parse(url);
    final queryParams = Map<String, String>.from(
      queryParameters!.map((key, value) => MapEntry(key, value.toString())),
    );
    final newUri = uri.replace(queryParameters: queryParams);
    return newUri.toString();
  }
}

abstract class HttpClientAdapter {
  Future<HttpResponse> request(HttpRequest request);

  Future<HttpResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return request(
      HttpRequest.get(
        url,
        headers: headers,
        queryParameters: queryParameters,
        timeout: timeout,
      ),
    );
  }

  Future<HttpResponse> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return request(
      HttpRequest.post(
        url,
        body: body,
        headers: headers,
        queryParameters: queryParameters,
        timeout: timeout,
      ),
    );
  }

  Future<HttpResponse> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return request(
      HttpRequest.put(
        url,
        body: body,
        headers: headers,
        queryParameters: queryParameters,
        timeout: timeout,
      ),
    );
  }

  Future<HttpResponse> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return request(
      HttpRequest.delete(
        url,
        headers: headers,
        queryParameters: queryParameters,
        timeout: timeout,
      ),
    );
  }

  Future<HttpResponse> patch(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return request(
      HttpRequest(
        url: url,
        method: HttpMethod.patch,
        body: body,
        headers: headers,
        queryParameters: queryParameters,
        timeout: timeout,
      ),
    );
  }
}

class HttpClientAdapterImpl implements HttpClientAdapter {
  final http.Client _client;
  final Duration _defaultTimeout;

  const HttpClientAdapterImpl({
    required http.Client client,
    Duration defaultTimeout = const Duration(seconds: 30),
  }) : _client = client,
       _defaultTimeout = defaultTimeout;

  @override
  Future<HttpResponse> request(HttpRequest request) async {
    try {
      final uri = Uri.parse(request.fullUrl);
      final timeout = request.timeout ?? _defaultTimeout;
      final headers = request.headers ?? {};

      late http.Response response;

      switch (request.method) {
        case HttpMethod.get:
          response = await _client.get(uri, headers: headers).timeout(timeout);
          break;
        case HttpMethod.post:
          response = await _client
              .post(
                uri,
                headers: headers,
                body: request.body != null ? json.encode(request.body) : null,
              )
              .timeout(timeout);
          break;
        case HttpMethod.put:
          response = await _client
              .put(
                uri,
                headers: headers,
                body: request.body != null ? json.encode(request.body) : null,
              )
              .timeout(timeout);
          break;
        case HttpMethod.delete:
          response = await _client
              .delete(uri, headers: headers)
              .timeout(timeout);
          break;
        case HttpMethod.patch:
          response = await _client
              .patch(
                uri,
                headers: headers,
                body: request.body != null ? json.encode(request.body) : null,
              )
              .timeout(timeout);
          break;
      }

      return HttpResponse(
        statusCode: response.statusCode,
        body: response.body,
        headers: response.headers,
      );
    } catch (e) {
      return const HttpResponse(statusCode: 500, body: 'Request failed');
    }
  }

  @override
  Future<HttpResponse> get(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return request(
      HttpRequest.get(
        url,
        headers: headers,
        queryParameters: queryParameters,
        timeout: timeout,
      ),
    );
  }

  @override
  Future<HttpResponse> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return request(
      HttpRequest.post(
        url,
        body: body,
        headers: headers,
        queryParameters: queryParameters,
        timeout: timeout,
      ),
    );
  }

  @override
  Future<HttpResponse> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return request(
      HttpRequest.put(
        url,
        body: body,
        headers: headers,
        queryParameters: queryParameters,
        timeout: timeout,
      ),
    );
  }

  @override
  Future<HttpResponse> delete(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return request(
      HttpRequest.delete(
        url,
        headers: headers,
        queryParameters: queryParameters,
        timeout: timeout,
      ),
    );
  }

  @override
  Future<HttpResponse> patch(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return request(
      HttpRequest(
        url: url,
        method: HttpMethod.patch,
        body: body,
        headers: headers,
        queryParameters: queryParameters,
        timeout: timeout,
      ),
    );
  }
}

class HttpClientFactory {
  static HttpClientAdapter createDefault({
    Duration defaultTimeout = const Duration(seconds: 30),
  }) {
    return HttpClientAdapterImpl(
      client: http.Client(),
      defaultTimeout: defaultTimeout,
    );
  }

  static HttpClientAdapter createWithClient(
    http.Client client, {
    Duration defaultTimeout = const Duration(seconds: 30),
  }) {
    return HttpClientAdapterImpl(
      client: client,
      defaultTimeout: defaultTimeout,
    );
  }
}
