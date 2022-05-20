// ignore_for_file: provide_deprecation_message

/// Wraps a string with div with id `wrapWithDiv`.
@deprecated
String wrapWithDiv(String? html) {
  return '<div id="wrapWithDiv">${html ?? ""}</div>';
}
