import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YoutubePlayerScreen extends StatefulWidget {
  final String youtubeVideoId;
  final bool forceFullscreen;
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  const YoutubePlayerScreen({
    Key? key,
    required this.youtubeVideoId,
    this.forceFullscreen = true,
    this.gestureRecognizers,
  }) : super(key: key);

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  WebViewController? _controller;

  @override
  void initState() {
    if (widget.forceFullscreen) enableFullscreen();
    super.initState();
  }

  Future<void> enableFullscreen() async {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> disableFullscreen() async {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    if (widget.forceFullscreen) disableFullscreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerWidget = WebView(
      initialUrl: '',
      onWebViewCreated: (controller) {
        _controller = controller;
        _loadHtmlPlayer();
      },
      gestureRecognizers: widget.gestureRecognizers ??
          {
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
            ),
            Factory<HorizontalDragGestureRecognizer>(
              () => HorizontalDragGestureRecognizer(),
            ),
          },
      initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
      javascriptMode: JavascriptMode.unrestricted,
    );

    if (widget.forceFullscreen) {
      return DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: playerWidget,
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(),
      ),
      body: playerWidget,
    );
  }

  Future<void> _loadHtmlPlayer() async {
    final playableDataUri = Uri.dataFromString(player,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString();
    await _controller?.loadUrl(playableDataUri);
  }

  static String _boolean(bool value) => value ? '1' : '0';

  final autoPlay = true;
  final mute = false;
  final showControls = false;
  final playsInline = true;
  final enableJavaScript = true;
  final showFullscreenButton = false;
  final strictRelatedVideos = false;
  final showVideoAnnotations = true;
  final enableCaption = true;
  final captionLanguage = 'en';
  final startAt = Duration.zero;
  final Duration? endAt = null;
  final enableKeyboard = false;
  final color = 'white';
  final interfaceLanguage = 'en';
  final loop = false;
  final playlist = [];
  final privacyEnhanced = false;

  String youtubeIFrameTag() {
    final params = <String, String>{
      'autoplay': _boolean(autoPlay),
      'mute': _boolean(mute),
      'controls': _boolean(showControls),
      'playsinline': _boolean(playsInline),
      'enablejsapi': _boolean(enableJavaScript),
      'fs': _boolean(showFullscreenButton),
      'rel': _boolean(!strictRelatedVideos),
      'showinfo': '0',
      'iv_load_policy': '${showVideoAnnotations ? 1 : 3}',
      'modestbranding': '0',
      'cc_load_policy': _boolean(enableCaption),
      'cc_lang_pref': captionLanguage,
      'start': '${startAt.inSeconds}',
      if (endAt != null) 'end': '${endAt?.inSeconds}',
      'disablekb': _boolean(!enableKeyboard),
      'color': color,
      'hl': interfaceLanguage,
      'loop': _boolean(loop),
      if (playlist.isNotEmpty) 'playlist': playlist.join(',')
    };
    final youtubeAuthority =
        privacyEnhanced ? 'www.youtube-nocookie.com' : 'www.youtube.com';
    final sourceUri = Uri.https(
      youtubeAuthority,
      'embed/${widget.youtubeVideoId}',
      params,
    );
    return '<iframe id="player" type="text/html"'
        ' style="position:absolute; top:0px; left:0px; bottom:0px; right:10px;'
        ' width:100%; height:100%; border:none; margin:0; padding:0; overflow:hidden; z-index:999999;"'
        ' src="$sourceUri" frameborder="0" allowfullscreen></iframe>';
  }

  String get initPlayerIFrame => '''
var tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
''';

  String get youtubeIFrameFunctions => '''
function play() {
  player.playVideo();
  return '';
}
function pause() {
  player.pauseVideo();
  return '';
}
function loadById(loadSettings) {
  player.loadVideoById(loadSettings);
  return '';
}
function cueById(cueSettings) {
  player.cueVideoById(cueSettings);
  return '';
}
function loadPlaylist(loadSettings) {
  player.loadPlaylist(loadSettings);
  return '';
}
function cuePlaylist(loadSettings) {
  player.cuePlaylist(loadSettings);
  return '';
}
function mute() {
  player.mute();
  return '';
}
function unMute() {
  player.unMute();
  return '';
}
function setVolume(volume) {
  player.setVolume(volume);
  return '';
}
function seekTo(position, seekAhead) {
  player.seekTo(position, seekAhead);
  return '';
}
function setSize(width, height) {
  player.setSize(width, height);
  return '';
}
function setPlaybackRate(rate) {
  player.setPlaybackRate(rate);
  return '';
}
function setLoop(loopPlaylists) {
  player.setLoop(loopPlaylists);
  return '';
}
function setShuffle(shufflePlaylist) {
  player.setShuffle(shufflePlaylist);
  return '';
}
function previous() {
  player.previousVideo();
  return '';
}
function next() {
  player.nextVideo();
  return '';
}
function playVideoAt(index) {
  player.playVideoAt(index);
  return '';
}
function stop() {
  player.stopVideo();
  return '';
}
function isMuted() {
  return player.isMuted();
}
function hideTopMenu() {
  try { document.querySelector('#player').contentDocument.querySelector('.ytp-chrome-top').style.display = 'none'; } catch(e) { }
  return '';
}
function hidePauseOverlay() {
  try { document.querySelector('#player').contentDocument.querySelector('.ytp-pause-overlay').style.display = 'none'; } catch(e) { }
  return '';
}
''';

  String get player => '''
    <!DOCTYPE html>
    <body>
         ${youtubeIFrameTag()}
        <script>
            $initPlayerIFrame
            var player;
            var timerId;
            function onYouTubeIframeAPIReady() {
                player = new YT.Player('player', {
                    events: {
                        onReady: function(event) { window.flutter_inappwebview.callHandler('Ready'); },
                        onStateChange: function(event) { sendPlayerStateChange(event.data); },
                        onPlaybackQualityChange: function(event) { window.flutter_inappwebview.callHandler('PlaybackQualityChange', event.data); },
                        onPlaybackRateChange: function(event) { window.flutter_inappwebview.callHandler('PlaybackRateChange', event.data); },
                        onError: function(error) { window.flutter_inappwebview.callHandler('Errors', error.data); }
                    },
                });
            }

            function sendPlayerStateChange(playerState) {
                clearTimeout(timerId);
                window.flutter_inappwebview.callHandler('StateChange', playerState);
                if (playerState == 1) {
                    startSendCurrentTimeInterval();
                    sendVideoData(player);
                }
            }

            function sendVideoData(player) {
                var videoData = {
                    'duration': player.getDuration(),
                    'title': player.getVideoData().title,
                    'author': player.getVideoData().author,
                    'videoId': player.getVideoData().video_id
                };
                window.flutter_inappwebview.callHandler('VideoData', videoData);
            }

            function startSendCurrentTimeInterval() {
                timerId = setInterval(function () {
                    window.flutter_inappwebview.callHandler('VideoTime', player.getCurrentTime(), player.getVideoLoadedFraction());
                }, 100);
            }

            $youtubeIFrameFunctions
        </script>
    </body>
  ''';
}
