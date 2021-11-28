/// Wraps a string with div with id `wrapWithDiv`.
String wrapWithDiv(String? html) {
  return '<div id="wrapWithDiv">${html ?? ""}</div>';
}
