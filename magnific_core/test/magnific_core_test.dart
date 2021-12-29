// import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:magnific_core/strings/uri.dart';

void main() {
  test('tests for encodeQueryParameters', () {
    expect(
      encodeQueryParameters({
        'a': 'b',
        'c': 'd',
      }),
      'a=b&c=d',
    );
    expect(
      encodeQueryParameters({
        'a': null,
        'c': 'd',
      }),
      'c=d',
    );
    expect(
      encodeQueryParameters(
        {
          'a': null,
          'c': 'd',
        },
        keepNull: true,
      ),
      'a=&c=d',
    );
    expect(
      encodeQueryParameters(
        {
          'a': null,
          'c': 'd',
        },
        keepNull: true,
      ) == 'a&c=d',
      false,
    );
    expect(
      encodeQueryParameters(
        {
          'a': '',
          'c': 'd',
        },
        keepEmpty: true, 
      ),
      'a=&c=d',
    );
    expect(
      encodeQueryParameters(
        {
          'a': ' ',
          'c': 'd',
        },
        keepEmpty: true,
        keepBlank: true, 
      ),
      'a=+&c=d',
    );
  });
}
