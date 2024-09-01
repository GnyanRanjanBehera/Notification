import 'package:firebasedemo/firebase_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebasedemo/splasher.dart';

/// This entry point should be used for production only
late final ProviderContainer baseProviderContainer;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupFirebase();
  runApp(
    const ProviderScope(child: Splasher()),
  );
}
