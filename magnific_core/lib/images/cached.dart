import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

bool doNotCacheInDebug = true;

/// This returns a [CachedNetworkImageProvider]
/// of the `package:cached_network_image` in release mode and when [kisWeb] is false.
///
/// Returns a regular [NetworkImage] while debugging or [kIsWeb] is true.
/// To provide cached images in debug, set [doNotCacheInDebug] to `false`
ImageProvider<Object> cachedImageProviderFactory(String networkPath) {
  if (kIsWeb || (kDebugMode && doNotCacheInDebug)) {
    // Web may not support image local caching so we just return the network image for in-memory caching.
    // To get images in Network debugger in devtools in debug mode, we return network image and not cached images.
    return NetworkImage(networkPath);
  } else {
    return CachedNetworkImageProvider(networkPath);
  }
}
