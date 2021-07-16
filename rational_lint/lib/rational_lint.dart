/// The rational_lint package.
///
/// To enable `rational_lint`,
/// 1. Add it to your dev_dependencies
/// ```yaml
/// dev_dependencies:
///   rational_lint: ^1.0.0
/// ```
///
/// 2. Include the rules into your `analysis_options.yaml`
/// ```yaml
/// include: package:rational_lint/analysis_options.yaml
/// ```
///
/// Check this package's README.md for more.
library rational_lint;

/// Copied from [package:pedantic](https://pub.dev/packages/pedantic)
/// Indicates to tools that `Future` is intentionally not `await`-ed.
///
/// In an `async` context, it is normally expected that all `Future`s are
/// awaited, and that is the basis of the lint `unawaited_futures`. However,
/// there are times where one or more futures are intentionally not awaited.
/// This function may be used to ignore a particular future. It silences the
/// `unawaited_futures` lint.

/// Indicates to tools that [future] is intentionally not `await`-ed.
///
/// In an `async` context, it is normally expected that all [Future]s are
/// awaited, and that is the basis of the lint `unawaited_futures`. However,
/// there are times where one or more futures are intentionally not awaited.
/// This function may be used to ignore a particular future. It silences the
/// `unawaited_futures` lint.
///
/// ```
/// Future<void> saveUserPreferences() async {
///   await _writePreferences();
///
///   // While 'log' returns a Future, the consumer of 'saveUserPreferences'
///   // is unlikely to want to wait for that future to complete; they only
///   // care about the preferences being written).
///   unawaited(log('Preferences saved!'));
/// }
/// ```
void unawaited(Future<void>? future) {}
