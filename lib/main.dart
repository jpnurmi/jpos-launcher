import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaml/yaml.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'config.dart';

void main() {
  final config = loadConfig('jpos.yaml');
  runApp(LauncherApp(config: config['launcher'] as YamlList));
}

class LauncherApp extends StatelessWidget {
  const LauncherApp({super.key, required this.config});

  final YamlList config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: yaruLight,
      darkTheme: yaruDark,
      home: LancherPage(config: config),
    );
  }
}

class LancherPage extends StatefulWidget {
  const LancherPage({super.key, required this.config});

  final YamlList config;

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
            children: widget.config.cast<YamlMap>().map(
              (entry) {
                return SizedBox(
                  width: constraints.maxWidth / (widget.config.length + 1),
                  height: constraints.maxHeight * 0.45,
                  child: LauncherButton(
                    icon: YaruIcons.all[entry['icon'] as String]!,
                    title: entry['title'] as String,
                    executable: entry['executable'] as String,
                  ),
                );
              },
            ).toList(),
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
