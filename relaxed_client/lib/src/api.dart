import 'dart:convert';
import 'dart:io' show HttpHeaders;
import 'dart:typed_data';

import 'package:clinic_management/utils/connectivity.dart';
import 'package:fimber/fimber.dart';

import 'package:http/http.dart' as http;

enum ApiRequestType {
  get,
  post,
}

class ApiResult<T> {
  final T? data;
  final dynamic? error;
  final dynamic? stackTrace;

  const ApiResult({
    this.data,
    this.error,
    this.stackTrace,
  });

  void printError() {
    if (error == null) return;
    Fimber.e('${error?.message}', ex: error);
  }

  void printErrorWithStackTrace() {
    if (stackTrace == null) {
      printError();
      return;
    }
    Fimber.e(
      '',
      ex: error,
      stacktrace: stackTrace as StackTrace,
    );
  }

  bool get hasError => error != null;
  bool get hasNetworkError => error is ConnectionError;
  bool get hasData => data != null;
}

class ApiResponse extends ApiResult {
  const ApiResponse({
    dynamic? data,
    dynamic? error,
    dynamic? stackTrace,
  }) : super(
          data: data,
          error: error,
          stackTrace: stackTrace,
        );

  bool get isResponse => data is http.Response;
  bool get isStreamedResponse => data is http.StreamedResponse;
  bool get isString => data is String;
}

class ApiResultAsJSON<T> extends ApiResult<T> {
  final dynamic json;

  bool get hasJson => json != null;

  const ApiResultAsJSON._({
    this.json,
    T? data,
    dynamic? error,
    dynamic? stackTrace,
  }) : super(
          data: data,
          error: error,
          stackTrace: stackTrace,
        );
}

class ApiClient<T> {
  final http.Client _client;

  Map<String, String> get _header => {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json",
      };

  ApiClient([http.Client? client]) : _client = client ?? http.Client();

  /// Sends file via POST Multipart request.
  Future<ApiResponse> sendFile(
    Uri uri,
    int countryId,
    Uint8List bytes, {
    Duration? timelimit,
  }) async {
    final _name = '[/${uri.path}]';

    Fimber.i(
        '$_name Sending a file with http multipart post request\n\turl:$uri');

    final _request = http.MultipartRequest('POST', uri);

    final _multipartFile = http.MultipartFile.fromBytes(
      'POST',
      bytes,
      filename: 'file',
    );

    _request.files.add(_multipartFile);

    http.Response _response;

    try {
      Future<http.StreamedResponse> _streamedResponseFuture = _request.send();

      if (timelimit != null) {
        _streamedResponseFuture = _streamedResponseFuture.timeout(timelimit);
      }

      final _streamedResponse = await _streamedResponseFuture;

      try {
        Fimber.i('$_name Creating response from response stream.');
        Future<http.Response> _responseFuture =
            http.Response.fromStream(_streamedResponse);

        if (timelimit != null) {
          _responseFuture = _responseFuture.timeout(timelimit);
        }

        _response = await _responseFuture;
      } catch (e, s) {
        Fimber.e(
          "$_name File was sent but couldn't create a response.",
          ex: e,
          stacktrace: s,
        );

        final _result = ApiResponse(
          data: _streamedResponse,
          error: e,
          stackTrace: s,
        );

        return _result;
      }
    } catch (e, t) {
      Fimber.e("$_name File send request failed.", ex: e, stacktrace: t);

      return ApiResponse(
        error: e,
        stackTrace: t,
      );
    }

    if (_response.statusCode == 200) {
      final _responseBody = _response.body;
      if (_responseBody.isEmpty) {
        // ignore: prefer_const_declarations
        final _reason = 'Response returned empty body';
        Fimber.e('$_name $_reason');
        final _error = Exception(_reason);
        return ApiResponse(error: _error);
      }
      Fimber.i('$_name Request completed successfully');
      dynamic _responseJSON;

      try {
        _responseJSON = json.decode(_responseBody);
      } catch (e, t) {
        Fimber.e(
            'Error occurred when decoding response body to json. body was: $_responseBody',
            ex: e,
            stacktrace: t);
        return ApiResponse(data: _responseBody, error: e, stackTrace: t);
      }

      return ApiResponse(data: _responseJSON);
    }

    String _reason;

    _reason = 'Response returned status code: ${_response.statusCode}.';
    if (_response.reasonPhrase?.isNotEmpty ?? false) {
      _reason = '$_reason ${_response.reasonPhrase}';
    }

    Fimber.e('$_name $_reason');
    final _error = Exception(_reason);

    return ApiResponse(error: _error);
  }

  /// Use this when you only need parsed json as List or Map.
  Future<ApiResultAsJSON<T>> requestJSON(
    Uri uri, {
    Map<String, String> header = const {},
    Map<String, dynamic> body = const {},
    Map<String, dynamic> queryParameters = const {},
    ApiRequestType requestType = ApiRequestType.post,
    bool encodeBody = true,
    bool decodeResponse = true,
    bool jsonHeader = true,
    Duration? timeout,
  }) async {
    assert(uri.path.isNotEmpty, 'path ${uri.path} is empty');

    final bool _hasConnection = await ConnectionHelper.hasConnection;

    if (!_hasConnection) {
      final _error = ConnectionError();
      return ApiResultAsJSON<T>._(error: _error);
    }

    final _name = '[${uri.path}]';

    final Map<String, String> _header = {};

    if (jsonHeader) {
      _header.addAll(this._header);
    }

    _header.addAll(header);

    final _body = json.encode(body);

    Fimber.i(
        '$_name Making an http post request\n\turl:$uri\n\theader:$_header\n\tbody:$_body');

    final _httpClient = _client;

    http.Response? _response;

    try {
      Fimber.i('$_name Creating request..');

      ApiResultAsJSON<T>? _errorResult;

      Future<http.Response?>? _responseFutureTemp;

      switch (requestType) {
        case ApiRequestType.get:
          _responseFutureTemp = _httpClient.get(
            uri,
            headers: _header,
          );
          break;
        case ApiRequestType.post:
          _responseFutureTemp = _httpClient.post(
            uri,
            headers: _header,
            body: encodeBody ? _body : body,
          );
          break;
      }

      Future<http.Response?>? _responseFuture =
          _responseFutureTemp.catchError((e, s) {
        _errorResult = ApiResultAsJSON<T>._(error: e, stackTrace: s);
        return http.Response(
          '{"Message": "Something went wrong"}',
          200,
        );
      });

      if (timeout != null) {
        _responseFuture = _responseFuture.timeout(timeout);
      }

      _response = await _responseFuture;

      if (_errorResult != null) return _errorResult!;
    } catch (e, s) {
      Fimber.e('$_name Unexpected Error.', ex: e, stacktrace: s);
      return ApiResultAsJSON<T>._(error: e, stackTrace: s);
    }

    if (_response?.statusCode == 200) {
      final _responseBody = _response?.body;
      if (_responseBody?.isEmpty ?? true) {
        // ignore: prefer_const_declarations
        final _reason = 'Response returned empty body';
        Fimber.e('$_name $_reason');
        final _error = Exception(_reason);
        return ApiResultAsJSON<T>._(error: _error);
      }
      Fimber.i('$_name Request completed successfully');
      dynamic _responseJSON;

      try {
        if (!decodeResponse) {
          return ApiResultAsJSON<T>._(json: _responseBody);
        }
        _responseJSON = json.decode(_responseBody ?? '{}');
      } catch (e, t) {
        Fimber.e(
          'Error occurred when decoding response body to json. body was: $_responseBody',
          ex: e,
          stacktrace: t,
        );
        return ApiResultAsJSON<T>._(error: e, stackTrace: t);
      }

      return ApiResultAsJSON<T>._(json: _responseJSON);
    }
    String _reason;
    final String _requestDetails = """
    URL: ${_response?.request?.url}
    HEADERS: ${_response?.request?.headers}
    METHOD: ${_response?.request?.method}
    """;

    _reason =
        'Response returned status code: ${_response?.statusCode}.\n$_requestDetails';
    if (_response?.reasonPhrase?.isNotEmpty ?? false) {
      _reason = '$_reason ${_response?.reasonPhrase}';
    }

    Fimber.e('$_name $_reason');
    final _error = Exception(_reason);
    return ApiResultAsJSON<T>._(error: _error);
  }

  Future<ApiResult<T>> request(
    Uri uri, {
    required T Function(dynamic parsedJson) create,
    bool jsonHeader = true,
    bool encodeBody = true,
    Map<String, String> header = const {},
    Map<String, dynamic> body = const {},
    Map<String, dynamic> queryParameters = const {},
    ApiRequestType requestType = ApiRequestType.post,
    Duration? timeout,
  }) async {
    final _responseOrJSON = await requestJSON(
      uri,
      jsonHeader: jsonHeader,
      encodeBody: encodeBody,
      header: header,
      body: body,
      queryParameters: queryParameters,
      timeout: timeout,
      requestType: requestType,
    );

    // if true, this response is not a parsed json response.
    if (_responseOrJSON.hasError) return _responseOrJSON;

    try {
      final _data = create(_responseOrJSON.json);

      return ApiResult<T>(data: _data);
    } catch (e, t) {
      Fimber.e(
        'Error occurred when parsing json response to $T. Json was: ${_responseOrJSON.json}',
        ex: e,
        stacktrace: t,
      );
      return ApiResult(error: e, stackTrace: t);
    }
  }
}
