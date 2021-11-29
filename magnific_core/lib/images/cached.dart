import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

bool doNotCacheInDebug = true;

typedef CachedNetworkImageProviderCallback = ImageProvider<Object> Function(
  String networkPath,
);

/// A function that returns an ImageProvider that caches the network image.
///
/// Set this to [CachedNetworkImageProvider] of the `package:cached_network_image` package or some other image provider that caches network image.
CachedNetworkImageProviderCallback? cachedNetworkImageProviver;

/// This returns an Image Provide that caches network images in release mode and when [kisWeb] is false.
///
/// Returns a regular [NetworkImage] while debugging or [kIsWeb] is true.
/// To provide cached images in debug, set [doNotCacheInDebug] to `false`
ImageProvider<Object> cachedImageProviderFactory(String networkPath) {
  assert(
    cachedNetworkImageProviver != null,
    'Please set an image provider to `cachedNetworkImageProviver` that caches and returns network image like [CachedNetworkImageProvider].',
  );

  if (kIsWeb || (kDebugMode && doNotCacheInDebug)) {
    // Web may not support image local caching so we just return the network image for in-memory caching.
    // To get images in Network debugger in devtools in debug mode, we return network image and not cached images.
    return NetworkImage(networkPath);
  } else {
    return cachedNetworkImageProviver!(networkPath);
  }
}
