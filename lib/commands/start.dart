// lib/commands/start_command.dart
import 'dart:io';
import 'dart:isolate';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;

class StartCommand extends Command {
  @override
  final name = 'start';

  @override
  final description =
      'Populates the .github/prompts directory with prompt files';

  // Explicit list of prompt file names to copy.
  final List<String> promptFiles = [
    'fools-boolean.prompt.md',
    'fools-class.prompt.md',
    'fools-cli.prompt.md',
    'fools-enum.prompt.md',
    'fools-files.prompt.md',
    'fools-functions.prompt.md',
    'fools-logic.prompt.md',
    'fools-print.prompt.md',
    'fools-start.prompt.md',
    'fools-types.prompt.md',
    'fools-variables.prompt.md',
  ];

  @override
  Future<void> run() async {
    try {
      // Define the target directory (.github/prompts) in the current project.
      final targetDir =
          Directory(path.join(Directory.current.path, '.github', 'prompts'));
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
        print('Created target directory: ${targetDir.path}');
      }

      // Loop through each prompt file in the list.
      for (final fileName in promptFiles) {
        // Build the package URI for the prompt file.
        final packageUri = Uri.parse('package:fools/prompts/$fileName');
        // Resolve the package URI to a file URI.
        final resolvedUri = await Isolate.resolvePackageUri(packageUri);
        if (resolvedUri == null) {
          print('Could not resolve URI for $fileName');
          continue;
        }

        final sourceFile = File.fromUri(resolvedUri);
        if (!await sourceFile.exists()) {
          print('Prompt file does not exist: ${sourceFile.path}');
          continue;
        }

        // Determine the destination path.
        final targetPath = path.join(targetDir.path, fileName);
        await sourceFile.copy(targetPath);
        print('Copied $fileName to $targetPath');
      }

      print('All prompt files have been copied successfully.');
    } catch (e) {
      print('Error while copying prompt files: $e');
      exit(1);
    }
  }
}
