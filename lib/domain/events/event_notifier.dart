import 'dart:async';
import 'board_events.dart';

class EventNotifier {
  static final EventNotifier _instance = EventNotifier._internal();
  factory EventNotifier() => _instance;
  EventNotifier._internal();
  
  final _controller = StreamController<BoardEvent>.broadcast();
  Stream<BoardEvent> get stream => _controller.stream;
  
  StreamSubscription<BoardEvent> subscribe(void Function(BoardEvent) onEvent) {
    return stream.listen(onEvent);
  }

  void notify(BoardEvent event) {
    _controller.add(event);
  }
  
  void dispose() {
    _controller.close();
  }
}
