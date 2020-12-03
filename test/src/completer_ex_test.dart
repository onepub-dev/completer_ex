@Timeout(Duration(minutes: 2))
import 'dart:io';

import 'package:completer_ex/src/completer_ex.dart';
import 'package:test/test.dart';

void main() {
  test('completer ex ...', () async {
    /// create a completer that never completes
    CompleterEx<int>();

    sleep(Duration(seconds: 12));
  });
}
