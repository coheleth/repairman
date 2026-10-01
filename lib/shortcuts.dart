import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class SaveIntent extends Intent {
  const SaveIntent();
}

class NewIntent extends Intent {
  const NewIntent();
}

class SaveEvent {}

class NewEvent {}

final shortcuts = <ShortcutActivator, Intent>{
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
      const SaveIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
      const NewIntent(),
};

class ShortcutController {
  ShortcutController._();
  static final ShortcutController _instance = ShortcutController._();
  factory ShortcutController() => _instance;

  final StreamController _controller = StreamController.broadcast();

  void dispatch(dynamic event) => _controller.add(event);

  Stream<T> on<T>() => _controller.stream.where((e) => e is T).cast<T>();
}
