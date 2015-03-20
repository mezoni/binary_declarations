part of binary_declarations;

class AstPrinter<T> extends AstVisitor {
  final StringBuffer sb;

  String _newLine;

  AstPrinter(this.sb, {bool inline: false}) {
    if (sb == null) {
      throw new ArgumentError.notNull("sb");
    }

    if (inline == null) {
      throw new ArgumentError.notNull("inline");
    }

    if (inline) {
      _newLine = "\n";
    } else {
      _newLine = " ";
    }
  }

  String toString() {
    return sb.toString();
  }

  T visitArguments(Arguments node) {
    _joinNodes(node.elements, ", ");
    return null;
  }

  T visitArrayDimensions(ArrayDimensions node) {
    for (var element in node.elements) {
      if (element == null) {
        sb.write("[]");
      } else {
        sb.write("[");
        element.accept(this);
        sb.write("]");
      }
    }

    return null;
  }

  T visitBasicTypeSpecification(BasicTypeSpecification node) {
    node.specifiers.accept(this);
    _visitNode(node.metadata, prefix: " ");
    _visitNode(node.qualifiers, prefix: " ");
    return null;
  }

  T visitBinaryExpression(BinaryExpression node) {
    node.left.accept(this);
    sb.write(" ");
    sb.write(node.operator);
    sb.write(" ");
    node.right.accept(this);
    return null;
  }

  T visitBoolTypeSpecification(BoolTypeSpecification node) {
    node.identifier.accept(this);
    _visitNode(node.metadata, prefix: " ");
    _visitNode(node.qualifiers, prefix: " ");
    return null;
  }

  T visitCharacterLiteral(CharacterLiteral node) {
    sb.write(node.text);
    return null;
  }

  T visitConditionalExpression(ConditionalExpression node) {
    node.condition.accept(this);
    sb.write(" ? ");
    node.left.accept(this);
    sb.write(" : ");
    node.right.accept(this);
    return null;
  }

  T visitDeclarationModifier(DeclarationModifier node) {
    node.identifier.accept(this);
    _visitNode(node.arguments, prefix: "(", suffix: ")");
    return null;
  }

  T visitDeclarationModifiers(DeclarationModifiers node) {
    _joinNodes(node.elements, ", ");
    return null;
  }

  T visitDeclarationSpecifier(DeclarationSpecifier node) {
    node.identifier.accept(this);
    sb.write("(");
    if (node.parenthesis) {
      sb.write("(");
    }

    node.modifiers.accept(this);
    sb.write(")");
    if (node.parenthesis) {
      sb.write(")");
    }

    return null;
  }

  T visitDeclarationSpecifiers(DeclarationSpecifiers node) {
    _joinNodes(node.elements, " ");
    return null;
  }

  T visitDeclarator(Declarator node) {
    var separator = "";
    var pointers = node.pointers;
    if (pointers != null) {
      var string = pointers.toString();
      sb.write(string);
      if (string.endsWith("*")) {
        separator = "";
      } else {
        separator = " ";
      }
    }

    var identifier = node.identifier;
    var parameters = node.parameters;
    if (parameters == null) {
      if (identifier != null) {
        sb.write(separator);
        node.identifier.accept(this);
        separator = " ";
      }

      var width = node.width;
      if (width != null) {
        sb.write(separator);
        sb.write(": ");
        width.accept(this);
      }

      separator = "";
    } else {
      var functionPointers = node.functionPointers;
      if (functionPointers != null) {
        sb.write("(");
        functionPointers.accept(this);
        identifier.accept(this);
        sb.write(")");
      } else {
        identifier.accept(this);
      }

      sb.write("(");
      parameters.accept(this);
      sb.write(")");
    }

    var dimensions = node.dimensions;
    if (dimensions != null) {
      dimensions.accept(this);
    }

    var metadata = node.metadata;
    if (metadata != null) {
      sb.write(" ");
      metadata.accept(this);
    }

    return null;
  }

  T visitDefinedTypeSpecification(DefinedTypeSpecification node) {
    node.identifier.accept(this);
    _visitNode(node.metadata, prefix: " ");
    _visitNode(node.qualifiers, prefix: " ");
    return null;
  }

  visitElaboratedTypeSpecifier(ElaboratedTypeSpecifier node) {
    node.kind.accept(this);
    _visitNode(node.metadata, prefix: " ");
    _visitNode(node.tag, prefix: " ");
    return null;
  }

  visitEmptyDeclaration(EmptyDeclaration node) {
    sb.write(";");
  }

  visitEnumDeclaration(EnumDeclaration node) {
    _visitNode(node.metadata, suffix: " ");
    _visitNode(node.qualifiers, suffix: " ");
    node.type.accept(this);
  }

  visitEnumTypeSpecification(EnumTypeSpecification node) {
    node.elaboratedType.accept(this);
    var enumerators = node.enumerators;
    if (enumerators != null) {
      sb.write(" { ");
      enumerators.accept(this);
      sb.write(" }");
    }

    _visitNode(node.metadata, prefix: " ");
    _visitNode(node.qualifiers, prefix: " ");
  }

  visitEnumerator(Enumerator node) {
    node.identifier.accept(this);
    _visitNode(node.value, prefix: " = ");
    return null;
  }

  visitEnumerators(Enumerators node) {
    _joinNodes(node.elements, ",$_newLine");
    return null;
  }

  T visitFloatingPointLiteral(FloatingPointLiteral node) {
    sb.write(node.text);
    return null;
  }

  visitFunctionBody(FunctionBody node) {
    sb.write("{ }");
    return null;
  }

  visitFunctionDeclaration(FunctionDeclaration node) {
    _joinNodes(<AstNode>[node.metadata, node.qualifiers, node.type, node.declarator, node.body], " ");
  }

  T visitFunctionInvocation(FunctionInvocation node) {
    node.identifier.accept(this);
    sb.write("(");
    _visitNode(node.arguments);
    sb.write(")");
    return null;
  }

  T visitFunctionParameters(FunctionParameters node) {
    _joinNodes(node.elements, ", ");
    _visitNode(node.ellipsis, prefix: ", ");
    return null;
  }

  T visitIdentifier(Identifier node) {
    sb.write(node.name);
    return null;
  }

  T visitIntegerLiteral(IntegerLiteral node) {
    sb.write(node.text);
    return null;
  }

  T visitMemberDeclarations(MemberDeclarations node) {
    for (var member in node.elements) {
      member.accept(this);
      sb.write(";$_newLine");
    }

    return null;
  }

  visitParameterDeclaration(ParameterDeclaration node) {
    _visitNode(node.metadata, suffix: " ");
    _visitNode(node.qualifiers, suffix: " ");
    _joinNodes([node.type, node.declarator], " ");
    return null;
  }

  visitParenthesisExpression(ParenthesisExpression node) {
    sb.write("(");
    node.expression.accept(this);
    sb.write(")");
    return null;
  }

  T visitPointerSpecifier(PointerSpecifier node) {
    sb.write("*");
    _visitNode(node.qualifiers, prefix: " ");
    _visitNode(node.metadata, prefix: " ");
    return null;
  }

  visitPointerSpecifiers(PointerSpecifiers node) {
    var separator = "";
    for (var element in node.elements) {
      var string = element.toString();
      sb.write(separator);
      sb.write(string);
      if (!string.endsWith("*")) {
        separator = " ";
      }
    }
  }

  T visitSizeofExpression(SizeofExpression node) {
    sb.write("sizeof(");
    node.type.accept(this);
    sb.write(")");
    return null;
  }

  T visitStringLiteral(StringLiteral node) {
    sb.write(node.text);
    return null;
  }

  visitStructureDeclaration(StructureDeclaration node) {
    _visitNode(node.metadata, suffix: " ");
    _visitNode(node.qualifiers, suffix: " ");
    node.type.accept(this);
  }

  visitStructureTypeSpecification(StructureTypeSpecification node) {
    node.elaboratedType.accept(this);
    var members = node.members;
    if (members != null) {
      sb.write(" { ");
      members.accept(this);
      sb.write("}");
    }

    _visitNode(node.metadata, prefix: " ");
    _visitNode(node.qualifiers, prefix: " ");
  }

  T visitTypeQualifier(TypeQualifier node) {
    node.identifier.accept(this);
    _visitNode(node.metadata, prefix: " ");
    return null;
  }

  T visitTypeQualifiers(TypeQualifiers node) {
    _joinNodes(node.elements, " ");
    return null;
  }

  visitTypeSpecifiers(TypeSpecifiers node) {
    _joinNodes(node.elements, " ");
  }

  visitTypedefDeclaration(TypedefDeclaration node) {
    _visitNode(node.metadata, suffix: " ");
    _visitNode(node.qualifiers, suffix: " ");
    node.typedef.accept(this);
    sb.write(" ");
    node.type.accept(this);
    sb.write(" ");
    node.declarators.accept(this);
    return null;
  }

  visitTypedefDeclarators(TypedefDeclarators node) {
    _joinNodes(node.elements, ", ");
    return null;
  }

  T visitTypedefSpecifier(TypedefSpecifier node) {
    sb.write("typedef");
    _visitNode(node.metadata, prefix: " ");
    _visitNode(node.qualifiers, prefix: " ");
    return null;
  }

  T visitUnaryExpression(UnaryExpression node) {
    sb.write(node.operator);
    sb.write("");
    node.operand.accept(this);
    return null;
  }

  T visitVariableDeclaration(VariableDeclaration node) {
    _visitNode(node.metadata, suffix: " ");
    _visitNode(node.qualifiers, suffix: " ");
    node.type.accept(this);
    sb.write(" ");
    node.declarators.accept(this);
    return null;
  }

  T visitVariableDeclarators(VariableDeclarators node) {
    _joinNodes(node.elements, ", ");
    return null;
  }

  visitVoidTypeSpecification(VoidTypeSpecification node) {
    node.identifier.accept(this);
    _visitNode(node.metadata, prefix: " ");
    _visitNode(node.qualifiers, prefix: " ");
    return null;
  }

  void _joinNodes(List<AstNode> nodes, [String separator = ""]) {
    var length = nodes.length;
    for (var i = 0; i < length; i++) {
      var node = nodes[i];
      if (node != null) {
        node.accept(this);
      }

      if (i + 1 != length) {
        if (node != null) {
          var j = i + 1;
          while (j < length) {
            if (nodes[j++] != null) {
              sb.write(separator);
              break;
            }
          }
        }
      }
    }
  }

  void _visitNode(AstNode node, {String prefix: "", String suffix: ""}) {
    if (node != null) {
      sb.write(prefix);
      node.accept(this);
      sb.write(suffix);
    }
  }
}

abstract class AstVisitor<T> {
  T visitArguments(Arguments node);

  T visitArrayDimensions(ArrayDimensions node);

  T visitBasicTypeSpecification(BasicTypeSpecification node);

  T visitBinaryExpression(BinaryExpression node);

  T visitBoolTypeSpecification(BoolTypeSpecification node);

  T visitCharacterLiteral(CharacterLiteral node);

  T visitConditionalExpression(ConditionalExpression node);

  T visitDeclarationModifier(DeclarationModifier node);

  T visitDeclarationModifiers(DeclarationModifiers node);

  T visitDeclarationSpecifier(DeclarationSpecifier node);

  T visitDeclarationSpecifiers(DeclarationSpecifiers node);

  T visitDeclarator(Declarator node);

  T visitDefinedTypeSpecification(DefinedTypeSpecification node);

  T visitElaboratedTypeSpecifier(ElaboratedTypeSpecifier node);

  T visitEmptyDeclaration(EmptyDeclaration node);

  T visitEnumDeclaration(EnumDeclaration node);

  T visitEnumTypeSpecification(EnumTypeSpecification node);

  T visitEnumerator(Enumerator node);

  T visitEnumerators(Enumerators node);

  T visitFloatingPointLiteral(FloatingPointLiteral node);

  T visitFunctionBody(FunctionBody node);

  T visitFunctionDeclaration(FunctionDeclaration node);

  T visitFunctionInvocation(FunctionInvocation node);

  T visitFunctionParameters(FunctionParameters node);

  T visitIdentifier(Identifier node);

  T visitIntegerLiteral(IntegerLiteral node);

  T visitMemberDeclarations(MemberDeclarations node);

  T visitParameterDeclaration(ParameterDeclaration node);

  T visitParenthesisExpression(ParenthesisExpression node);

  T visitPointerSpecifier(PointerSpecifier node);

  T visitPointerSpecifiers(PointerSpecifiers node);

  T visitSizeofExpression(SizeofExpression node);

  T visitStringLiteral(StringLiteral node);

  T visitStructureDeclaration(StructureDeclaration node);

  T visitStructureTypeSpecification(StructureTypeSpecification node);

  T visitTypeQualifier(TypeQualifier node);

  T visitTypeQualifiers(TypeQualifiers node);

  T visitTypeSpecifiers(TypeSpecifiers node);

  T visitTypedefDeclaration(TypedefDeclaration node);

  T visitTypedefDeclarators(TypedefDeclarators node);

  T visitTypedefSpecifier(TypedefSpecifier node);

  T visitUnaryExpression(UnaryExpression node);

  T visitVariableDeclaration(VariableDeclaration node);

  T visitVariableDeclarators(VariableDeclarators node);

  T visitVoidTypeSpecification(VoidTypeSpecification node);
}

class GeneralAstVisitor<T> extends AstVisitor<T> {
  T visit(AstNode node) {
    node.visitChildren(this);
    return null;
  }

  T visitArguments(Arguments node) => visit(node);

  T visitArrayDimensions(ArrayDimensions node) => visit(node);

  T visitBasicTypeSpecification(BasicTypeSpecification node) => visit(node);

  T visitBinaryExpression(BinaryExpression node) => visit(node);

  T visitBoolTypeSpecification(BoolTypeSpecification node) => visit(node);

  T visitCharacterLiteral(CharacterLiteral node) => visit(node);

  T visitConditionalExpression(ConditionalExpression node) => visit(node);

  T visitDeclarationModifier(DeclarationModifier node) => visit(node);

  T visitDeclarationModifiers(DeclarationModifiers node) => visit(node);

  T visitDeclarationSpecifier(DeclarationSpecifier node) => visit(node);

  T visitDeclarationSpecifiers(DeclarationSpecifiers node) => visit(node);

  T visitDeclarator(Declarator node) => visit(node);

  T visitDefinedTypeSpecification(DefinedTypeSpecification node) => visit(node);

  T visitElaboratedTypeSpecifier(ElaboratedTypeSpecifier node) => visit(node);

  T visitEmptyDeclaration(EmptyDeclaration node) => visit(node);

  T visitEnumDeclaration(EnumDeclaration node) => visit(node);

  T visitEnumTypeSpecification(EnumTypeSpecification node) => visit(node);

  T visitEnumerator(Enumerator node) => visit(node);

  T visitEnumerators(Enumerators node) => visit(node);

  T visitFloatingPointLiteral(FloatingPointLiteral node) => visit(node);

  T visitFunctionBody(FunctionBody node) => visit(node);

  T visitFunctionDeclaration(FunctionDeclaration node) => visit(node);

  T visitFunctionInvocation(FunctionInvocation node) => visit(node);

  T visitFunctionParameters(FunctionParameters node) => visit(node);

  T visitIdentifier(Identifier node) => visit(node);

  T visitIntegerLiteral(IntegerLiteral node) => visit(node);

  T visitMemberDeclarations(MemberDeclarations node) => visit(node);

  T visitParameterDeclaration(ParameterDeclaration node) => visit(node);

  T visitParenthesisExpression(ParenthesisExpression node) => visit(node);

  T visitPointerSpecifier(PointerSpecifier node) => visit(node);

  T visitPointerSpecifiers(PointerSpecifiers node) => visit(node);

  T visitSizeofExpression(SizeofExpression node) => visit(node);

  T visitStringLiteral(StringLiteral node) => visit(node);

  T visitStructureDeclaration(StructureDeclaration node) => visit(node);

  T visitStructureTypeSpecification(StructureTypeSpecification node) => visit(node);

  T visitTypeQualifier(TypeQualifier node) => visit(node);

  T visitTypeQualifiers(TypeQualifiers node) => visit(node);

  T visitTypeSpecifiers(TypeSpecifiers node) => visit(node);

  T visitTypedefDeclaration(TypedefDeclaration node) => visit(node);

  T visitTypedefDeclarators(TypedefDeclarators node) => visit(node);

  T visitTypedefSpecifier(TypedefSpecifier node) => visit(node);

  T visitUnaryExpression(UnaryExpression node) => visit(node);

  T visitVariableDeclaration(VariableDeclaration node) => visit(node);

  T visitVariableDeclarators(VariableDeclarators node) => visit(node);

  T visitVoidTypeSpecification(VoidTypeSpecification node) => visit(node);
}
