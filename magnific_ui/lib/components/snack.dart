import 'package:flutter/material.dart';

class AppSnackbar {
  final BuildContext context;
  final SnackBarBehavior? behavior;

  static SnackBarBehavior? defaultBehavior = SnackBarBehavior.fixed;

  AppSnackbar.of(
    this.context, {
    this.behavior,
  });

  ScaffoldMessengerState get _state {
    return ScaffoldMessenger.of(context);
  }

  void success(String text) {
    _state.clearSnackBars();
    _state.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        behavior: behavior ?? defaultBehavior,
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void info(String text) {
    _state.clearSnackBars();
    _state.showSnackBar(
      SnackBar(
        behavior: behavior ?? AppSnackbar.defaultBehavior,
        content: Text(text),
      ),
    );
  }

  void error(String text) {
    _state.clearSnackBars();
    _state.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        behavior: behavior ?? defaultBehavior,
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void warning(String text) {
    _state.clearSnackBars();
    _state.showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange,
        behavior: behavior ?? defaultBehavior,
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
