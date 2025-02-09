import 'package:args/command_runner.dart';
import 'package:fools/commands/commands.dart';

void main(List<String> arguments) {
  CommandRunner(
    "fools",
    "Fools start",
  )
    ..addCommand(StartCommand())
    ..run(arguments);
}
