part of binary_declarations;

class Arguments extends AstNodeList<Expression> {
  Arguments({List<Expression> elements}) : super(elements: elements);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitArguments(this);
  }
}

class ArrayDimensions extends AstNodeList<Expression> {
  ArrayDimensions({List<Expression> elements}) : super(allowNull: true, elements: elements);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitArrayDimensions(this);
  }
}

abstract class AstNode {
  dynamic accept(AstVisitor visitor);

  String toString() {
    var visitor = new AstPrinter(new StringBuffer());
    accept(visitor);
    return visitor.toString();
  }

  void visitChildren(AstVisitor visitor) {}
}

abstract class AstNodeList<T extends AstNode> extends AstNode {
  List<T> _elements;

  AstNodeList({bool allowNull: false, List<T> elements}) {
    if (allowNull == null) {
      throw new ArgumentError.notNull("allowNull");
    }

    if (elements == null) {
      throw new ArgumentError.notNull("elements");
    }

    _elements = new _ListCloner<T>(elements, "elements", allowNull: allowNull).list;
  }

  List<T> get elements => _elements;

  void visitChildren(AstVisitor visitor) {
    for (var element in elements) {
      if (element != null) {
        element.accept(visitor);
      }
    }
  }
}

class BasicTypeSpecification extends TypeSpecification {
  final TypeSpecifiers specifiers;

  String _name;

  BasicTypeSpecification({DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.specifiers})
      : super(metadata: metadata, qualifiers: qualifiers) {
    if (specifiers == null) {
      throw new ArgumentError.notNull("identifier");
    }

    _name = specifiers.toString();
  }

  String get name => _name;

  TypeSpecificationKind get typeKind => TypeSpecificationKind.BASIC;

  dynamic accept(AstVisitor visitor) {
    return visitor.visitBasicTypeSpecification(this);
  }

  void visitChildren(AstVisitor visitor) {
    specifiers.accept(visitor);
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }
  }
}

class BinaryExpression extends Expression {
  final Expression left;

  final String operator;

  final Expression right;

  BinaryExpression({this.left, this.operator, this.right}) {
    if (left == null) {
      throw new ArgumentError.notNull("left");
    }

    if (operator == null) {
      throw new ArgumentError.notNull("operator");
    }

    if (right == null) {
      throw new ArgumentError.notNull("right");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitBinaryExpression(this);
  }

  void visitChildren(AstVisitor visitor) {
    left.accept(visitor);
    right.accept(visitor);
  }
}

class BoolTypeSpecification extends TypeSpecification {
  final Identifier identifier;

  BoolTypeSpecification({this.identifier, DeclarationSpecifiers metadata, TypeQualifiers qualifiers})
      : super(metadata: metadata, qualifiers: qualifiers) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }

    if (identifier.name != "_Bool") {
      throw new ArgumentError.value(identifier, "identifier");
    }
  }

  String get name => identifier.name;

  TypeSpecificationKind get typeKind => TypeSpecificationKind.BOOL;

  dynamic accept(AstVisitor visitor) {
    return visitor.visitBoolTypeSpecification(this);
  }

  void visitChildren(AstVisitor visitor) {
    identifier.accept(visitor);
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }
  }
}

class ConditionalExpression extends Expression {
  final Expression condition;

  final Expression left;

  final Expression right;

  ConditionalExpression({this.condition, this.left, this.right}) {
    if (condition == null) {
      throw new ArgumentError.notNull("condition");
    }

    if (left == null) {
      throw new ArgumentError.notNull("left");
    }

    if (right == null) {
      throw new ArgumentError.notNull("right");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitConditionalExpression(this);
  }

  void visitChildren(AstVisitor visitor) {
    condition.accept(visitor);
    left.accept(visitor);
    right.accept(visitor);
  }
}

abstract class Declaration extends AstNode {
  String filename;

  final DeclarationSpecifiers metadata;

  final TypeQualifiers qualifiers;

  Declaration({this.metadata, this.qualifiers});
}

class DeclarationModifier extends AstNode {
  final Identifier identifier;

  final Arguments arguments;

  DeclarationModifier({this.arguments, this.identifier}) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitDeclarationModifier(this);
  }

  void visitChildren(AstVisitor visitor) {
    identifier.accept(visitor);
    if (arguments != null) {
      arguments.accept(visitor);
    }
  }
}

class DeclarationModifiers extends AstNodeList<DeclarationModifier> {
  DeclarationModifiers({List<DeclarationModifier> elements}) : super(elements: elements);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitDeclarationModifiers(this);
  }
}

class DeclarationSpecifier extends AstNode {
  final bool parenthesis;

  final Identifier identifier;

  final DeclarationModifiers modifiers;

  DeclarationSpecifier({this.identifier, this.modifiers, this.parenthesis}) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }

    if (modifiers == null) {
      throw new ArgumentError.notNull("modifiers");
    }

    if (parenthesis == null) {
      throw new ArgumentError.notNull("parenthesis");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitDeclarationSpecifier(this);
  }

  void visitChildren(AstVisitor visitor) {
    identifier.accept(visitor);
    modifiers.accept(visitor);
  }
}

class DeclarationSpecifiers extends AstNodeList<DeclarationSpecifier> {
  DeclarationSpecifiers({List<DeclarationSpecifier> elements}) : super(elements: elements);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitDeclarationSpecifiers(this);
  }
}

class Declarator extends AstNode {
  final ArrayDimensions dimensions;

  final PointerSpecifiers functionPointers;

  final Identifier identifier;

  final DeclarationSpecifiers metadata;

  final FunctionParameters parameters;

  final PointerSpecifiers pointers;

  final IntegerLiteral width;

  Declarator({this.dimensions, this.functionPointers, this.identifier, this.metadata, this.parameters, this.pointers,
      this.width}) {
    if (isBitField && (isArray || isFunction || isPointers)) {
      throw new ArgumentError("Width should only be specified separately from other arguments");
    }

    if (functionPointers != null && parameters == null) {
      throw new ArgumentError("Function pointer declarator should have a parameters");
    }

    if (isFunction && identifier == null) {
      throw new ArgumentError("Function declarator should have an identifier");
    }

    if (dimensions == null && identifier == null && parameters == null && pointers == null && width == null) {
      //throw new ArgumentError("Dimensions, identifier, parameters, pointers and width cannot all be null simultaneously");
    }
  }

  bool get isArray => dimensions != null;

  bool get isBitField => width != null;

  bool get isFunction => parameters != null;

  bool get isFunctionPointer => functionPointers != null;

  bool get isPointers => pointers != null;

  dynamic accept(AstVisitor visitor) {
    return visitor.visitDeclarator(this);
  }

  void visitChildren(AstVisitor visitor) {
    if (pointers != null) {
      pointers.accept(visitor);
    }

    if (parameters == null) {
      if (identifier != null) {
        identifier.accept(visitor);
      }

      if (width != null) {
        width.accept(visitor);
      }
    } else {
      if (functionPointers != null) {
        functionPointers.accept(visitor);
        identifier.accept(visitor);
      } else {
        identifier.accept(visitor);
      }

      parameters.accept(visitor);
    }

    if (dimensions != null) {
      dimensions.accept(visitor);
    }

    if (metadata != null) {
      metadata.accept(visitor);
    }
  }
}

class DefinedTypeSpecification extends TypeSpecification {
  final Identifier identifier;

  DefinedTypeSpecification({this.identifier, DeclarationSpecifiers metadata, TypeQualifiers qualifiers})
      : super(metadata: metadata, qualifiers: qualifiers) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }
  }

  String get name => identifier.name;

  TypeSpecificationKind get typeKind => TypeSpecificationKind.DEFINED;

  dynamic accept(AstVisitor visitor) {
    return visitor.visitDefinedTypeSpecification(this);
  }

  void visitChildren(AstVisitor visitor) {
    identifier.accept(visitor);
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }
  }
}

class ElaboratedTypeSpecifier extends AstNode {
  final Identifier kind;

  final DeclarationSpecifiers metadata;

  final Identifier tag;

  String _name;

  ElaboratedTypeSpecifier({this.kind, this.metadata, this.tag}) {
    if (kind == null) {
      throw new ArgumentError.notNull("kind");
    }

    switch (kind.toString()) {
      case "enum":
      case "struct":
      case "union":
        break;
      default:
        throw new ArgumentError.value(kind, "kind");
    }

    if (tag == null) {
      _name = kind.toString();
    } else {
      _name = "$kind $tag";
    }
  }

  String get name => _name;

  dynamic accept(AstVisitor visitor) {
    return visitor.visitElaboratedTypeSpecifier(this);
  }

  void visitChildren(AstVisitor visitor) {
    kind.accept(visitor);
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (tag != null) {
      tag.accept(visitor);
    }
  }
}

class EmptyDeclaration extends Declaration {
  dynamic accept(AstVisitor visitor) {
    return visitor.visitEmptyDeclaration(this);
  }
}

class EnumDeclaration extends Declaration {
  final EnumTypeSpecification type;

  EnumDeclaration({DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.type})
      : super(metadata: metadata, qualifiers: qualifiers) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitEnumDeclaration(this);
  }

  void visitChildren(AstVisitor visitor) {
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }

    type.accept(visitor);
  }
}

class EnumTypeSpecification extends TypeSpecification {
  final ElaboratedTypeSpecifier elaboratedType;

  final Enumerators enumerators;

  EnumTypeSpecification(
      {this.elaboratedType, this.enumerators, DeclarationSpecifiers metadata, TypeQualifiers qualifiers})
      : super(metadata: metadata, qualifiers: qualifiers) {
    if (elaboratedType == null) {
      throw new ArgumentError.notNull("elaboratedType");
    }

    if (elaboratedType.kind.name != "enum") {
      throw new ArgumentError.value(elaboratedType, "elaboratedType");
    }
  }

  String get name => elaboratedType.name;

  TypeSpecificationKind get typeKind => TypeSpecificationKind.ENUM;

  dynamic accept(AstVisitor visitor) {
    return visitor.visitEnumTypeSpecification(this);
  }

  void visitChildren(AstVisitor visitor) {
    elaboratedType.accept(visitor);
    if (enumerators != null) {
      enumerators.accept(visitor);
    }

    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }
  }
}

class Enumerator extends AstNode {
  final Identifier identifier;

  final Expression value;

  Enumerator({this.identifier, this.value}) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitEnumerator(this);
  }

  void visitChildren(AstVisitor visitor) {
    identifier.accept(visitor);
    if (value != null) {
      value.accept(visitor);
    }
  }
}

class Enumerators extends AstNodeList<Enumerator> {
  Enumerators({List<Enumerator> elements}) : super(elements: elements);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitEnumerators(this);
  }
}

abstract class Expression extends AstNode {}

class FloatingPointLiteral extends Literal {
  final double value;

  FloatingPointLiteral({String text, double value})
      : this.value = value,
        super(text: text, value: value);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitFloatingPointLiteral(this);
  }
}

class FunctionBody extends AstNode {
  dynamic accept(AstVisitor visitor) {
    return visitor.visitFunctionBody(this);
  }
}

class FunctionDeclaration extends Declaration {
  final Declarator declarator;

  final FunctionBody body;

  final TypeSpecification type;

  FunctionDeclaration(
      {this.body, this.declarator, DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.type})
      : super(metadata: metadata, qualifiers: qualifiers) {
    if (declarator == null) {
      throw new ArgumentError.notNull("declarator");
    }

    if (!declarator.isFunction) {
      throw new ArgumentError("Declarator should be function declarator");
    }

    if (declarator.isFunctionPointer) {
      throw new ArgumentError("Declarator should not be function pointer declarator");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitFunctionDeclaration(this);
  }

  void visitChildren(AstVisitor visitor) {
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }

    if (type != null) {
      type.accept(visitor);
    }

    declarator.accept(visitor);
    if (body != null) {
      body.accept(visitor);
    }
  }
}

class FunctionInvocation extends Expression {
  final Arguments arguments;

  final Identifier identifier;

  FunctionInvocation({this.arguments, this.identifier}) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitFunctionInvocation(this);
  }

  void visitChildren(AstVisitor visitor) {
    identifier.accept(visitor);
    if (arguments != null) {
      arguments.accept(visitor);
    }
  }
}

class FunctionParameters extends AstNodeList<ParameterDeclaration> {
  final Identifier ellipsis;

  FunctionParameters({List<ParameterDeclaration> elements, this.ellipsis}) : super(elements: elements) {
    var list = <ParameterDeclaration>[];
    if (elements != null) {
      var length = elements.length;
      for (var i = 0; i < length; i++) {
        var declaration = elements[i];
        if (declaration == null) {
          throw new ArgumentError("List of declarations contains illegal elements.");
        }

        list.add(declaration);
      }
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitFunctionParameters(this);
  }

  void visitChildren(AstVisitor visitor) {
    super.visitChildren(visitor);
    if (ellipsis != null) {
      ellipsis.accept(visitor);
    }
  }
}

class Identifier extends Expression {
  final String name;

  Identifier({this.name}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitIdentifier(this);
  }
}

class IntegerLiteral extends Literal {
  final int value;

  IntegerLiteral({String text, int value})
      : this.value = value,
        super(text: text, value: value);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitIntegerLiteral(this);
  }
}

class CharacterLiteral extends Literal {
  final int value;

  CharacterLiteral({String text, int value})
      : this.value = value,
        super(text: text, value: value);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitCharacterLiteral(this);
  }
}

abstract class Literal extends Expression {
  final String text;

  Literal({this.text, dynamic value}) {
    if (text == null) {
      throw new ArgumentError.notNull("text");
    }

    if (value == null) {
      throw new ArgumentError.notNull("value");
    }
  }

  dynamic get value;
}

class MemberDeclarations extends AstNodeList<ParameterDeclaration> {
  MemberDeclarations({List<ParameterDeclaration> elements}) : super(elements: elements);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitMemberDeclarations(this);
  }
}

class ParameterDeclaration extends Declaration {
  final Declarator declarator;

  final TypeSpecification type;

  ParameterDeclaration({this.declarator, DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.type})
      : super(metadata: metadata, qualifiers: qualifiers) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitParameterDeclaration(this);
  }

  void visitChildren(AstVisitor visitor) {
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }

    type.accept(visitor);
    if (declarator != null) {
      declarator.accept(visitor);
    }
  }
}

class ParenthesisExpression extends Expression {
  final Expression expression;

  ParenthesisExpression({this.expression}) {
    if (expression == null) {
      throw new ArgumentError.notNull("expression");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitParenthesisExpression(this);
  }

  void visitChildren(AstVisitor visitor) {
    expression.accept(visitor);
  }
}

class PointerSpecifier extends AstNode {
  final DeclarationSpecifiers metadata;

  final TypeQualifiers qualifiers;

  PointerSpecifier({this.metadata, this.qualifiers});

  dynamic accept(AstVisitor visitor) {
    return visitor.visitPointerSpecifier(this);
  }

  void visitChildren(AstVisitor visitor) {
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }
  }
}

class PointerSpecifiers extends AstNodeList<PointerSpecifier> {
  PointerSpecifiers({List<PointerSpecifier> elements}) : super(elements: elements) {
    if (elements.isEmpty) {
      throw new ArgumentError("List of the elements cannot be empty");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitPointerSpecifiers(this);
  }
}

class SizeofExpression extends Expression {
  final TypeSpecification type;

  SizeofExpression({this.type}) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitSizeofExpression(this);
  }

  void visitChildren(AstVisitor visitor) {
    type.accept(visitor);
  }
}

class StringLiteral extends Literal {
  final String value;

  StringLiteral({String text, String value})
      : this.value = value,
        super(text: text, value: value);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitStringLiteral(this);
  }
}

class StructureDeclaration extends Declaration {
  final StructureTypeSpecification type;

  StructureDeclaration({DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.type})
      : super(metadata: metadata, qualifiers: qualifiers) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitStructureDeclaration(this);
  }

  void visitChildren(AstVisitor visitor) {
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }

    type.accept(visitor);
  }
}

class StructureTypeSpecification extends TypeSpecification {
  final ElaboratedTypeSpecifier elaboratedType;

  final MemberDeclarations members;

  StructureTypeSpecification(
      {this.elaboratedType, DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.members})
      : super(metadata: metadata, qualifiers: qualifiers) {
    if (elaboratedType == null) {
      throw new ArgumentError.notNull("elaboratedType");
    }

    switch (elaboratedType.kind.name) {
      case "struct":
      case "union":
        break;
      default:
        throw new ArgumentError.value(elaboratedType, "elaboratedType");
    }
  }

  String get name => elaboratedType.name;

  TypeSpecificationKind get typeKind => TypeSpecificationKind.STRUCTURE;

  dynamic accept(AstVisitor visitor) {
    return visitor.visitStructureTypeSpecification(this);
  }

  void visitChildren(AstVisitor visitor) {
    elaboratedType.accept(visitor);
    members.accept(visitor);
    if (metadata != null) {
      metadata.accept(visitor);
    }
  }
}

class TypeQualifier extends AstNode {
  final Identifier identifier;

  final DeclarationSpecifiers metadata;

  TypeQualifier({this.identifier, this.metadata}) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitTypeQualifier(this);
  }

  void visitChildren(AstVisitor visitor) {
    identifier.accept(visitor);
    if (metadata != null) {
      metadata.accept(visitor);
    }
  }
}

class TypeQualifiers extends AstNodeList<TypeQualifier> {
  TypeQualifiers({List<TypeQualifier> elements}) : super(elements: elements);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitTypeQualifiers(this);
  }
}

abstract class TypeSpecification extends AstNode {
  final DeclarationSpecifiers metadata;

  final TypeQualifiers qualifiers;

  TypeSpecification({this.metadata, this.qualifiers});

  String get name;

  TypeSpecificationKind get typeKind;
}

class TypeSpecificationKind {
  static const TypeSpecificationKind BASIC = const TypeSpecificationKind("BASIC");

  static const TypeSpecificationKind DEFINED = const TypeSpecificationKind("DEFINED");

  static const TypeSpecificationKind BOOL = const TypeSpecificationKind("BOOL");

  static const TypeSpecificationKind ENUM = const TypeSpecificationKind("ENUM");

  static const TypeSpecificationKind STRUCTURE = const TypeSpecificationKind("STRUCTURE");

  static const TypeSpecificationKind VOID = const TypeSpecificationKind("VOID");

  final String _name;

  const TypeSpecificationKind(this._name);

  String toString() => _name;
}

class TypeSpecifiers extends AstNodeList<Identifier> {
  TypeSpecifiers({List<Identifier> elements}) : super(elements: elements) {
    if (elements.isEmpty) {
      throw new ArgumentError("List of the elements cannot be empty");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitTypeSpecifiers(this);
  }
}

class TypedefDeclaration extends Declaration {
  final TypeSpecification type;

  final TypedefSpecifier typedef;

  final TypedefDeclarators declarators;

  TypedefDeclaration(
      {this.declarators, DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.type, this.typedef})
      : super(metadata: metadata, qualifiers: qualifiers) {
    if (declarators == null) {
      throw new ArgumentError.notNull("declarators");
    }

    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    if (typedef == null) {
      throw new ArgumentError.notNull("typedef");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitTypedefDeclaration(this);
  }

  void visitChildren(AstVisitor visitor) {
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }

    typedef.accept(visitor);
    type.accept(visitor);
    declarators.accept(visitor);
  }
}

class TypedefDeclarators extends AstNodeList<Declarator> {
  TypedefDeclarators({List<Declarator> elements}) : super(elements: elements);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitTypedefDeclarators(this);
  }
}

class TypedefSpecifier extends AstNode {
  final DeclarationSpecifiers metadata;

  final TypeQualifiers qualifiers;

  TypedefSpecifier({this.metadata, this.qualifiers});

  dynamic accept(AstVisitor visitor) {
    return visitor.visitTypedefSpecifier(this);
  }

  void visitChildren(AstVisitor visitor) {
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }
  }
}

class UnaryExpression extends Expression {
  final Expression operand;

  final String operator;

  UnaryExpression({this.operand, this.operator}) {
    if (operand == null) {
      throw new ArgumentError.notNull("left");
    }

    if (operator == null) {
      throw new ArgumentError.notNull("operand");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitUnaryExpression(this);
  }

  void visitChildren(AstVisitor visitor) {
    operand.accept(visitor);
  }
}

class VariableDeclaration extends Declaration {
  final VariableDeclarators declarators;

  final TypeSpecification type;

  VariableDeclaration({this.declarators, DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.type})
      : super(metadata: metadata, qualifiers: qualifiers) {
    if (declarators == null) {
      throw new ArgumentError.notNull("declarators");
    }

    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  dynamic accept(AstVisitor visitor) {
    return visitor.visitVariableDeclaration(this);
  }

  void visitChildren(AstVisitor visitor) {
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }

    type.accept(visitor);
    declarators.accept(visitor);
  }
}

class VariableDeclarators extends AstNodeList<Declarator> {
  VariableDeclarators({List<Declarator> elements}) : super(elements: elements);

  dynamic accept(AstVisitor visitor) {
    return visitor.visitVariableDeclarators(this);
  }
}

class VoidTypeSpecification extends TypeSpecification {
  final Identifier identifier;

  VoidTypeSpecification({this.identifier, DeclarationSpecifiers metadata, TypeQualifiers qualifiers})
      : super(metadata: metadata, qualifiers: qualifiers) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }

    if (identifier.name != "void") {
      throw new ArgumentError.value(identifier, "identifier");
    }
  }

  String get name => identifier.name;

  TypeSpecificationKind get typeKind => TypeSpecificationKind.VOID;

  dynamic accept(AstVisitor visitor) {
    return visitor.visitVoidTypeSpecification(this);
  }

  void visitChildren(AstVisitor visitor) {
    identifier.accept(visitor);
    if (metadata != null) {
      metadata.accept(visitor);
    }

    if (qualifiers != null) {
      qualifiers.accept(visitor);
    }
  }
}

class _ListCloner<T> {
  List<T> list;

  String name;

  _ListCloner(List source, this.name, {bool allowNull: false}) {
    var temp = <T>[];
    if (source != null) {
      for (var element in source) {
        var fail = false;
        if (element == null) {
          if (!allowNull) {
            fail = true;
          }
        } else if (element is! T) {
          fail = true;
        }

        if (fail) {
          throw new ArgumentError("The list of the $name contains invalid elements.");
        }

        temp.add(element);
      }
    }

    list = new UnmodifiableListView<T>(temp);
  }
}
