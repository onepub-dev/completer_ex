import 'dart:async';
import 'package:stacktrace_impl/stacktrace_impl.dart';
import 'package:simple_logger/simple_logger.dart';

class CompleterEx<T> implements Completer<T> {
  final Completer<T> _completer = Completer();

  final StackTraceImpl stackTrace;
  final DateTime _createdAt;

  static var _report_after = Duration(seconds: 10);

  CompleterEx()
      : stackTrace = StackTraceImpl(skipFrames: 1),
        _createdAt = DateTime.now() {
    /// If the completer is not complete after 10 seconds then
    /// dump its stack trace.
    Future<void>.delayed(_report_after, _report);
  }

  set reportInterval(Duration duration) => _report_after = duration;

  void _report() {
    if (!_completer.isCompleted) {
      /// We delay creating the logger until we must have it.
      /// This means we have minimal impact on the 'good' path.
      final logger = SimpleLogger();
      logger.setLevel(Level.FINE);
      logger.fine(
          'Completer failed to complete after ${DateTime.now().difference(_createdAt)} seconds');
      logger.fine('CreatedBy: ${stackTrace.formatStackTrace()}');

      /// reprint if it still isn't complete after another
      Future<void>.delayed(_report_after, _report);
    }
  }

  @override
  void complete([FutureOr<T> value]) {
    _completer.complete(value);
  }

  @override
  void completeError(Object error, [StackTrace stackTrace]) {
    _completer.completeError(error, stackTrace);
  }

  @override
  Future<T> get future => _completer.future;

  @override
  bool get isCompleted => _completer.isCompleted;
}
