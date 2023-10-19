import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:xdg_directories/xdg_directories.dart' as xdg;
import 'package:yaml/yaml.dart';

Future<void> launchApp(String executable, {List<String>? arguments}) {
  return Process.run(executable, arguments ?? []);
}

Future<YamlMap> loadConfig(AssetBundle bundle, String fileName) async {
  final data = await readConfig(bundle, fileName);
  return loadYaml(data) as YamlMap;
}

Future<String> readConfig(AssetBundle bundle, String fileName) async {
  final xdgDirs = [...xdg.configDirs, Directory('/etc'), ...xdg.dataDirs];
  for (final xdgDir in xdgDirs) {
    final xdgFile = File(path.join(xdgDir.path, fileName));
    if (xdgFile.existsSync()) return xdgFile.readAsString();
  }
  return bundle.loadString('assets/$fileName');
}
