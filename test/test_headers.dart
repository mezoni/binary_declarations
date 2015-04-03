import "package:binary_declarations/binary_declarations.dart";
import "package:unittest/unittest.dart";

void main() {
  var files = {"header1.h": _header1, "header2.h": _header2};
  var declarations = new Declarations("header1.h", files);
  for (var declaration in declarations) {
    if (declaration is FunctionDeclaration) {
      var name = declaration.declarator.identifier.name;
      var filename = declaration.filename;
      var index = filename.indexOf(".");
      if (index != null) {
        var prefix = filename.substring(0, index);
        expect(name.startsWith(prefix), true, reason: "The '$name' not in '$filename'");
      }
    }
  }
}

const String _header1 = '''
#if !defined(HEADER1_H)
#define HEADER1_H

#include <header2.h>

void header1_fn1();

#endif
''';

const String _header2 = '''
#if !defined(HEADER2_H)
#define HEADER2_H

void header2_fn1();

#endif
''';