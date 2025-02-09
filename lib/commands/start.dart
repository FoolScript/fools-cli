// lib/commands/start_command.dart
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;

class StartCommand extends Command {
  @override
  final name = 'start';

  @override
  final description =
      'Populates the .github/prompts directory with prompt files';

  @override
  Future<void> run() async {
    try {
      // Locate the package root based on the script location.
      final scriptUri = Platform.script;
      final packageRoot = path.dirname(path.dirname(scriptUri.toFilePath()));

      // Define the source directory (where your prompt files live).
      final sourceDir = Directory(path.join(packageRoot, 'lib', 'prompts'));
      if (!await sourceDir.exists()) {
        print('Source prompts directory does not exist: ${sourceDir.path}');
        return;
      }

      // Define the target directory: .github/prompts inside the current project.
      final targetDir =
          Directory(path.join(Directory.current.path, '.github', 'prompts'));
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
        print('Created target directory: ${targetDir.path}');
      }

      // Copy each file from the source directory to the target directory.
      await for (final entity in sourceDir.list(recursive: false)) {
        if (entity is File) {
          final fileName = path.basename(entity.path);
          final targetPath = path.join(targetDir.path, fileName);
          await entity.copy(targetPath);
          print('Copied $fileName to $targetPath');
        }
      }

      print('All prompt files have been copied successfully.');
    } catch (e) {
      print('Error while copying prompt files: $e');
      exit(1);
    }
  }
}
