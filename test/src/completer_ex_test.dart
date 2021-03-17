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
