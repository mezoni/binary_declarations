import "package:binary_declarations/binary_declarations.dart";
import "package:unittest/unittest.dart";

void main() {
  group("Declarations.", () {
    group("Functions.", () {
      test("Function declarations.", () {
        var list = <String>[];
        list.add("int foo();");
        list.add("unsigned foo();");
        list.add("void foo();");
        list.add("short foo(int);");
        list.add("struct Foo foo(int, int*);");
        list.add("void** foo(int, int*);");
        list.add("enum Color* foo(int, int*, int[]);");
        list.add("unsigned long long int foo(int, int*, int[], struct s);");
        list.add("char foo(int, int*, int[], enum e);");
        list.add("int foo(int);");
        list.add("signed int foo(int);");
        list.add("signed int* foo(int);");
        list.add("struct S foo(int);");
        list.add("enum E foo(int);");
        list.add("void foo(int, ...);");
        list.add("int foo(int i);");
        list.add("short int* foo(int i, int* ip);");
        var text = list.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is FunctionDeclaration, true, reason: "Not a $FunctionDeclaration");
        }

        _checkPresentation(text, declarations);
      });
    });

    group("Structures.", () {
      var kinds = <String>["struct", "union"];
      var baseList = <String>[];
      for (var kind in kinds) {
        baseList.add("$kind { }");
        baseList.add("$kind s { }");
        baseList.add("$kind s { int i; }");
        baseList.add("$kind s { int i; int* ip; }");
        baseList.add("$kind s { int i; int* ip; int ia[]; }");
        baseList.add("$kind s { int i; int* ip; int ia[10]; }");
        baseList.add("$kind s { int i; int* ip; int ia[10]; }");
        baseList.add("$kind s { int i; $kind { } s; }");
        baseList.add("$kind s { int i; $kind s { } s; }");
        baseList.add("$kind s { int i; $kind s { int i; } s; }");
        baseList.add("$kind s { int i; int a : 1; }");
        baseList.add("$kind s { int i; int : 0; }");
      }

      test("Structure declarations.", () {
        var lines = baseList.toList();
        lines = _addBeforeAndAfter(lines, "", ";");
        var text = lines.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is StructureDeclaration, true, reason: "Not a $StructureDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Structure variable declarations.", () {
        var lines = baseList.toList();
        lines = _addBeforeAndAfter(lines, "", " s1;");
        var text = lines.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is VariableDeclaration, true, reason: "Not a $VariableDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Structure typedef declarations.", () {
        var lines = baseList.toList();
        lines = _addBeforeAndAfter(lines, "typedef ", " s1;");
        var text = lines.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is TypedefDeclaration, true, reason: "Not a $TypedefDeclaration");
        }

        _checkPresentation(text, declarations);
      });
    });

    group("Enums.", () {
      var baseList = <String>[];
      baseList.add("enum { A }");
      baseList.add("enum e { A }");
      baseList.add("enum e { A }");
      baseList.add("enum e { A, B }");
      baseList.add("enum e { A = 0 }");
      baseList.add("enum e { A = 0, B }");
      baseList.add("enum e { A = 0, B, C = 0 }");
      baseList.add("enum e { A = 0, B, C = -1 }");
      test("Enum declarations.", () {
        var lines = baseList.toList();
        lines = _addBeforeAndAfter(lines, "", ";");
        var text = lines.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is EnumDeclaration, true, reason: "Not a $EnumDeclaration");
        }

        _checkPresentation(text, declarations);

        try {
          new BinaryDeclarations("enum { A, };");
        } catch (e) {
          expect(true, false, reason: "Extra comma 'enum { A, }'");
        }
      });

      test("Enum variable declarations.", () {
        var lines = baseList.toList();
        lines = _addBeforeAndAfter(lines, "", " s1;");
        var text = lines.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is VariableDeclaration, true, reason: "Not a $VariableDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Enum typedef declarations.", () {
        var lines = baseList.toList();
        lines = _addBeforeAndAfter(lines, "typedef ", " s1;");
        var text = lines.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is TypedefDeclaration, true, reason: "Not a $TypedefDeclaration");
        }

        _checkPresentation(text, declarations);
      });
    });

    group("Integers.", () {
      var types = _getFullListOfIntegerTypes();
      test("Integer variable declarations.", () {
        var list = <String>[];
        for (var type in types) {
          var ident = type.replaceAll(" ", "");
          list.add("$type ${ident}0;");
        }

        var text = list.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is VariableDeclaration, true, reason: "Not a $VariableDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Integer array variable declarations.", () {
        var list = <String>[];
        for (var type in types) {
          var ident = type.replaceAll(" ", "");
          list.add("$type ${ident}0[];");
        }

        var text = list.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is VariableDeclaration, true, reason: "Not a $VariableDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Integer pointer variable declarations.", () {
        var list = <String>[];
        for (var type in types) {
          var ident = type.replaceAll(" ", "");
          list.add("$type* ${ident}0;");
        }

        var text = list.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is VariableDeclaration, true, reason: "Not a $VariableDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Integer typedef declarations.", () {
        var list = <String>[];
        for (var type in types) {
          var ident = type.replaceAll(" ", "");
          list.add("typedef $type ${ident}0;");
        }

        var text = list.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is TypedefDeclaration, true, reason: "Not a $TypedefDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Integer array typedef declarations.", () {
        var list = <String>[];
        for (var type in types) {
          var ident = type.replaceAll(" ", "");
          list.add("typedef $type ${ident}0[];");
        }

        var text = list.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is TypedefDeclaration, true, reason: "Not a $TypedefDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Integer pointer typedef declarations.", () {
        var list = <String>[];
        for (var type in types) {
          var ident = type.replaceAll(" ", "");
          list.add("typedef $type* ${ident}0;");
        }

        var text = list.join("\n");
        var declarations = new BinaryDeclarations(text);
        for (var declaration in declarations) {
          expect(declaration is TypedefDeclaration, true, reason: "Not a $TypedefDeclaration");
        }

        _checkPresentation(text, declarations);
      });
    });
  });

  group("Misc.", () {
    test("Octal numbers.", () {
      var list = <String>[];
      list.add("int i[011];");
      var text = list.join("\n");
      var declarations = new BinaryDeclarations(text);
      _checkPresentation("int i[9];", declarations);
    });

    test("Attributes.", () {
      var list = <String>[];
      list.add("typedef int __attribute__((aligned(8))) __attribute__((packed)) INT;");
      list.add("typedef int INT __attribute__((aligned(8), packed));");
      list.add("typedef int __attribute__((foo(baz, 2))) INT;");
      list.add("float __attribute__((type)) f __attribute__((var));");
      list.add("enum __attribute__((type)) ee e __attribute__((var));");
      list.add("struct __attribute__((type)) ss s __attribute__((var));");
      list.add("int __attribute__((type)) i __attribute__((var));");
      list.add("int __attribute__((ret)) foo(int __attribute__((type)) x __attribute__((var))) __attribute__((func));");
      list.add("struct __attribute__((type1)) { int __attribute__((type2)) x __attribute__((var)); } __attribute__((type3)) s __attribute__((var));");
      list.add("struct __attribute__((type1)) ss { int __attribute__((type2)) x __attribute__((var)); } __attribute__((type3)) s __attribute__((var));");
      list.add("enum __attribute__((type1)) { E } __attribute__((type2)) e __attribute__((var));");
      list.add("enum __attribute__((type1)) ee { E } __attribute__((type2)) e __attribute__((var));");
      list.add("TYPE __attribute__((type)) i __attribute__((var));");
      var text = list.join("\n");
      var declarations = new BinaryDeclarations(text);
      _checkPresentation(text, declarations);
    });

    test("Semicolons.", () {
      var declarations = new BinaryDeclarations(";;;");
      _checkPresentation(";;", declarations);
    });

    test("Directives.", () {
      var list = <String>[];
      list.add("#define FOO");
      list.add("#if defined(FOO)");
      list.add("typedef int INT;");
      list.add("#else");
      list.add("typedef int LONG;");
      list.add("#endif");
      var text = list.join("\n");
      var declarations = new BinaryDeclarations(text);
      _checkPresentation("typedef int INT;", declarations);
    });
  });
}

List<String> _addBeforeAndAfter(List<String> lines, String before, String after) {
  var length = lines.length;
  var result = new List<String>(length);
  for (var i = 0; i < length; i++) {
    result[i] = "$before${lines[i]}$after";
  }

  return result;
}

void _checkPresentation(String text, BinaryDeclarations declarations) {
  var lines = text.split("\n");
  var length = lines.length;
  var list = declarations.toList();
  expect(length, list.length, reason: "Text lines count");
  for (var i = 0; i < length; i++) {
    var line = lines[i];
    var actual = list[i].toString() + ";";
    expect(actual, line, reason: "Wrong presentation at line $i");
  }
}

List<String> _getFullListOfIntegerTypes() {
  var result = <String>[];
  result.add("char");
  result.add("int");
  var types = <String>["long", "long long", "short"];
  for (var type in types) {
    result.add(type);
    result.add("$type int");
  }

  return _getSignedAndUnsignedTypes(result);
}

List<String> _getSignedAndUnsignedTypes(List<String> types) {
  var result = <String>[];
  for (var type in types) {
    result.add(type);
    result.add("signed $type");
    result.add("unsigned $type");
  }

  return result;
}
