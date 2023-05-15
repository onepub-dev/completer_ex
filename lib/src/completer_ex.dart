// ignore_for_file: avoid_setters_without_getters

/* Copyright (C) OnePub IP Pty Ltd - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:async';

import 'package:simple_logger/simple_logger.dart';
import 'package:stacktrace_impl/stacktrace_impl.dart';

class CompleterEx<T> implements Completer<T> {
  /// Creates a Completer which logs if the completer hasn't
  /// completed by [expectedDuration].
  ///
  /// [expectedDuration] specifies the duration before we first report
  /// that the completer hasn't completed.
  /// If null is passed then the value set by [setDefaultExepectedDuration]
  /// is used which defaults to 10 seconds.
  /// [reportInterval] specifies the duration between subsequent reporting
  /// events.
  /// If null is passed then the value set by [setDefaultReportInterval] is used
  /// which defaults to 10 seconds.
  CompleterEx({Duration? expectedDuration, Duration? reportInterval})
      : stackTrace = StackTraceImpl(skipFrames: 1),
        _createdAt = DateTime.now() {
    _expectedDuration = expectedDuration ?? _defaultExpectedDuration;
    _reportInterval = reportInterval ?? _defaultReportInterval;

    /// If the completer has not complete after [report_after] seconds then
    /// dump its stack trace.
    Future<void>.delayed(_expectedDuration, _report);
  }
  final Completer<T> _completer = Completer();

  late final logger = SimpleLogger();

  final StackTraceImpl stackTrace;
  final DateTime _createdAt;

  static var _defaultExpectedDuration = const Duration(seconds: 10);
  static var _defaultReportInterval = const Duration(seconds: 10);

  late final Duration _expectedDuration;
  late final Duration _reportInterval;

  /// Allows you globally to set the amount of time to wait before reporting
  /// that the completer hasn't completed. Any CompleterEx's created after
  /// this call will use this as their default.
  // ignore: comment_references
  /// Use the constructor's named argument [expectedDuration] argument to
  /// set this value on a per [CompleterEx] basis.
  set setDefaultExepectedDuration(Duration duration) =>
      _defaultExpectedDuration = duration;

  /// Allows you globally to set the amount of time to wait before reporting
  /// that the completer hasn't completed. Any CompleterEx's created after
  /// this call will use this as their default.
  // ignore: comment_references
  /// Use the constructors [reportInterval] argument to set this value
  /// on a per [CompleterEx] basis.
  ///
  set setDefaultReportInterval(Duration duration) =>
      _defaultReportInterval = duration;

  void _report() {
    if (!_completer.isCompleted) {
      /// We delay creating the logger until we must have it.
      /// This means we have minimal impact on the 'good' path.

      logger
        ..setLevel(Level.FINE)
        ..fine('Completer failed to complete after '
            '${DateTime.now().difference(_createdAt)} seconds, '
            'created At: $_createdAt')
        ..fine('CreatedBy: ${stackTrace.formatStackTrace()}');

      /// reprint if it still isn't complete after another
      Future<void>.delayed(_reportInterval, _report);
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
