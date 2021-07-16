import 'package:http/http.dart' as http;
import 'package:relaxed_client/src/extensions.dart';

/// Deserializes a String [value] to Deserialized (or Decoded) data of type [DecodedDataType].
/// 
/// For example: A string which has data following JSON notation to a data class.
typedef ResponseBodyDecoderCallback<DecodedDataType> = DecodedDataType Function(String value);

/// Parses the serialized (or decoded)
typedef ResponseBodyParserCallback<ParsedDataType, DecodedDataType> = ParsedDataType Function(DecodedDataType value);

/// Parses a response body as a string to a data class or some other data structure.
class ParsedResponse<ParsedDataType, DecodedDataType> {
  final http.Response response;
  final ResponseBodyDecoderCallback<DecodedDataType> decodeData;
  final ResponseBodyParserCallback<ParsedDataType, DecodedDataType> parseData;

  Object? parsingError;
  StackTrace? parsingErrorStackTrace;

  Uri? get url => response.request?.url;

  ParsedResponse({
    required this.response,
    required this.parseData,
    required this.decodeData,
  }) {
    _parse();
  }

  ParsedDataType? _parsedData;

  void _parse() {
    try {
      final _decodedResponse = decodeData(response.body);
      _parsedData = parseData(_decodedResponse);
    } catch (e, s) {
      parsingError = e;
      parsingErrorStackTrace = s;
    }
  }

  bool get isSuccessful => _parsedData != null && parsingError == null;
  bool get hasParsingError => parsingError != null && _parsedData == null;

  ParsedDataType get data {
    assert(isSuccessful, "Don't request data when parsing wasn't successful");
    return _parsedData!;
  }
}
