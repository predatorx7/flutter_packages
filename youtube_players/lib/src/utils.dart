class YoutubeUtils {
  YoutubeUtils._();

  static const String youtubeUrlRegex$1 =
      r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$";
  static const String youtubeUrlRegex$2 =
      r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$";
  static const String youtubeUrlRegex$3 =
      r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$";

  static String? convertUrlToId(
    String videoUrl, {
    bool trimWhitespaces = true,
  }) {
    assert(videoUrl.isNotEmpty, 'Url cannot be empty');
    if (!videoUrl.contains("http") && (videoUrl.length == 11)) return videoUrl;
    final _videoUrl = trimWhitespaces ? videoUrl.trim() : videoUrl;
    for (final exp in [
      RegExp(youtubeUrlRegex$1),
      RegExp(youtubeUrlRegex$2),
      RegExp(youtubeUrlRegex$3),
    ]) {
      final Match? match = exp.firstMatch(_videoUrl);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }
  }

  static String convertIdToUrl(String videoId) {
    final _videoId = videoId.trim();
    assert(_videoId.isNotEmpty, 'Video Id cannot be empty');

    return 'www.youtube.com/watch?v=$_videoId';
  }
}
