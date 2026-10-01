import 'dart:async';

import 'package:flutter/material.dart';

class SnackBarEvent {
  final SnackBar snackBar;
  SnackBarEvent({required this.snackBar});
}

class MessagingController {
  MessagingController._();
  static final MessagingController _instance = MessagingController._();
  factory MessagingController() => _instance;

  final StreamController _controller = StreamController.broadcast();

  void dispatch(dynamic event) => _controller.add(event);

  Stream<T> on<T>() => _controller.stream.where((e) => e is T).cast<T>();

  void sendSnackBar(SnackBar snackBar) {
    _controller.add(SnackBarEvent(snackBar: snackBar));
  }
}
