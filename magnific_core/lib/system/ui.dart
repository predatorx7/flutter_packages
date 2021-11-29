import 'package:flutter/services.dart';

class SystemUIControls {
  SystemUIControls._();

  /// Enables full screen mode by switching to [SystemUiMode.immersive] as system ui mode.
  static Future<void> enableFullscreen() {
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  /// Enables landscape orientation by switching to landscapeRight orientation
  /// and then enabling [DeviceOrientation.landscapeRight] and [DeviceOrientation.landscapeLeft] orientations.
  ///
  /// ### Note
  /// 1. iPhone users generally prefers full screen apps to have this orientation; Thus, this method sets orientation to `landscapeRight` first.
  /// 2. You can opt out of multitasking by setting "Requires full screen" to true in the Xcode Deployment Info to resolve limitation in [SystemChrome.setPreferredOrientations].
  static Future<void> enableLandscapeOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  /// Disables landscape orientation by switching to portrait orientation and then enabling all orientations.
  static Future<void> disableLandscapeOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  /// Disables full screen mode by switching to [mode] as system ui mode.
  static Future<void> disableFullscreen({
    SystemUiMode mode = SystemUiMode.edgeToEdge,
  }) {
    return SystemChrome.setEnabledSystemUIMode(mode);
  }
}
