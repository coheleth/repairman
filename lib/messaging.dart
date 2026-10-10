import 'dart:async';

import 'package:material_ui/material_ui.dart';

class SnackBarEvent {
  final SnackBar snackBar;
  final bool hidePrevious;
  SnackBarEvent({required this.snackBar, this.hidePrevious = true});
}

class MessagingController {
  MessagingController._();
  static final MessagingController _instance = MessagingController._();
  factory MessagingController() => _instance;

  final StreamController _controller = StreamController.broadcast();

  void dispatch(dynamic event) => _controller.add(event);

  Stream<T> on<T>() => _controller.stream.where((e) => e is T).cast<T>();

  void sendSnackBar(SnackBar snackBar, {bool hidePrevious = true}) {
    _controller.add(
      SnackBarEvent(snackBar: snackBar, hidePrevious: hidePrevious),
    );
  }
}
