part of binary_declarations.expression_evaluator;

class ExpressionEvaluator<T> extends GeneralAstVisitor<T> {
  Function _identifier;

  Function _sizeof;

  dynamic evaluate(Expression expression, {int identifier(Identifier identifier), int sizeof(TypeSpecification type)}) {
    if (expression == null) {
      throw new ArgumentError.notNull("expression");
    }

    _identifier = identifier;
    _sizeof = sizeof;
    return expression.accept(this);
  }

  Object visitBinaryExpression(BinaryExpression node) {
    var left = node.left;
    var right = node.right;
    var lvalue = left.accept(this);
    var rvalue = right.accept(this);
    switch (node.operator) {
      case "+":
        _checkNumericValue(lvalue, left);
        _checkNumericValue(rvalue, right);
        return lvalue + rvalue;
      case "-":
        _checkNumericValue(lvalue, left);
        _checkNumericValue(rvalue, right);
        return lvalue - rvalue;
      case "*":
        _checkNumericValue(lvalue, left);
        _checkNumericValue(rvalue, right);
        return lvalue * rvalue;
      case "/":
        _checkNumericValue(lvalue, left);
        _checkNumericValue(rvalue, right);
        if (lvalue is int && rvalue is int) {
          return lvalue ~/ rvalue;
        }

        return lvalue / rvalue;
      case "<<":
        _checkIntegerValue(lvalue, left);
        _checkIntegerValue(rvalue, right);
        return lvalue << rvalue;
      case ">>":
        _checkIntegerValue(lvalue, left);
        _checkIntegerValue(rvalue, right);
        return lvalue >> rvalue;
      case "&":
        _checkIntegerValue(lvalue, left);
        _checkIntegerValue(rvalue, right);
        return lvalue & rvalue;
      case "|":
        _checkIntegerValue(lvalue, left);
        _checkIntegerValue(rvalue, right);
        return lvalue | rvalue;
      case "^":
        _checkIntegerValue(lvalue, left);
        _checkIntegerValue(rvalue, right);
        return lvalue ^ rvalue;
      case ">=":
        _checkComparableValue(lvalue, left);
        _checkComparableValue(rvalue, right);
        return lvalue >= rvalue ? 1 : 0;
      case ">":
        _checkComparableValue(lvalue, left);
        _checkComparableValue(rvalue, right);
        return lvalue > rvalue ? 1 : 0;
      case "<=":
        _checkComparableValue(lvalue, left);
        _checkComparableValue(rvalue, right);
        return lvalue <= rvalue ? 1 : 0;
      case "<":
        _checkComparableValue(lvalue, left);
        _checkComparableValue(rvalue, right);
        return lvalue < rvalue ? 1 : 0;
      case "==":
        _checkComparableValue(lvalue, left);
        _checkComparableValue(rvalue, right);
        return lvalue == rvalue ? 1 : 0;
      case "!=":
        _checkComparableValue(lvalue, left);
        _checkComparableValue(rvalue, right);
        return lvalue != rvalue ? 1 : 0;
      case "&&":
        _checkIntegerValue(lvalue, left);
        _checkIntegerValue(rvalue, right);
        return lvalue && rvalue;
      case "||":
        _checkIntegerValue(lvalue, left);
        _checkIntegerValue(rvalue, right);
        return lvalue || rvalue;
      default:
        throw new FormatException("Unknown binary operation: $node");
    }
  }

  Object visitCharacterLiteral(CharacterLiteral node) {
    return node.value;
  }

  Object visitConditionalExpression(ConditionalExpression node) {
    var condition = node.condition.accept(this);
    var left = node.left.accept(this);
    var right = node.right.accept(this);
    _checkIntegerValue(condition, node.condition);
    return condition != 0 ? right : left;
  }

  Object visitFloatingPointLiteral(FloatingPointLiteral node) {
    return node.value;
  }

  Object visitIdentifier(Identifier node) {
    if (_identifier == null) {
      throw new FormatException("Unexpected expression: $node");
    }

    return _identifier(node);
  }

  Object visitIntegerLiteral(IntegerLiteral node) {
    return node.value;
  }

  Object visitNode(AstNode node) {
    throw new FormatException("Syntax error: $node");
  }

  Object visitParenthesisExpression(ParenthesisExpression node) {
    return node.expression.accept(this);
  }

  Object visitSizeofExpression(SizeofExpression node) {
    if (_sizeof == null) {
      throw new FormatException("Unexpected expression: $node");
    }

    return _sizeof(node.type);
  }

  Object visitUnaryExpression(UnaryExpression node) {
    var operand = node.operand;
    var value = operand.accept(this);
    switch (node.operator) {
      case "+":
        _checkNumericValue(value, operand);
        return value;
      case "-":
        _checkNumericValue(value, operand);
        return -value;
      case "!":
        _checkIntegerValue(value, operand);
        return value == 0 ? 1 : 0;
      case "~":
        _checkIntegerValue(value, operand);
        return ~value;
      default:
        throw new FormatException("Unknown unary operation: $node");
    }
  }

  void _checkComparableValue(value, AstNode node) {
    if (value is! Comparable) {
      throw new FormatException("Expected comparable expression: $node");
    }
  }

  void _checkIntegerValue(value, AstNode node) {
    if (value is! int) {
      throw new FormatException("Expected integer expression: $node");
    }
  }

  void _checkNumericValue(value, AstNode node) {
    if (value is! num) {
      throw new FormatException("Expected numeric expression: $node");
    }
  }
}
