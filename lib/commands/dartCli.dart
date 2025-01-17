// lib/commands/dart-cli.dart
import 'dart:io';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:fools/utils/tasks_utils.dart';
import 'package:path/path.dart' as path;

class DartCliCommand extends Command {
  @override
  final name = 'dart-cli';

  @override
  final description = 'Configure VSCode for Dart CLI development';

  @override
  Future<void> run() async {
    try {
      // Get the package's lib directory path
      final scriptUri = Platform.script;
      final packageRoot = path.dirname(path.dirname(scriptUri.toFilePath()));
      final tasksPath =
          path.join(packageRoot, 'lib', 'tasks', 'dart_cli', 'tasks.json');

      // Parse and merge tasks
      final success = await TaskUtils.parseTasks(tasksPath);

      if (success) {
        print('Successfully updated VSCode tasks for Dart CLI');
      } else {
        print('Failed to update VSCode tasks');
        exit(1);
      }
    } catch (e) {
      print('Error running Dart CLI command: $e');
      exit(1);
    }
  }
}
