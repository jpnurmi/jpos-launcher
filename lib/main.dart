import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import 'package:yaru/yaru.dart';
import 'package:yaru_icons/yaru_icons.dart';

import 'io.dart';
import 'widgets.dart';

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
                    onPressed: () => launchApp(
                      entry['executable'] as String,
                      arguments: entry['arguments'] as List<String>?,
                    ),
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
