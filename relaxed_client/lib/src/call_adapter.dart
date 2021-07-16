import 'dart:async';

import 'package:relaxed_client/src/api_response.dart';
import 'package:relaxed_client/src/response_parser.dart';

class CallAdapter<RESULT_TYPE, DECODED_RESPONSE_TYPE> {
  final completableFuture = Completer<ApiResponse<RESULT_TYPE>>();

  Future<void> adapt(
      Future<ParsedResponse<RESULT_TYPE, DECODED_RESPONSE_TYPE>> call) async {
    try {
      final response = await call;
      onResponse(response);
    } catch (e, s) {
      onFailure(e, s);
    }
  }

  void onResponse(ParsedResponse<RESULT_TYPE, DECODED_RESPONSE_TYPE> response) {
    completableFuture.complete(ApiResponse.create(response));
  }

  void onFailure(Object throwable, StackTrace stackTrace) {
    completableFuture.complete(
      ApiResponse.createProcessingError<RESULT_TYPE>(throwable, stackTrace),
    );
  }

  Future<ApiResponse<RESULT_TYPE>> asFuture() {
    return completableFuture.future;
  }
}
