import 'package:flutter/services.dart';

class SystemUIControls {
  SystemUIControls._();

  static Future<void> enableFullscreen() {
    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  ///
  /// ### Note
  /// 1. iPhone users generally prefers full screen apps to have this orientatio; Thus, this method sets orientation to `landscapeRight` first.
  /// 2. Opt out of multitasking you can do this by setting "Requires full screen" to true in the Xcode Deployment Info.
  static Future<void> enableLandscapeOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  static Future<void> disableLandscapeOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  static Future<void> disableFullscreen({
    SystemUiMode mode = SystemUiMode.edgeToEdge,
  }) {
    return SystemChrome.setEnabledSystemUIMode(mode);
  }
}
