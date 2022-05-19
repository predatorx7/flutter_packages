import 'dart:developer';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_players/src/error_snackbar.dart';
import 'package:youtube_players/src/player.dart';
import 'package:youtube_players/src/uri.dart';

class YoutubePlayer {
  final YoutubeUri uri;
  final String _errorMessage;
  final bool _forceFullscreen;
  final Set<Factory<OneSequenceGestureRecognizer>>? _gestureRecognizers;

  /// YoutubePlayer parses [uri] and provides various ways to run a video with [uri] in a player.
  ///
  /// Keep [forceFullscreen] true to force any supporting players to enable fullscreen.
  /// [errorMessage] will be shown in [SnackBar] to users if any errors happen.
  YoutubePlayer(
    this.uri, {
    String errorMessage = youtubePlayerErrorMessage,
    bool forceFullscreen = true,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
  })  : _errorMessage = errorMessage,
        _forceFullscreen = forceFullscreen,
        _gestureRecognizers = gestureRecognizers;

  /// When [inApp] is called, upon any failures if this is true then youtube iframe player in webview_flutter is opened using [inWebview].
  static bool enableFallback = true;

  /// Opens youtube player using Youtube's API for iframe in `webview_flutter`
  ///
  /// This approach has lower chances of failures.
  Future<Object?> inWebview(BuildContext context) {
    if (!uri.isValid) {
      final messengerState = ScaffoldMessenger.of(context);
      onYoutubePlayerError(messengerState, _errorMessage);
      return Future.value(false);
    }

    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => YoutubePlayerScreen(
          youtubeVideoId: uri.videoId,
          forceFullscreen: _forceFullscreen,
          gestureRecognizers: _gestureRecognizers,
        ),
      ),
    );
  }

  /// Parses [uri] and opens Youtube's android app if installed, else platform handles it.
  Future<bool> inAndroidApp() async {
    // only works on android
    assert(Platform.isAndroid, 'Platform is not android');

    // If android, try launching URL with intents
    try {
      final intent = AndroidIntent(
        action: 'action_view',
        data: uri.uriHttpsScheme,
        arguments: {
          "force_fullscreen": _forceFullscreen,
        },
      );
      await intent.launch();
      return true;
    } catch (e, s) {
      log(
        'Failed to launch URL via intent on android',
        level: Level.SEVERE.value,
        error: e,
        stackTrace: s,
      );
    }
    return false;
  }

  /// Parses the youtube [uri] URL with youtube's scheme `youtube://` and delegates handling of it to
  /// the underlying platform.
  ///
  /// This might open youtube app.
  Future<bool> launchWithYoutubeScheme() async {
    if (await canLaunch(uri.uriAppScheme)) {
      return launch(
        uri.uriAppScheme,
        forceSafariVC: false,
      );
    }
    return false;
  }

  /// Parses the youtube [uri] URL with scheme `https://` and delegates handling of it to
  /// the underlying platform.
  Future<bool> launchWithHttpScheme() async {
    if (await canLaunch(uri.uriHttpsScheme)) {
      return launch(
        uri.uriHttpsScheme,
        forceSafariVC: false,
      );
    }
    return false;
  }

  /// Parses [uri] and opens Youtube's IOS app if possible, else platform handles it.
  Future<bool> inIOS() async {
    if (await launchWithYoutubeScheme()) {
      return true;
    }
    return launchWithHttpScheme();
  }

  /// Parses and opens [uri] in Youtube app if possible, else platform handles it.
  ///
  /// If [uri] launching fails and [enableFallback] is true then opens youtube iframe player in webview_flutter using [inWebview].
  /// On failures, a snackbar is shown with [errorMessage].
  Future<Object?> inApp(BuildContext context) async {
    final messengerState = ScaffoldMessenger.of(context);
    if (!uri.isValid) {
      onYoutubePlayerError(
        messengerState,
        _errorMessage,
        'Youtube uri "$uri" is invalid',
      );
      return false;
    }

    bool didOpen = false;

    try {
      if (Platform.isAndroid) {
        didOpen = await inAndroidApp();
      } else if (Platform.isIOS) {
        didOpen = await inIOS();
      } else {
        await inWebview(context);
      }

      if (didOpen) {
        return true;
      }
    } catch (e, s) {
      if (!enableFallback && (Platform.isAndroid || Platform.isIOS)) {
        onYoutubePlayerError(
          messengerState,
          _errorMessage,
          'Something went wrong',
          e,
          s,
        );
        return false;
      }
      // open video in webview as fallback if previous methods failed on android or IOS
    }

    try {
      // ignore: use_build_context_synchronously
      return await inWebview(context);
    } catch (e, s) {
      onYoutubePlayerError(
        messengerState,
        _errorMessage,
        'Something went wrong',
        e,
        s,
      );
      return false;
    }
  }
}
