import "package:binary_declarations/binary_declarations.dart";
import "package:binary_declarations/expression_evaluator.dart";
import "package:test/test.dart";

void main() {
  group("Expression evaluator", () {
    test("", () {
      var text = "enum A {B = 20 - 2 * 4 - 4};";
      var files = {"header.h": text};
      var declarations = new Declarations("header.h", files);
      EnumDeclaration first = declarations.first;
      var expr = first.type.enumerators.elements.first.value;
      var eval = new ExpressionEvaluator();
      var result = eval.evaluate(expr);
      expect(result, 8);

      //
      text = "enum A {B = 0 | 1};";
      files = {"header.h": text};
      declarations = new Declarations("header.h", files);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 1);

      //
      text = "enum A {B = 0 || 1};";
      files = {"header.h": text};
      declarations = new Declarations("header.h", files);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 1);

      //
      text = "enum A {B = 1 ^ 1};";
      files = {"header.h": text};
      declarations = new Declarations("header.h", files);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 0);

      //
      text = "enum A {B = 1 && 0};";
      files = {"header.h": text};
      declarations = new Declarations("header.h", files);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 0);

      //
      text = "enum A {B = 1 || 0};";
      files = {"header.h": text};
      declarations = new Declarations("header.h", files);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 1);

      //
      text = "enum A {B = 1 != 0};";
      files = {"header.h": text};
      declarations = new Declarations("header.h", files);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 1);

      //
      text = "enum A {B = !1};";
      files = {"header.h": text};
      declarations = new Declarations("header.h", files);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 0);
    });
  });
}
