/* Copyright (C) OnePub IP Pty Ltd - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'package:completer_ex/src/completer_ex.dart';
import 'package:test/test.dart';

void main() {
  test('completer ex ...', () async {
    /// create a completer that never completes
    final nodebug = CompleterEx<int>(
        expectedDuration: const Duration(seconds: 1),
        reportInterval: const Duration(seconds: 2));

    expect(
        nodebug.toString(),
        equals(
            "File: 'C:/Users/bsutt/git/completer_ex/test/src/completer_ex_test.dart' 13"));

    final withdebug = CompleterEx<int>(
        expectedDuration: const Duration(seconds: 1),
        reportInterval: const Duration(seconds: 2),
        debugName: 'test');

    expect(withdebug.toString(), equals('test'));
    await withdebug.future;
  });
}
