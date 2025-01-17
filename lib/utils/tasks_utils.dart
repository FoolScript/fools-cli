import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;

class TaskUtils {
  /// Parses and merges tasks from a source file into the .vscode/tasks.json file.
  /// If the tasks.json file doesn't exist, it creates a new one.
  /// Returns true if successful, false if there was an error.
  static Future<bool> parseTasks(String sourceTasksPath) async {
    try {
      // Read the source tasks
      final sourceTasks = await _readJsonFile(sourceTasksPath);
      if (sourceTasks == null) return false;

      // Ensure we have a list of tasks from the source
      final List<Map<String, dynamic>> newTasks = 
        (sourceTasks['tasks'] as List).cast<Map<String, dynamic>>();

      // Get or create .vscode directory
      final vscodeDir = Directory('.vscode');
      if (!await vscodeDir.exists()) {
        await vscodeDir.create();
      }

      // Path to tasks.json
      final tasksFilePath = path.join('.vscode', 'tasks.json');
      final tasksFile = File(tasksFilePath);

      Map<String, dynamic> existingContent;
      List<Map<String, dynamic>> existingTasks = [];

      // If tasks.json exists, read and parse it
      if (await tasksFile.exists()) {
        final content = await tasksFile.readAsString();
        existingContent = json.decode(content) as Map<String, dynamic>;
        existingTasks = (existingContent['tasks'] as List? ?? [])
            .cast<Map<String, dynamic>>();
      } else {
        existingContent = {
          'version': '2.0.0',
          'tasks': [],
        };
      }

      // Merge tasks, avoiding duplicates based on label
      final mergedTasks = _mergeTasks(existingTasks, newTasks);

      // Update the tasks in the existing content
      existingContent['tasks'] = mergedTasks;

      // Write the updated content back to tasks.json
      await tasksFile.writeAsString(
        JsonEncoder.withIndent('  ').convert(existingContent),
      );

      return true;
    } catch (e) {
      print('Error parsing tasks: $e');
      return false;
    }
  }

  /// Merges two lists of tasks, avoiding duplicates based on the task label
  static List<Map<String, dynamic>> _mergeTasks(
    List<Map<String, dynamic>> existingTasks,
    List<Map<String, dynamic>> newTasks,
  ) {
    final mergedTasks = List<Map<String, dynamic>>.from(existingTasks);
    final existingLabels = existingTasks.map((t) => t['label']).toSet();

    for (final task in newTasks) {
      if (!existingLabels.contains(task['label'])) {
        mergedTasks.add(task);
      }
    }

    return mergedTasks;
  }

  /// Parses and merges snippets from a source file into the .vscode/snippets.code-snippets file.
  /// If the snippets file doesn't exist, it creates a new one.
  /// Returns true if successful, false if there was an error.
  static Future<bool> parseSnippets(String sourceSnippetsPath) async {
    try {
      // Read the source snippets
      final sourceSnippets = await _readJsonFile(sourceSnippetsPath);
      if (sourceSnippets == null) return false;

      // Get or create .vscode directory
      final vscodeDir = Directory('.vscode');
      if (!await vscodeDir.exists()) {
        await vscodeDir.create();
      }

      // Path to snippets file
      final snippetsFilePath = path.join('.vscode', 'snippets.code-snippets');
      final snippetsFile = File(snippetsFilePath);

      Map<String, dynamic> existingSnippets = {};

      // If snippets file exists, read and parse it
      if (await snippetsFile.exists()) {
        final content = await snippetsFile.readAsString();
        existingSnippets = json.decode(content) as Map<String, dynamic>;
      }

      // Merge snippets, preserving existing ones unless overwritten
      sourceSnippets.forEach((key, value) {
        if (!existingSnippets.containsKey(key)) {
          existingSnippets[key] = value;
        }
      });

      // Write the updated content back to snippets file
      await snippetsFile.writeAsString(
        JsonEncoder.withIndent('  ').convert(existingSnippets),
      );

      return true;
    } catch (e) {
      print('Error parsing snippets: $e');
      return false;
    }
  }
 
  /// Reads and parses a JSON file
  static Future<Map<String, dynamic>?> _readJsonFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        print('Source file not found: $filePath');
        return null;
      }

      final content = await file.readAsString();
      return json.decode(content) as Map<String, dynamic>;
    } catch (e) {
      print('Error reading JSON file: $e');
      return null;
    }
  }
}