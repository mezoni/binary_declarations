import "dart:io";
import "package:args/args.dart";
import "package:path/path.dart" as lib_path;

void main(List args) {
  var argParser = new ArgParser();
  argParser.addOption("changed");
  argParser.addFlag("clean");
  argParser.addFlag("deploy");
  argParser.addFlag("full");
  argParser.addFlag("machine");
  argParser.addOption("removed");
  var argResults = argParser.parse(args);
  if (argResults["full"] || argResults["deploy"]) {
    return;
  }

  var changed = argResults["changed"] as String;
  if (changed != null) {
    if ((changed.endsWith(".peg"))) {
      var dir = new Directory(lib_path.dirname(changed)).absolute.path;
      var file = lib_path.basename(changed);
      var arguments = <String>["global", "run", "peg", "general", "-c", file];
      var result = Process.runSync("pub", arguments, runInShell: true, workingDirectory: dir);
      if (result.exitCode != 0) {
        throw result.stderr + "\n" + result.stdout;
      }
    }
  }
}
