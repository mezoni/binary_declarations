import "package:binary_declarations/internal/preprocessor/preprocessor_parser.dart";
import "package:text/text.dart";

class Parser {
  Parser(String text) {
    var parser = new PreprocessorParser(text);
    var result = parser.parse_Conditional();
    if (!parser.success) {
      var text = new Text(parser.text);
      for (var error in parser.errors()) {
        var position = error.position;
        var location = "EOF";
        if (position < text.length) {
          location = text.locationAt(error.position);
        }

        var message = "Parser error at $location. ${error.message}";
        print(message);
      }

      throw new FormatException();
    }
  }
}
