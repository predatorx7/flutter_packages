import 'package:magnific_core/system/system.dart';

import 'platform.dart' if (dart.library.html) 'web.dart';

Future<String?> getDeviceId() async {
  try {
    return deviceId();
  } catch (e, s) {
    logger.warning('Failed to obtain device unique id', e, s);
  }
}
