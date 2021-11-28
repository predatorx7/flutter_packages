import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<String?> deviceId() {
  final plugin = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    return plugin.androidInfo.then((info) => info.androidId);
  } else if (Platform.isIOS) {
    return plugin.iosInfo.then((info) => info.identifierForVendor);
  } else {
    return Future.value(null);
  }
}
