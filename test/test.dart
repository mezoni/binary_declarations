import "package:binary_declarations/binary_declarations.dart";

void main() {
  var declarations = new BinaryDeclarations(text);
  for (var declaration in declarations) {
    print(declaration);
  }
}

var text = '''
int foo(char[]);
int foo(int, ...);
int foo(int, const char*, ...);
int foo(const int);
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