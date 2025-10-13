import 'dart:async';

class SosNotifier {
  static final SosNotifier _instance = SosNotifier._internal();
  factory SosNotifier() => _instance;
  SosNotifier._internal();

  final _controller = StreamController<String>.broadcast();

  Stream<String> get stream => _controller.stream;

  void triggerSOS(String commuterName) {
    _controller.add(commuterName);
  }
}