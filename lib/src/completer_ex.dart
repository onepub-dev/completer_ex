import 'dart:async';
import 'package:stacktrace_impl/stacktrace_impl.dart';
import 'package:simple_logger/simple_logger.dart';

class CompleterEx<T> implements Completer<T> {
  final Completer<T> _completer = Completer();

  late final logger = SimpleLogger();

  final StackTraceImpl stackTrace;
  final DateTime _createdAt;

  static var _default_expected_duration = const Duration(seconds: 10);
  static var _default_report_interval = const Duration(seconds: 10);

  late final Duration _expected_duration;
  late final Duration _report_interval;

  /// Creates a Completer which logs if the completer hasn't
  /// completed by [expectedDuration].
  ///
  /// [expectedDuration] specifies the duration before we first report
  /// that the completer hasn't completed.
  /// If null is passed then the value set by [setDefaultExepectedDuration] is used
  /// which defaults to 10 seconds.
  /// [reportInterval] specifies the duration between subsequent reporting
  /// events.
  /// If null is passed then the value set by [setDefaultReportInterval] is used
  /// which defaults to 10 seconds.
  CompleterEx({Duration? expectedDuration, Duration? reportInterval})
      : stackTrace = StackTraceImpl(skipFrames: 1),
        _createdAt = DateTime.now() {
    _expected_duration = expectedDuration ?? _default_expected_duration;
    _report_interval = reportInterval ?? _default_report_interval;

    /// If the completer has not complete after [report_after] seconds then
    /// dump its stack trace.
    Future<void>.delayed(_expected_duration, _report);
  }

  /// Allows you globally to set the amount of time to wait before reporting
  /// that the completer hasn't completed. Any CompleterEx's created after
  /// this call will use this as their default.
  /// Use the constructor's named argument [expectedDuration] argument to set this value
  /// on a per [CompleterEx] basis.
  set setDefaultExepectedDuration(Duration duration) =>
      _default_expected_duration = duration;

  /// Allows you globally to set the amount of time to wait before reporting
  /// that the completer hasn't completed. Any CompleterEx's created after
  /// this call will use this as their default.
  /// Use the constructors [reportInterval] argument to set this value
  /// on a per [CompleterEx] basis.
  ///
  set setDefaultReportInterval(Duration duration) =>
      _default_report_interval = duration;

  void _report() {
    if (!_completer.isCompleted) {
      /// We delay creating the logger until we must have it.
      /// This means we have minimal impact on the 'good' path.

      logger.setLevel(Level.FINE);
      logger.fine(
          'Completer failed to complete after ${DateTime.now().difference(_createdAt)} seconds, created At: $_createdAt');
      logger.fine('CreatedBy: ${stackTrace.formatStackTrace()}');

      /// reprint if it still isn't complete after another
      Future<void>.delayed(_report_interval, _report);
    }
  }

  @override
  void complete([FutureOr<T>? value]) {
    _completer.complete(value);
  }

  @override
  void completeError(Object error, [StackTrace? stackTrace]) {
    _completer.completeError(error, stackTrace);
  }

  @override
  Future<T> get future => _completer.future;

  @override
  bool get isCompleted => _completer.isCompleted;
}
