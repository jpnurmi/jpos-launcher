import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const LauncherApp());
}

class LauncherApp extends StatelessWidget {
  const LauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LancherPage(),
    );
  }
}

class LancherPage extends StatefulWidget {
  const LancherPage({super.key});

  @override
  State<LancherPage> createState() => _LancherPageState();
}

class _LancherPageState extends State<LancherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('jpOS'),
      ),
      body: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            LauncherButton(
              title: 'Weather',
              executable: 'jpos-weather',
            ),
            LauncherButton(
              title: 'Terminal',
              executable: 'weston-terminal',
            ),
            LauncherButton(
              title: 'Settings',
              executable: 'jpos-settings',
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> launchApp(
  String executable, {
  List<String> arguments = const [],
}) {
  return Process.run(executable, arguments);
}

class LauncherButton extends StatelessWidget {
  const LauncherButton({
    super.key,
    required this.title,
    required this.executable,
    this.arguments = const [],
  });

  final String executable;
  final String title;
  final List<String> arguments;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(192, 192),
        textStyle: const TextStyle(fontSize: 24),
      ),
      onPressed: () => launchApp(executable, arguments: arguments),
      child: Text(title),
    );
  }
}
