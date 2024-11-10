import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MainApp(),
    ),
  );
}

class MainApp extends HookWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Hello World! 16'),
      ),
    );
  }
}
