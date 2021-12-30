import 'package:magnific_core/magnific_core.dart';

/// Returns a string encoded map of html query parameters.
String encodeQueryParameters(
  Map<String, String?> params, {
  bool keepNull = false,
  bool keepEmpty = true,
  bool keepBlank = true,
}) {
  final buffer = StringBuffer();

  for (var i = 0; i < params.entries.length; i++) {
    final e = params.entries.elementAt(i);
    final value = e.value;
    if (!keepNull && value == null) continue;
    if (!keepEmpty && (value?.isNotEmpty != true)) continue;
    if (!keepEmpty && !keepBlank && StringX.isBlank(value)) continue;
    
    buffer.write('${e.key}=');
    if (value != null) {
      buffer.write(Uri.encodeQueryComponent(value));
    }
    if (i < params.entries.length - 1) {
      buffer.write('&');
    }
  }
  
  return buffer.toString();
}

/// Returns a [Uri] that can be used to create an intent for emails with [recipient], [subject], and [body].
///
/// Can be used with Uri launcher.
Uri emailLaunchUri(String recipient, String subject, String? body) {
  return Uri(
    scheme: 'mailto',
    path: recipient,
    query: encodeQueryParameters(<String, String>{
      'subject': subject,
      'body': body ?? '',
    }),
  );
}
