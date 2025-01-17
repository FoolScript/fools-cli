import 'package:args/command_runner.dart';
import 'package:fools/commands/dartCli.dart';

void main(List<String> arguments) {
  CommandRunner(
    "fools",
    "Fools start",
  )
    ..addCommand(DartCliCommand())
    ..run(arguments);
}