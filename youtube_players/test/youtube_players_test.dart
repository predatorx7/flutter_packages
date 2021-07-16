import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_players/src/uri.dart';
import 'package:youtube_players/src/utils.dart';

void main() {
  test('YoutubeUtils', () {
    expect(
      YoutubeUtils.convertIdToUrl(
        '1KeJc6V4Jjk',
      ),
      'www.youtube.com/watch?v=1KeJc6V4Jjk',
      reason: 'ID to URL match failed',
    );

    expect(
      YoutubeUtils.convertUrlToId(
        'https://www.youtube.com/watch?v=1KeJc6V4Jjk',
      ),
      '1KeJc6V4Jjk',
      reason: 'URL to ID match failed',
    );
  });

  test('For YoutubeUri with valid URI & VideoId', () {
    // ignore: prefer_const_constructors
    final _uriFromId = YoutubeUri.fromId(
      '1KeJc6V4Jjk',
    );
    final _uriFromUrl = YoutubeUri.fromUri(
      'https://www.youtube.com/watch?v=1KeJc6V4Jjk',
    );

    expect(
      _uriFromId.uri,
      'www.youtube.com/watch?v=1KeJc6V4Jjk',
    );

    expect(
      _uriFromUrl.uri,
      'www.youtube.com/watch?v=1KeJc6V4Jjk',
    );

    expect(
      _uriFromId.videoId,
      '1KeJc6V4Jjk',
    );

    expect(
      _uriFromUrl.videoId,
      '1KeJc6V4Jjk',
    );

    expect(
      _uriFromId.uriHttpsScheme,
      'https://www.youtube.com/watch?v=1KeJc6V4Jjk',
    );

    expect(
      _uriFromUrl.uriHttpsScheme,
      'https://www.youtube.com/watch?v=1KeJc6V4Jjk',
    );

    expect(
      _uriFromId.uriAppScheme,
      'youtube://www.youtube.com/watch?v=1KeJc6V4Jjk',
    );

    expect(
      _uriFromUrl.uriAppScheme,
      'youtube://www.youtube.com/watch?v=1KeJc6V4Jjk',
    );

    expect(_uriFromId.isValid, true);
    expect(_uriFromUrl.isValid, true);
  });

  test('For YoutubeUri with invalid URI & VideoId', () {
    // ignore: prefer_const_constructors
    final _uriFromId = YoutubeUri.fromId(
      '1KeJc6V4Jjkx',
    );
    final _uriFromUrl = YoutubeUri.fromUri(
      'www.youtube..com/jbjkxscwsacaACtcsch?Sc=sc1KeJc6V4Jjk',
    );

    expect(_uriFromId.isValid, false);
    expect(_uriFromUrl.isValid, false);
  });
}
