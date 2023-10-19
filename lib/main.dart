import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

void main() {
  runApp(const LauncherApp());
}

class LauncherApp extends StatelessWidget {
  const LauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(builder: (context, yaru, child) {
      return MaterialApp(
        theme: yaru.theme,
        darkTheme: yaru.darkTheme,
        home: const LancherPage(),
      );
    });
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
        actions: const [LauncherClock()],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.25,
                height: constraints.maxHeight * 0.45,
                child: const LauncherButton(
                  icon: YaruIcons.weather,
                  title: 'Weather',
                  executable: 'jpos-weather',
                ),
              ),
              SizedBox(
                width: constraints.maxWidth * 0.25,
                height: constraints.maxHeight * 0.45,
                child: const LauncherButton(
                  icon: YaruIcons.terminal,
                  title: 'Terminal',
                  executable: 'weston-terminal',
                ),
              ),
              SizedBox(
                width: constraints.maxWidth * 0.25,
                height: constraints.maxHeight * 0.45,
                child: const LauncherButton(
                  icon: YaruIcons.settings,
                  title: 'Settings',
                  executable: 'jpos-settings',
                ),
              ),
            ],
          ),
        );
      }),
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
    required this.icon,
    required this.title,
    required this.executable,
    this.arguments = const [],
  });

  final IconData icon;
  final String title;
  final String executable;
  final List<String> arguments;

  @override
  Widget build(BuildContext context) {
    return YaruBanner(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, size: 128),
          Text(title, style: const TextStyle(fontSize: 24)),
        ],
      ),
      onTap: () => launchApp(executable, arguments: arguments),
    );
  }
}

class LauncherClock extends StatefulWidget {
  const LauncherClock({super.key});

  @override
  State<LauncherClock> createState() => _LauncherClockState();
}

class _LauncherClockState extends State<LauncherClock> {
  late final Timer _timer;
  var _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1),
        (_) => setState(() => _now = DateTime.now()));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(DateFormat('yyy-MM-dd hh:mm:ss').format(_now)),
    );
  }
}
