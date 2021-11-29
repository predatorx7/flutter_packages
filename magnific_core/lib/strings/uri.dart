/// Returns a string encoded map of html query parameters.
String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
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
