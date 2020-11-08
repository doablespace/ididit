import 'package:flutter/foundation.dart';

extension Once<T> on ValueListenable<T> {
  void once(VoidCallback callback) {
    VoidCallback cb;
    cb = () {
      this.removeListener(cb);
      callback();
    };
    this.addListener(cb);
  }
}
