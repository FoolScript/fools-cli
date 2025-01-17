// lib/commands/config_command.dart
import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:fools/utils/tasks_utils.dart';
import 'package:path/path.dart' as path;

class ConfigCommand extends Command {
  @override
  final name = 'config';

  @override
  final description = 'Configure VSCode settings for a specific configuration';

  ConfigCommand() {
    argParser.addOption(
      'type',
      abbr: 't',
      help:
          'Type of configuration to install (e.g., readme, typescript, dart-cli)',
      mandatory: true,
    );

    // Optional: Add a list flag to show available configurations
    argParser.addFlag(
      'list',
      abbr: 'l',
      help: 'List available configurations',
      negatable: false,
    );
  }

  /// Gets a list of available configurations by scanning the tasks directory
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
      // Handle the list flag
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

      // Validate that the configuration exists
      final configs = await _getAvailableConfigs();
      if (!configs.contains(configType)) {
        print('Error: Configuration "$configType" not found.');
        print('\nAvailable configurations:');
        for (final config in configs) {
          print('  - $config');
        }
        return;
      }

      // Get the package's lib directory path
      final scriptUri = Platform.script;
      final packageRoot = path.dirname(path.dirname(scriptUri.toFilePath()));
      final configDir = path.join(packageRoot, 'lib', 'tasks', configType);

      // Handle tasks
      final tasksPath = path.join(configDir, 'tasks.json');
      final tasksSuccess = await TaskUtils.parseTasks(tasksPath);

      if (tasksSuccess) {
        print('Successfully updated VSCode tasks for $configType');
      } else {
        print('Failed to update VSCode tasks for $configType');
      }

      // Handle snippets if they exist
      final snippetsPath = path.join(configDir, 'snippets.json');
      if (File(snippetsPath).existsSync()) {
        final snippetsSuccess = await TaskUtils.parseSnippets(snippetsPath);
        if (snippetsSuccess) {
          print('Successfully updated VSCode snippets for $configType');
        } else {
          print('Failed to update VSCode snippets for $configType');
        }
      }
    } catch (e) {
      print('Error running configuration command: $e');
      exit(1);
    }
  }
}
