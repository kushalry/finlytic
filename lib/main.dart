import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';

void main() {
  // ProviderScope is the root of Riverpod — all providers live under this.
  runApp(const ProviderScope(child: FinlyticApp()));
}