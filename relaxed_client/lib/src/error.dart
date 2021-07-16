import 'dart:io';

class ConnectionError extends IOException {
  String get message => 'Check your network connectivity';

  @override
  String toString() => 'ConnectionException: $message';
}
