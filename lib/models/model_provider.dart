import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Watches model (implementing [ChangeNotifier]) and immediately consumes it.
/// It's a combination of [ChangeNotifierProvider] and [Consumer].
class ModelProvider<T extends ChangeNotifier> extends StatelessWidget {
  final T value;
  final Widget child;
  final Widget Function(BuildContext context, T value, Widget child) builder;

  const ModelProvider({Key key, this.value, this.child, this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: value,
      builder: (context, child) => Consumer<T>(builder: builder, child: child),
      child: child,
    );
  }
}
