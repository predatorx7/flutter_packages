import 'package:youtube_players/src/utils.dart';

/// A representation of a youtube video URL for use in a youtube player.
class YoutubeUri {
  final String videoId;

  /// Creates a [YoutubeUri] of a youtube video with [videoId]
  const YoutubeUri.fromId(this.videoId);

  /// Creates a [YoutubeUri] of a youtube video with [videoUrl]
  YoutubeUri.fromUri(String videoUrl)
      : videoId = YoutubeUtils.convertUrlToId(videoUrl) ?? '';

  bool get isValid =>
      videoId.trim().isNotEmpty &&
      !videoId.contains("http") &&
      videoId.length == 11;

  String get path => '/watch';

  Map<String, String> get params => {
        'v': videoId,
      };

  String get encodedParams {
    final _params = params;
    final _keys = _params.keys;

    final _encodedParamsBuffer = StringBuffer();

    for (var i = 0; i < _keys.length; i++) {
      final _key = _keys.elementAt(i);
      final _value = _params[_key];
      _encodedParamsBuffer.write('$_key=$_value');
      if (i < _keys.length - 1) {
        _encodedParamsBuffer.write('&');
      }
    }

    return _encodedParamsBuffer.toString();
  }

  static const _authority = 'www.youtube.com';

  String get uri => '$_authority$path?$encodedParams';

  static const _httpsScheme = 'https';

  String get uriHttpsScheme => '$_httpsScheme://$uri';

  static const _appScheme = 'youtube';

  String get uriAppScheme => '$_appScheme://$uri';

  @override
  String toString() => uri;
}
