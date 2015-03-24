import "package:binary_declarations/binary_declarations.dart";
import "package:binary_declarations/expression_evaluator.dart";
import "package:unittest/unittest.dart";

void main() {
  group("Expression evaluator", () {
    test("", () {
      var text = "enum A {B = 20 - 2 * 4 - 4};";
      var declarations = new Declarations(text);
      EnumDeclaration first = declarations.first;
      var expr = first.type.enumerators.elements.first.value;
      var eval = new ExpressionEvaluator();
      var result = eval.evaluate(expr);
      expect(result, 8);

      //
      text = "enum A {B = 0 | 1};";
      declarations = new Declarations(text);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 1);

      //
      text = "enum A {B = 0 || 1};";
      declarations = new Declarations(text);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 1);

      //
      text = "enum A {B = 1 ^ 1};";
      declarations = new Declarations(text);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 0);

      //
      text = "enum A {B = 1 && 0};";
      declarations = new Declarations(text);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 0);

      //
      text = "enum A {B = 1 || 0};";
      declarations = new Declarations(text);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 1);

      //
      text = "enum A {B = 1 != 0};";
      declarations = new Declarations(text);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 1);

      //
      text = "enum A {B = !1};";
      declarations = new Declarations(text);
      first = declarations.first;
      expr = first.type.enumerators.elements.first.value;
      eval = new ExpressionEvaluator();
      result = eval.evaluate(expr);
      expect(result, 0);
    });
  });
}
