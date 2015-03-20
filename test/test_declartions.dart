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
        list.add("void foo(void);");
        list.add("void foo(void *, void *);");
        list.add("short foo(int);");
        list.add("struct Foo foo(int, int *);");
        list.add("struct { int i : 8; } foo(enum e { A } e, int *);");
        list.add("void **foo(int, int *);");
        list.add("enum Color *foo(int, int *, int []);");
        list.add("unsigned long long int foo(int, int *, int [], struct s);");
        list.add("char foo(int, int *, int [], enum e);");
        list.add("int foo(int);");
        list.add("signed int foo(int);");
        list.add("signed int *foo(int);");
        list.add("struct S foo(int);");
        list.add("enum E foo(int);");
        list.add("void foo(int, ...);");
        list.add("int foo(int i);");
        list.add("short int *foo(int i, int *ip);");
        var text = list.join("\n");
        var declarations = new Declarations(text);
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
        baseList.add("$kind s");
        baseList.add("$kind s { struct ss { int i; }; }");
        baseList.add("$kind s { int i; }");
        baseList.add("$kind s { int i; int *ip; }");
        baseList.add("$kind s { int i; int *ip; int ia[]; }");
        baseList.add("$kind s { int i; int *ip; int ia[10]; }");
        baseList.add("$kind s { int i; int *ip; int ia[10]; }");
        baseList.add("$kind s { int i; $kind s; }");
        baseList.add("$kind s { int i; $kind s s; }");
        baseList.add("$kind s { int i; $kind s { int i; } s; }");
        baseList.add("$kind s { int i; DWORD a : 1; }");
        baseList.add("$kind s { int i; int : 0; }");
        baseList.add("$kind s { int foo(int); }");
        baseList.add("$kind s { int *foo(char); }");
        baseList.add("$kind s { int (*foo)(long); }");
      }

      test("Structure declarations.", () {
        var lines = baseList.toList();
        lines = _addBeforeAndAfter(lines, "", ";");
        var text = lines.join("\n");
        var declarations = new Declarations(text);
        for (var declaration in declarations) {
          expect(declaration is StructureDeclaration, true, reason: "Not a $StructureDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Structure variable declarations.", () {
        var lines = baseList.toList();
        lines = _addBeforeAndAfter(lines, "", " s1;");
        var text = lines.join("\n");
        var declarations = new Declarations(text);
        for (var declaration in declarations) {
          expect(declaration is VariableDeclaration, true, reason: "Not a $VariableDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Structure typedef declarations.", () {
        var lines = baseList.toList();
        lines = _addBeforeAndAfter(lines, "typedef ", " s1;");
        var text = lines.join("\n");
        var declarations = new Declarations(text);
        for (var declaration in declarations) {
          expect(declaration is TypedefDeclaration, true, reason: "Not a $TypedefDeclaration");
        }

        _checkPresentation(text, declarations);
      });
    });

    group("Enums.", () {
      var baseList = <String>[];
      baseList.add("enum e");
      baseList.add("enum { A }");
      baseList.add("enum e { A }");
      baseList.add("enum e { A }");
      baseList.add("enum e { A, B }");
      baseList.add("enum e { A = 0 }");
      baseList.add("enum e { A = 0, B }");
      baseList.add("enum e { A = 0, B, C = 0 }");
      baseList.add("enum e { A = 0, B, C = -1 }");
      baseList.add("enum e { A = 0, B = A }");
      test("Enum declarations.", () {
        var lines = baseList.toList();
        lines = _addBeforeAndAfter(lines, "", ";");
        var text = lines.join("\n");
        var declarations = new Declarations(text);
        for (var declaration in declarations) {
          expect(declaration is EnumDeclaration, true, reason: "Not a $EnumDeclaration");
        }

        _checkPresentation(text, declarations);

        try {
          new Declarations("enum { A, };");
        } catch (e) {
          expect(true, false, reason: "Extra comma 'enum { A, }'");
        }
      });

      test("Enum variable declarations.", () {
        var lines = baseList.toList();
        lines = _addBeforeAndAfter(lines, "", " s1;");
        var text = lines.join("\n");
        var declarations = new Declarations(text);
        for (var declaration in declarations) {
          expect(declaration is VariableDeclaration, true, reason: "Not a $VariableDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Enum typedef declarations.", () {
        var lines = baseList.toList();
        lines = _addBeforeAndAfter(lines, "typedef ", " s1;");
        var text = lines.join("\n");
        var declarations = new Declarations(text);
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
        var declarations = new Declarations(text);
        for (var declaration in declarations) {
          expect(declaration is VariableDeclaration, true, reason: "Not a $VariableDeclaration");
        }

        _checkPresentation(text, declarations);
        for (var declaration in declarations) {
          var type = (declaration as VariableDeclaration).type;
          expect(type is BasicTypeSpecification, true, reason: "Not an $BasicTypeSpecification");
          var builtinType = type as BasicTypeSpecification;
          expect(builtinType.typeKind == TypeSpecificationKind.BASIC, true,
              reason: "typeKind != TypeSpecificationKind.INTEGER");
        }
      });

      test("Integer array variable declarations.", () {
        var list = <String>[];
        for (var type in types) {
          var ident = type.replaceAll(" ", "");
          list.add("$type ${ident}0[];");
        }

        var text = list.join("\n");
        var declarations = new Declarations(text);
        for (var declaration in declarations) {
          expect(declaration is VariableDeclaration, true, reason: "Not a $VariableDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Integer pointer variable declarations.", () {
        var list = <String>[];
        for (var type in types) {
          var ident = type.replaceAll(" ", "");
          list.add("$type *${ident}0;");
        }

        var text = list.join("\n");
        var declarations = new Declarations(text);
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
        var declarations = new Declarations(text);
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
        var declarations = new Declarations(text);
        for (var declaration in declarations) {
          expect(declaration is TypedefDeclaration, true, reason: "Not a $TypedefDeclaration");
        }

        _checkPresentation(text, declarations);
      });

      test("Integer pointer typedef declarations.", () {
        var list = <String>[];
        for (var type in types) {
          var ident = type.replaceAll(" ", "");
          list.add("typedef $type *${ident}0;");
        }

        var text = list.join("\n");
        var declarations = new Declarations(text);
        for (var declaration in declarations) {
          expect(declaration is TypedefDeclaration, true, reason: "Not a $TypedefDeclaration");
        }

        _checkPresentation(text, declarations);
      });
    });
  });

  group("Misc.", () {
    test("Typedefs.", () {
      var list = <String>[];
      list.add("typedef int INT, *PINT, **PPINT, AINTZ[], AINT10[10], *PAINT10_20[10][20];");
      list.add("typedef int FOO(int, char *), BAZ();");
      list.add("typedef int (**FOO)(int, char *);");
      var text = list.join("\n");
      var declarations = new Declarations(text);
      _checkPresentation(text, declarations);

      text = "typedef int (FOO)(int, char *);";
      declarations = new Declarations(text);
      _checkPresentation("typedef int FOO(int, char *);", declarations);
    });

    test("Type qualifiers.", () {
      var list = <String>[];
      list.add("const int i;");
      list.add("typedef const const int const const INT;");
      var text = list.join("\n");
      var declarations = new Declarations(text);
      _checkPresentation(text, declarations);
    });

    test("Octal numbers.", () {
      var list = <String>[];
      list.add("int i[ 011 ];");
      var text = list.join("\n");
      var declarations = new Declarations(text);
      _checkPresentation("int i[011];", declarations);
    });

    test("Hexadecimal numbers.", () {
      var list = <String>[];
      list.add("int i[ 0x11 ];");
      var text = list.join("\n");
      var declarations = new Declarations(text);
      _checkPresentation("int i[0x11];", declarations);
    });

    test("Attributes.", () {
      var list = <String>[];
      list.add(
          "const __attribute__((A0)) typedef __attribute__((A1)) signed int __attribute__((A2)) INT __attribute__((A3));");
      list.add("__attribute__((A0)) typedef __attribute__((A1)) FOO __attribute__((A2)) BAZ __attribute__((A3));");
      list.add("__attribute__((A0)) float __attribute__((A1)) f __attribute__((A2));");
      list.add("__attribute__((A0)) enum __attribute__((A1)) ee e __attribute__((A2));");
      list.add("__attribute__((A0)) struct __attribute__((A1)) ss s __attribute__((A2));");
      list.add("__attribute__((A0)) int __attribute__((A1)) i __attribute__((A2));");
      list.add(
          "__attribute__((A0)) int __attribute__((A1)) foo(int __attribute__((A2)) x __attribute__((A3))) __attribute__((A4));");
      list.add(
          "__attribute__((A0)) struct __attribute__((A1)) { int __attribute__((A2)) x __attribute__((A3)); } __attribute__((A4)) s __attribute__((A5));");
      list.add(
          "__attribute__((A0)) struct __attribute__((A1)) ss { int __attribute__((A2)) x __attribute__((A3)); } __attribute__((A4)) s __attribute__((A5));");
      list.add("__attribute__((A0)) enum __attribute__((A1)) { E } __attribute__((A2)) e __attribute__((A3));");
      list.add("__attribute__((A0)) enum __attribute__((A1)) ee { E } __attribute__((A2)) e __attribute__((A3));");
      list.add("__attribute__((A0)) TYPE __attribute__((A1)) i __attribute__((A2));");
      list.add("__attribute__((A0)) int __attribute__((aligned(8), packed)) i __attribute__((foo(\"baz\", 2)));");
      list.add(
          "__attribute__((A0)) typedef __attribute__((A1)) int __attribute__((A2)) * __attribute__((A3)) *INT __attribute__((A4));");
      list.add(
          "__attribute__((A0)) typedef __attribute__((A1)) const int __attribute__((A3)) * __attribute__((A4)) *INT __attribute__((A5));");
      list.add(
          "const char *strncpy(char *destination, const char *source, size_t num) __attribute__((alias(\"_sprintf_p\")));");
      var text = list.join("\n");
      var declarations = new Declarations(text);
      _checkPresentation(text, declarations);
    });

    test("Semicolons.", () {
      var declarations = new Declarations(";;;");
      _checkPresentation(";;", declarations);
    });

    test("String literal concatenation.", () {
      var list = <String>[];
      list.add('__attribute__((deprecated("This" "is" "deprecated"))) int foo;');
      var text = list.join("\n");
      var declarations = new Declarations(text);
      _checkPresentation(text, declarations);
    });

    test("Directives.", () {});

    test("Expressions.", () {
      var list = <String>[];
      list.add('int i[(sizeof(FOO) >> 2) > 512 ? 1 : -1];');
      var text = list.join("\n");
      var declarations = new Declarations(text);
      _checkPresentation(text, declarations);
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

void _checkPresentation(String text, Declarations declarations) {
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
  result.add("signed");
  result.add("unsigned");
  for (var type in types) {
    result.add(type);
    result.add("signed $type");
    result.add("unsigned $type");
  }

  return result;
}
