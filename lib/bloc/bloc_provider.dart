import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class Bloc {
  void dispose();
}

class BlocProvider<T extends Bloc> extends Provider<T> {
  BlocProvider({
    Key key,
    @required Create<T> create,
    bool lazy,
    TransitionBuilder builder,
    Widget child,
  }) : super(
          key: key,
          create: create,
          dispose: (_, b) => b.dispose(),
          lazy: lazy,
          builder: builder,
          child: child,
        );
}
