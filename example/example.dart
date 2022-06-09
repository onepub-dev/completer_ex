/* Copyright (C) OnePub IP Pty Ltd - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */

import 'dart:async';

import 'package:completer_ex/completer_ex.dart';

void main() {
  /// If you have a normal Completer:
  Completer<int>();

  /// just replace it with a CompleterEx
  CompleterEx<int>();
}
