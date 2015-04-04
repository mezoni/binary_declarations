part of binary_declarations;

class Declarations extends Object with IterableMixin<Declaration> {
  List<Declaration> _declarations;

  Declarations(String filename, Map<String, String> files,
      {Map<String, MacroDefinition> definitions, Map<String, dynamic> environment}) {
    if (filename == null) {
      throw new ArgumentError.notNull("filename");
    }

    if (files == null) {
      throw new ArgumentError.notNull("files");
    }

    if (environment == null) {
      environment = <String, String>{};
    }

    if (definitions == null) {
      definitions = {};
    }

    if (!files.containsKey(filename)) {
      throw new StateError("File not found: $filename");
    }

    var source = files[filename];
    if (source == null) {
      throw new StateError("File is corrupted: $filename");
    }

    _declarations = <Declaration>[];
    var processor = new MacroProcessor();
    var blocks = processor.process(filename, files, environment: environment);
    var numberOfBlocks = blocks.length;
    if (numberOfBlocks == 0) {
      return;
    }

    var count = blocks.length;
    for (var i = 0; i < count; i++) {
      var block = blocks[i];
      var filename = block.filename;
      var buffer = new StringBuffer(block.text);
      while (i < count - 1) {
        var next = blocks[i + 1];
        if (next.filename != filename) {
          break;
        }

        buffer.write(next.text);
        i++;
      }

      var text = buffer.toString();
      var parser = new CParser(text);
      List<Declaration> result = parser.parse_Declarations();
      if (!parser.success) {
        var messages = [];
        for (var error in parser.errors()) {
          messages.add(new ParserErrorMessage(error.message, error.start, error.position));
        }

        var strings = ParserErrorFormatter.format(text, messages);
        print(strings.join("\n"));
        throw new FormatException();
      }

      for (var declaration in result) {
        declaration.filename = filename;
      }

      _declarations.addAll(result);
    }
  }

  Iterator<Declaration> get iterator => _declarations.iterator;
}
