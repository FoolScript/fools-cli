// lib/commands/config_command.dart
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:fools/utils/tasks_utils.dart';
import 'package:path/path.dart' as path;

class ConfigCommand extends Command {
  @override
  final name = 'config';

  @override
  final description = 'Configure VS Code settings for a specific configuration';

  ConfigCommand() {
    argParser.addOption(
      'type',
      abbr: 't',
      help:
          'Type of configuration to install (e.g., readme, typescript, dart-cli)',
      mandatory: true,
    );
  }

  Future<List<String>> _getAvailableConfigs() async {
    final scriptUri = Platform.script;
    final packageRoot = path.dirname(path.dirname(scriptUri.toFilePath()));
    final tasksDir = Directory(path.join(packageRoot, 'lib', 'tasks'));

    if (!await tasksDir.exists()) {
      return [];
    }

    final configs = await tasksDir
        .list()
        .where((entity) => entity is Directory)
        .map((entity) => path.basename(entity.path))
        .toList();

    return configs;
  }

  @override
  Future<void> run() async {
    try {
      if (argResults?['list'] == true) {
        final configs = await _getAvailableConfigs();
        print('\nAvailable configurations:');
        for (final config in configs) {
          print('  - $config');
        }
        return;
      }

      final configType = argResults?['type'];
      if (configType == null) {
        print('Error: Please specify a configuration type using --type or -t');
        return;
      }

      final configs = await _getAvailableConfigs();
      if (!configs.contains(configType)) {
        print('Error: Configuration "$configType" not found.');
        print('\nAvailable configurations:');
        for (final config in configs) {
          print('  - $config');
        }
        return;
      }

      final scriptUri = Platform.script;
      final packageRoot = path.dirname(path.dirname(scriptUri.toFilePath()));
      final configDir = path.join(packageRoot, 'lib', 'tasks', configType);
      bool configurationApplied = false;

      // Handle tasks if tasks.json exists
      final tasksPath = path.join(configDir, 'tasks.json');
      if (File(tasksPath).existsSync()) {
        final tasksSuccess = await TaskUtils.parseTasks(tasksPath);
        if (tasksSuccess) {
          print('Successfully updated VSCode tasks for $configType');
          configurationApplied = true;
        } else {
          print('Failed to update VSCode tasks for $configType');
        }
      }

      // Handle snippets if snippets.json exists
      final snippetsPath = path.join(configDir, 'snippets.code-snippets');
      if (File(snippetsPath).existsSync()) {
        final snippetsSuccess = await TaskUtils.parseSnippets(snippetsPath);
        if (snippetsSuccess) {
          print('Successfully updated VSCode snippets for $configType');
          configurationApplied = true;
        } else {
          print('Failed to update VSCode snippets for $configType');
        }
      }

      if (!configurationApplied) {
        print('No configuration files found for $configType');
        return;
      }
    } catch (e) {
      print('Error running configuration command: $e');
      exit(1);
    }
  }
}
