String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

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
