import 'package:fimber/fimber.dart';
import 'package:http/http.dart';
import 'package:relaxed_client/src/extensions.dart';
import 'package:relaxed_client/src/response_parser.dart';

/// Common class used by API responses.
abstract class ApiResponse<T> {
  /// Creates an API response that includes error which happened during API response's processing.
  static ApiResponseProcessingError<T> createProcessingError<T>(
    Object error,
    StackTrace stackTrace,
  ) {
    final String _errorMessage = error.toString();
    return ApiResponseProcessingError(
      _errorMessage.isEmpty ? "Unknown error" : _errorMessage,
      stackTrace,
    );
  }

  static ApiResponse<RESULT_TYPE>? create<RESULT_TYPE, DECODED_RESPONSE_TYPE>(
    ParsedResponse<RESULT_TYPE, DECODED_RESPONSE_TYPE> response,
  ) {
    Fimber.i("response received from ${response.request?.url}");

    if (response.isSuccessful) {
      final body = response.body;
      if (body.isEmpty || response.statusCode == 204) {
        return ApiEmptyResponse();
      } else {
        final parsedBody = parseBody(body);
        return ApiSuccessResponse<T>(parsedBody);
      }
    } else {
      final errorBody = response.body;
      final String errorMessage = response.reasonPhrase ?? '';
      return ApiErrorResponse(
        errorBody.isEmpty ? "unknown error" : errorBody,
        response.statusCode,
        errorMessage,
      );
    }
  }
}

class ApiSuccessResponse<T> extends ApiResponse<T> {
  final T body;

  ApiSuccessResponse(this.body);
}

/// separate class for HTTP 204 responses so that we can make ApiSuccessResponse's body non-null.
class ApiEmptyResponse<T> extends ApiResponse<T> {}

class ApiErrorResponse<T> extends ApiResponse<T> {
  final String errorBody;
  final int statusCode;
  final String? statusCodeReason;

  ApiErrorResponse(
    this.errorBody,
    this.statusCode,
    this.statusCodeReason,
  );
}

class ApiResponseProcessingError<T> extends ApiErrorResponse<T> {
  final String errorMessage;
  final StackTrace stackTrace;

  ApiResponseProcessingError(
    this.errorMessage,
    this.stackTrace,
  ) : super(
          stackTrace.toString(),
          // Used here to indicate a client device error which happened during processing of request/response
          // Reference https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/422
          422,
          errorMessage,
        );
}
