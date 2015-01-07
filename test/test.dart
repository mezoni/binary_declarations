import "package:binary_declarations/binary_declarations.dart";

void main() {
  var declarations = new BinaryDeclarations(text);
  for (var declaration in declarations) {
    print("$declaration;");
  }
}

var text = '''
int8_t int8;
signed char[10] foo(struct S);
struct _s {} s;
int i;
int* ip;
void* vpa;
struct _s { int i; } s;
typedef int INT;
typedef int int32_t;
typedef void* PVOID;
typedef void* PVOIDA[];
typedef void* PVOIDA[10];
typedef struct _s SA[];
typedef struct {} S;
typedef struct _s {} S2;
typedef struct _s { int i; int* ip; } S2;
typedef struct _s { int i; int* ip; struct s { int i; } s; } S2;
struct {};
struct _s {};
struct _s {
  int i;
  char* cp;
};
int foo(void);
int foo(void* []);
int foo(char[]);
int foo(int, ...);
int foo(int, const char*, ...);
int foo(const int*);
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