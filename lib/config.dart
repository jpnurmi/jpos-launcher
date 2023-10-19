import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:xdg_directories/xdg_directories.dart' as xdg;
import 'package:yaml/yaml.dart';

YamlMap loadConfig(String fileName) {
  final file = configFile(fileName);
  return loadYaml(file.readAsStringSync()) as YamlMap;
}

File configFile(String fileName) {
  final xdgDirs = [...xdg.configDirs, Directory('/etc'), ...xdg.dataDirs];
  for (final xdgDir in xdgDirs) {
    final xdgFile = File(path.join(xdgDir.path, fileName));
    if (xdgFile.existsSync()) return xdgFile;
  }
  return File(path.join(
    path.dirname(Platform.resolvedExecutable),
    'data',
    'flutter_assets',
    'assets',
    fileName,
  ));
}
