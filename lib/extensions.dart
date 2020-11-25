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

extension MapIndexed<T> on Iterable<T> {
  Iterable<E> mapIndexed<E>(E Function(int index, T item) f) sync* {
    var index = 0;
    for (final item in this) {
      yield f(index, item);
      index = index + 1;
    }
  }
}
