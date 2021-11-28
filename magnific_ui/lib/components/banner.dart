import 'package:flutter/material.dart';

class AppBanner {
  final BuildContext context;

  AppBanner.of(
    this.context,
  );

  ScaffoldMessengerState get _state {
    return ScaffoldMessenger.of(context);
  }

  void success(String text) {
    _state.clearMaterialBanners();
    _state.showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.green,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            child: const Text('OK'),
            onPressed: () {
              _state.hideCurrentMaterialBanner();
            },
          ),
        ],
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void error(String text) {
    _state.clearMaterialBanners();
    _state.showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.red,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            child: const Text('OK'),
            onPressed: () {
              _state.hideCurrentMaterialBanner();
            },
          ),
        ],
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
    _state.clearMaterialBanners();
    _state.showMaterialBanner(
      MaterialBanner(
        backgroundColor: Colors.orange,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            child: const Text('OK'),
            onPressed: () {
              _state.hideCurrentMaterialBanner();
            },
          ),
        ],
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
