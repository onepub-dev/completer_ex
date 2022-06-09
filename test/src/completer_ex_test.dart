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
    await CompleterEx<int>(
            expectedDuration: Duration(seconds: 1),
            reportInterval: Duration(seconds: 2))
        .future;
  });
}
