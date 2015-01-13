import "package:binary_declarations/internal/preprocessor/parser.dart";
import "package:unittest/unittest.dart";

void main() {
  var parser = new Parser(text);

  var a;
  var b;
  var c;

  if (a) {
  } else if (b) {
  } else if (c) {
  } else {
    //
  }
}

var text = '''
#if xxxxx
#else
#endif
''';
