part of binary_declarations;

class ArrayDimensions {
  List<IntegerLiteral> _dimensions;

  ArrayDimensions({List<IntegerLiteral> dimensions}) {
    var list = <IntegerLiteral>[];
    for (var dimension in dimensions) {
      if (dimension == null || dimension is IntegerLiteral) {
        list.add(dimension);
      } else {
        throw new ArgumentError("List of dimensions contains illegal elements.");
      }
    }

    _dimensions = new UnmodifiableListView<IntegerLiteral>(list);
  }

  List<IntegerLiteral> get dimensions => _dimensions;

  String toString() {
    var sb = new StringBuffer();
    sb.write("[");
    var result = <String>[];
    for (var dimension in _dimensions) {
      if (dimension == null) {
        result.add("");
      } else {
        result.add("$dimension");
      }
    }

    sb.write(result.join("]["));
    sb.write("]");
    return sb.toString();
  }
}

class BuiltinTypeSpecification extends TypeSpecification {
  final Identifier identifier;

  final TypeSpecificationKind typeKind;

  BuiltinTypeSpecification({DeclarationSpecifiers metadata, this.identifier, TypeQualifiers qualifiers, this.typeKind}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }

    if (typeKind == null) {
      throw new ArgumentError.notNull("typeKind");
    }

    switch (typeKind) {
      case TypeSpecificationKind.BOOL:
      case TypeSpecificationKind.FLOAT:
      case TypeSpecificationKind.INTEGER:
      case TypeSpecificationKind.VOID:
        break;
      default:
        throw new ArgumentError.value(typeKind, "typeKind");
    }
  }

  String get name => identifier.name;

  String toString() {
    var sb = new StringBuffer();
    sb.write(identifier);
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    if (qualifiers != null) {
      sb.write(" ");
      sb.write(qualifiers);
    }

    return sb.toString();
  }
}

abstract class Declaration {
  final DeclarationSpecifiers metadata;

  final TypeQualifiers qualifiers;

  Declaration({this.metadata, this.qualifiers});
}

class DeclarationModifier {
  final Identifier identifier;

  List<Expression> _arguments;

  DeclarationModifier({List<Expression> arguments, this.identifier}) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }

    var list = [];
    if (arguments != null) {
      for (var value in arguments) {
        if (!(value is! int || value is! String)) {
          throw new ArgumentError("List of the arguments contains invalid elements");
        }

        list.add(value);
      }
    }

    _arguments = new UnmodifiableListView<Expression>(list);
  }

  List<Expression> get arguments => _arguments;

  String toString() {
    var sb = new StringBuffer();
    sb.write(identifier);
    if (!arguments.isEmpty) {
      sb.write("(");
      var list = arguments.map((e) {
        if (e is String) {
          return "\"$e\"";
        } else {
          return e.toString();
        }
      });

      sb.write(list.join(", "));
      sb.write(")");
    }

    return sb.toString();
  }
}

class DeclarationModifiers {
  List<DeclarationModifier> _modifiers;

  DeclarationModifiers({List<DeclarationModifier> modifiers}) {
    if (modifiers == null) {
      throw new ArgumentError.notNull("modifiers");
    }

    _modifiers = new _ListCloner<DeclarationModifier>(modifiers, "values").list;
  }

  List<DeclarationModifier> get modifiers => _modifiers;

  String toString() {
    var sb = new StringBuffer();
    sb.write(_modifiers.join(", "));
    return sb.toString();
  }
}

class DeclarationSpecifier {
  final DeclarationModifiers modifiers;

  DeclarationSpecifier({this.modifiers}) {
    if (modifiers == null) {
      throw new ArgumentError.notNull("modifiers");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write("__attribute__((");
    sb.write(modifiers);
    sb.write("))");
    return sb.toString();
  }
}

class DeclarationSpecifiers {
  List<DeclarationSpecifier> _specifiers;

  DeclarationSpecifiers({List<DeclarationSpecifier> specifiers}) {
    if (specifiers == null) {
      throw new ArgumentError.notNull("specifiers");
    }

    _specifiers = new _ListCloner<DeclarationSpecifier>(specifiers, "specifiers").list;
  }

  List<DeclarationSpecifier> get specifiers => _specifiers;

  String toString() {
    var sb = new StringBuffer();
    sb.write(_specifiers.join(" "));
    return sb.toString();
  }
}

class Declarations extends Object with IterableMixin<Declaration> {
  List<Declaration> _declarations;

  Declarations(String source, {Map<String, String> environment}) {
    if (source == null) {
      throw new ArgumentError.notNull("source");
    }

    if (environment == null) {
      environment = <String, String>{};
    }

    _declarations = <Declaration>[];
    var processor = new MacroProcessor();
    var blocks = processor.process(source, environment);
    var numberOfBlocks = blocks.length;
    if (numberOfBlocks == 0) {
      return;
    }

    var text = blocks.map((e) => e.text).join();
    var parser = new CParser(text);
    var result = parser.parse_Declarations();
    if (!parser.success) {
      var messages = [];
      for (var error in parser.errors()) {
        messages.add(new ParserErrorMessage(error.message, error.start, error.position));
      }

      var strings = ParserErrorFormatter.format(source, messages);
      print(strings.join("\n"));
      throw new FormatException();
    }

    _declarations.addAll(result);
  }

  Iterator<Declaration> get iterator => _declarations.iterator;
}

class Declarator {
  final ArrayDimensions dimensions;

  final PointerSpecifiers functionPointers;

  final Identifier identifier;

  final DeclarationSpecifiers metadata;

  final FunctionParameters parameters;

  final PointerSpecifiers pointers;

  final IntegerLiteral width;

  Declarator({this.dimensions, this.functionPointers, this.identifier, this.metadata, this.parameters, this.pointers, this.width}) {
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
      throw new ArgumentError("Dimensions, identifier, parameters, pointers and width cannot all be null simultaneously");
    }
  }

  bool get isArray => dimensions != null;

  bool get isBitField => width != null;

  bool get isFunction => parameters != null;

  bool get isFunctionPointer => functionPointers != null;

  bool get isPointers => pointers != null;

  String toString() {
    var sb = new StringBuffer();
    var separator = "";
    if (pointers != null) {
      var string = pointers.toString();
      sb.write(string);
      if (string.endsWith("*")) {
        separator = "";
      } else {
        separator = " ";
      }
    }

    if (parameters == null) {
      if (identifier != null) {
        sb.write(separator);
        sb.write(identifier);
        separator = " ";
      }

      if (width != null) {
        sb.write(separator);
        sb.write(": ");
        sb.write(width);
      }

      separator = "";
    } else {
      if (functionPointers != null) {
        sb.write("(");
        sb.write(functionPointers);
        sb.write(identifier);
        sb.write(")");
      } else {
        sb.write(identifier);
      }

      sb.write(parameters);
    }

    if (dimensions != null) {
      sb.write(dimensions);
    }

    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }
}

class DefinedTypeSpecification extends TypeSpecification {
  final Identifier identifier;

  DefinedTypeSpecification({this.identifier, DeclarationSpecifiers metadata, TypeQualifiers qualifiers}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }
  }

  String get name => identifier.name;

  TypeSpecificationKind get typeKind => TypeSpecificationKind.DEFINED;

  String toString() {
    var sb = new StringBuffer();
    sb.write(identifier);
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    if (qualifiers != null) {
      sb.write(" ");
      sb.write(qualifiers);
    }

    return sb.toString();
  }
}

class ElaboratedTypeSpecifier {
  final String kind;

  final DeclarationSpecifiers metadata;

  final Identifier tag;

  String _name;

  ElaboratedTypeSpecifier({this.kind, this.metadata, this.tag}) {
    if (kind == null) {
      throw new ArgumentError.notNull("kind");
    }

    switch (kind) {
      case "enum":
      case "struct":
      case "union":
        break;
      default:
        throw new ArgumentError.value(kind, "kind");
    }

    if (tag == null) {
      _name = kind;
    } else {
      _name = "$kind $tag";
    }
  }

  String get name => _name;

  String toString() {
    var sb = new StringBuffer();
    sb.write(kind);
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    if (tag != null) {
      sb.write(" ");
      sb.write(tag);
    }

    return sb.toString();
  }
}

class EmptyDeclaration extends Declaration {
  String toString() => ";";
}

class EnumDeclaration extends Declaration {
  final EnumTypeSpecification type;

  EnumDeclaration({DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.type}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    if (metadata != null) {
      sb.write(metadata);
      sb.write(" ");
    }

    if (qualifiers != null) {
      sb.write(qualifiers);
      sb.write(" ");
    }

    sb.write(type);
    return sb.toString();
  }
}

class EnumTypeSpecification extends TypeSpecification {
  final ElaboratedTypeSpecifier elaboratedType;

  List<Enumerator> _enumerators;

  EnumTypeSpecification({this.elaboratedType, List<Enumerator> enumerators, DeclarationSpecifiers metadata, TypeQualifiers qualifiers}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (elaboratedType == null) {
      throw new ArgumentError.notNull("elaboratedType");
    }

    if (elaboratedType.kind != "enum") {
      throw new ArgumentError.value(elaboratedType, "elaboratedType");
    }

    _enumerators = new _ListCloner<Enumerator>(enumerators, "values").list;
  }

  List<Enumerator> get enumerators => _enumerators;

  String get name => elaboratedType.name;

  TypeSpecificationKind get typeKind => TypeSpecificationKind.ENUM;

  String toString() {
    var sb = new StringBuffer();
    sb.write(elaboratedType);
    if (!enumerators.isEmpty) {
      sb.write(" { ");
      sb.write(enumerators.join(", "));
      sb.write(" }");
    }

    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    if (qualifiers != null) {
      sb.write(" ");
      sb.write(qualifiers);
    }

    return sb.toString();
  }
}

class Enumerator {
  final Identifier identifier;

  final Expression value;

  Enumerator({this.identifier, this.value}) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write(identifier);
    if (value != null) {
      sb.write(" = ");
      sb.write(value);
    }

    return sb.toString();
  }
}

abstract class Expression {
}

class FunctionDeclaration extends Declaration {
  final Declarator declarator;

  final TypeSpecification type;

  FunctionDeclaration({this.declarator, DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.type}) : super(metadata: metadata, qualifiers: qualifiers) {
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

  String toString() {
    var sb = new StringBuffer();
    var separate = false;
    if (metadata != null) {
      sb.write(metadata);
      separate = true;
    }

    if (qualifiers != null) {
      sb.write(qualifiers);
      sb.write(" ");
    }

    if (type != null) {
      if (separate) {
        sb.write(" ");
      }

      sb.write(type);
      separate = true;
    }

    if (declarator != null) {
      if (separate) {
        sb.write(" ");
      }

      sb.write(declarator);
    }

    return sb.toString();
  }
}

class FunctionParameters {
  List<ParameterDeclaration> _declarations;

  FunctionParameters({List<ParameterDeclaration> declarations}) {
    var list = <ParameterDeclaration>[];
    if (declarations != null) {
      var length = declarations.length;
      for (var i = 0; i < length; i++) {
        var declaration = declarations[i];
        if (declaration == null) {
          throw new ArgumentError("List of declarations contains illegal elements.");
        }

        var type = declaration.type;
        var typeKind = type.typeKind;
        if (_Utils.isVoidType(type, declaration.declarator)) {
          if (i != 0) {
            throw new ArgumentError("Parameter $i should not have a '$type' type.");
          }

          continue;
        } else if (typeKind == TypeSpecificationKind.VA_LIST) {
          if (i != length - 1) {
            throw new ArgumentError("Parameter $i should not have a '$type' type.");
          }
        }

        list.add(declaration);
      }
    }

    _declarations = new UnmodifiableListView<ParameterDeclaration>(list);
  }

  List<ParameterDeclaration> get declarations => _declarations;

  String toString() {
    var sb = new StringBuffer();
    sb.write("(");
    sb.write(declarations.join(", "));
    sb.write(")");
    return sb.toString();
  }
}

class Identifier extends Expression {
  final String name;

  Identifier({this.name}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write(name);
    return sb.toString();
  }
}

class IntegerLiteral extends Literal {
  final int value;

  IntegerLiteral({String text, this.value}) : super(text: text) {
    if (value == null) {
      throw new ArgumentError.notNull("value");
    }
  }
}

abstract class Literal extends Expression {
  final String text;

  Literal({this.text}) {
    if (text == null) {
      throw new ArgumentError.notNull("text");
    }
  }

  dynamic get value;

  String toString() {
    return text;
  }
}

class ParameterDeclaration extends Declaration {
  final Declarator declarator;

  final TypeSpecification type;

  ParameterDeclaration({this.declarator, DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.type}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    if (metadata != null) {
      sb.write(metadata);
      sb.write(" ");
    }

    if (qualifiers != null) {
      sb.write(qualifiers);
      sb.write(" ");
    }

    sb.write(type);
    if (declarator != null) {
      sb.write(" ");
      sb.write(declarator);
    }

    return sb.toString();
  }
}

class PointerSpecifier {
  final DeclarationSpecifiers metadata;

  final TypeQualifiers qualifiers;

  PointerSpecifier({this.metadata, this.qualifiers});

  String toString() {
    var sb = new StringBuffer();
    sb.write("*");
    if (qualifiers != null) {
      sb.write(" ");
      sb.write(qualifiers);
    }

    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }
}

class PointerSpecifiers {
  List<PointerSpecifier> _specifiers;

  PointerSpecifiers({List<PointerSpecifier> specifiers}) {
    if (specifiers == null) {
      throw new ArgumentError.notNull("specifiers");
    }

    if (specifiers.isEmpty) {
      throw new ArgumentError("List of the specifiers cannot be empty");
    }

    _specifiers = new _ListCloner<PointerSpecifier>(specifiers, "pointers").list;
  }

  List<PointerSpecifier> get specifiers => _specifiers;

  String toString() {
    var sb = new StringBuffer();
    var separator = "";
    for (var specifier in specifiers) {
      var string = specifier.toString();
      sb.write(separator);
      sb.write(string);
      if (!string.endsWith("*")) {
        separator = " ";
      }
    }

    return sb.toString();
  }
}

class StringLiteral extends Literal {
  final String value;

  StringLiteral({String text, this.value}) : super(text: text) {
    if (value == null) {
      throw new ArgumentError.notNull("value");
    }
  }
}

class StructureDeclaration extends Declaration {
  final StructureTypeSpecification type;

  StructureDeclaration({DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.type}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    if (metadata != null) {
      sb.write(metadata);
      sb.write(" ");
    }

    if (qualifiers != null) {
      sb.write(qualifiers);
      sb.write(" ");
    }

    sb.write(type);
    return sb.toString();
  }
}

class StructureTypeSpecification extends TypeSpecification {
  final ElaboratedTypeSpecifier elaboratedType;

  List<ParameterDeclaration> _members;

  StructureTypeSpecification({this.elaboratedType, DeclarationSpecifiers metadata, TypeQualifiers qualifiers, List<ParameterDeclaration> members}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (elaboratedType == null) {
      throw new ArgumentError.notNull("elaboratedType");
    }

    switch (elaboratedType.kind) {
      case "struct":
      case "union":
        break;
      default:
        throw new ArgumentError.value(elaboratedType, "elaboratedType");
    }

    _members = new _ListCloner<ParameterDeclaration>(members, "members").list;
  }

  List<ParameterDeclaration> get members => _members;

  String get name => elaboratedType.name;

  TypeSpecificationKind get typeKind => TypeSpecificationKind.STRUCTURE;

  String toString() {
    var sb = new StringBuffer();
    sb.write(elaboratedType);
    if (!members.isEmpty) {
      sb.write(" { ");
      for (var member in members) {
        sb.write(member);
        sb.write("; ");
      }

      sb.write("}");
    }

    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    if (qualifiers != null) {
      sb.write(" ");
      sb.write(qualifiers);
    }

    return sb.toString();
  }
}

class TypeQualifier {
  final Identifier identifier;

  final DeclarationSpecifiers metadata;

  TypeQualifier({this.identifier, this.metadata}) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write(identifier);
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }
}

class TypeQualifiers {
  List<TypeQualifier> _qualifiers;

  TypeQualifiers({List<TypeQualifier> qualifiers}) {
    _qualifiers = new _ListCloner<TypeQualifier>(qualifiers, "qualifiers").list;
  }

  List<TypeQualifier> get qualifiers => _qualifiers;

  String toString() {
    return _qualifiers.join(" ");
  }
}

abstract class TypeSpecification {
  final DeclarationSpecifiers metadata;

  final TypeQualifiers qualifiers;

  TypeSpecification({this.metadata, this.qualifiers});

  String get name;

  TypeSpecificationKind get typeKind;
}

class TypeSpecificationKind {
  static const TypeSpecificationKind BOOL = const TypeSpecificationKind("BOOL");

  static const TypeSpecificationKind DEFINED = const TypeSpecificationKind("DEFINED");

  static const TypeSpecificationKind ENUM = const TypeSpecificationKind("ENUM");

  static const TypeSpecificationKind FLOAT = const TypeSpecificationKind("FLOAT");

  static const TypeSpecificationKind INTEGER = const TypeSpecificationKind("INTEGER");

  static const TypeSpecificationKind STRUCTURE = const TypeSpecificationKind("STRUCTURE");

  static const TypeSpecificationKind VA_LIST = const TypeSpecificationKind("VA_LIST");

  static const TypeSpecificationKind VOID = const TypeSpecificationKind("VOID");

  final String _name;

  const TypeSpecificationKind(this._name);

  String toString() => _name;
}

class TypedefDeclaration extends Declaration {
  final TypeSpecification type;

  final TypedefSpecifier typedef;

  List<Declarator> _declarators;

  TypedefDeclaration({List<Declarator> declarators, DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.type, this.typedef}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (declarators == null) {
      throw new ArgumentError.notNull("declarators");
    }

    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    if (typedef == null) {
      throw new ArgumentError.notNull("typedef");
    }

    _declarators = new _ListCloner<Declarator>(declarators, "declarators").list;
  }

  List<Declarator> get declarators => _declarators;

  String toString() {
    var sb = new StringBuffer();
    if (metadata != null) {
      sb.write(metadata);
      sb.write(" ");
    }

    if (qualifiers != null) {
      sb.write(qualifiers);
      sb.write(" ");
    }

    sb.write(typedef);
    sb.write(" ");
    sb.write(type);
    sb.write(" ");
    sb.write(declarators.join(", "));
    return sb.toString();
  }
}

class TypedefSpecifier {
  final DeclarationSpecifiers metadata;

  final TypeQualifiers qualifiers;

  TypedefSpecifier({this.metadata, this.qualifiers});

  String toString() {
    var sb = new StringBuffer();
    sb.write("typedef");
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    if (qualifiers != null) {
      sb.write(" ");
      sb.write(qualifiers);
    }

    return sb.toString();
  }
}

class VaListTypeSpecification extends TypeSpecification {
  String get name => "...";

  TypeSpecificationKind get typeKind => TypeSpecificationKind.VA_LIST;

  String toString() => "...";
}

class VariableDeclaration extends Declaration {
  final TypeSpecification type;

  List<Declarator> _declarators;

  VariableDeclaration({List<Declarator> declarators, DeclarationSpecifiers metadata, TypeQualifiers qualifiers, this.type}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (declarators == null) {
      throw new ArgumentError.notNull("declarators");
    }

    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    _declarators = new _ListCloner<Declarator>(declarators, "declarators").list;
  }

  List<Declarator> get declarators => _declarators;

  String toString() {
    var sb = new StringBuffer();
    if (metadata != null) {
      sb.write(metadata);
      sb.write(" ");
    }

    if (qualifiers != null) {
      sb.write(qualifiers);
      sb.write(" ");
    }

    sb.write(type);
    sb.write(" ");
    sb.write(declarators.join(", "));
    return sb.toString();
  }
}

class _ListCloner<T> {
  List<T> list;

  String name;

  _ListCloner(List source, this.name) {
    var temp = <T>[];
    if (source != null) {
      for (var element in source) {
        if (element is! T) {
          throw new ArgumentError("The list of $name contains invalid elements.");
        }

        temp.add(element);
      }
    }

    list = new UnmodifiableListView<T>(temp);
  }
}

class _Utils {
  static bool isVoidType(TypeSpecification type, Declarator declarator) {
    if (type == null) {
      return false;
    }

    if (type.typeKind == TypeSpecificationKind.VOID) {
      if (declarator == null || declarator.pointers == null) {
        return true;
      }
    }

    return false;
  }
}
