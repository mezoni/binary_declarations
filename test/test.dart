import "package:binary_declarations/binary_declarations.dart";

void main() {
  var declarations = new BinaryDeclarations(text);
  for (var declaration in declarations) {
    print(declaration);
  }
}

Map types;

void _errorTypesNotDefined() {
}

void declare(String text) {
  if (text == null) {
    throw new ArgumentError.notNull("text");
  }

  if (types == null) {
    _errorTypesNotDefined();
  }

  //types.declare(text);

  var declarations = new BinaryDeclarations(text);
  for (var declaration in declarations) {
    if (declaration is FunctionDeclaration) {
      var name = declaration.name;
      var returnType = types[declaration.returnType.toString()];
      var parameters = <dynamic>[];
      for (var paramater in declaration.parameters) {
        parameters.add(types[paramater.type.toString()]);
      }

      // function(name, returnType, parameters, convention: convention);
    }
  }
}

var text = '''
int foo(char[]);
int foo();
int foo(int);
int foo(int i);
int foo(int*, char[]);
int foo(int* ip, char cp[]);
int foo(int* ip, char cp[10]);
int foo(int* ip, char cp[10], struct S);
int foo(int* ip, char cp[10], union S);
struct S foo(int* ip, char cp[10][3], struct S);
struct S[] foo(int* ip, char cp[10][3], struct S);
signed char[10] foo(int* ip, char cp[10][3], struct S);
''';