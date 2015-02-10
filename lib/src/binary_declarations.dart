part of binary_declarations;

class ArrayDimensions {
  List<int> _dimensions;

  ArrayDimensions({List<int> dimensions}) {
    var list = <int>[];
    for (var dimension in dimensions) {
      if (dimension == null || (dimension is int && dimension > 0)) {
        list.add(dimension);
      } else {
        throw new ArgumentError("List of dimensions contains illegal elements.");
      }
    }

    _dimensions = new UnmodifiableListView<int>(list);
  }

  List<int> get dimensions => _dimensions;

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

class ArrayTypeSpecification extends TypeSpecification {
  final ArrayDimensions dimensions;

  final TypeSpecification type;

  ArrayTypeSpecification({this.dimensions, Metadata metadata, this.type}) : super(metadata: metadata) {
    if (dimensions == null) {
      throw new ArgumentError.notNull("dimensions");
    }
  }

  String get name {
    var sb = new StringBuffer();
    sb.write(type.name);
    sb.write(dimensions);
    return sb.toString();
  }

  TypeSpecificationKind get typeKind => TypeSpecificationKind.ARRAY;

  String toString() {
    var sb = new StringBuffer();
    sb.write(type);
    sb.write(dimensions);
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }

  String toStringWithIdentifier(String identifier) {
    var sb = new StringBuffer();
    sb.write(_Utils.qualifiersToString(qualifiers));
    sb.write(type);
    if (identifier != null) {
      sb.write(" ");
      sb.write(identifier);
    }

    sb.write(dimensions);
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }
}

class Attribute {
  final String name;

  List<dynamic> _parameters;

  Attribute(this.name, [List<dynamic> parameters]) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value(name, "name");
    }

    var list = [];
    if (parameters != null) {
      for (var value in parameters) {
        list.add(value);
      }
    }

    _parameters = new UnmodifiableListView<dynamic>(list);
  }

  List<dynamic> get parameters => _parameters;

  String toString() {
    var sb = new StringBuffer();
    sb.write(name);
    if (!parameters.isEmpty) {
      sb.write("(");
      var list = parameters.map((e) {
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

class AttributeList {
  List<Attribute> _attributes;

  AttributeList(List<Attribute> values) {
    _attributes = new _ListCloner<Attribute>(values, "values").list;
  }

  List<Attribute> get attributes => _attributes;

  String toString() {
    var sb = new StringBuffer();
    sb.write("__attribute__((");
    sb.write(_attributes.join(", "));
    sb.write("))");
    return sb.toString();
  }
}

abstract class Declaration {
  final Metadata metadata;

  Declaration({this.metadata});
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

class DefinedTypeSpecification extends TypeSpecification {
  final String name;

  DefinedTypeSpecification({Metadata metadata, this.name, TypeQualifierList qualifiers}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value(name, "name");
    }
  }

  TypeSpecificationKind get typeKind => TypeSpecificationKind.DEFINED;

  String toString() {
    var sb = new StringBuffer();
    sb.write(_Utils.qualifiersToString(qualifiers));
    sb.write(name);
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }
}

class ElaboratedTypeSpecifier {
  final String kind;

  final Metadata metadata;

  final Identifier tag;

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
  }

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

  EnumDeclaration({Metadata metadata, this.type}) : super(metadata: metadata) {
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

    sb.write(type);
    return sb.toString();
  }
}

class EnumTypeSpecification extends TypeSpecification {
  final ElaboratedTypeSpecifier elaboratedType;

  List<EnumValueDeclaration> _values;

  EnumTypeSpecification({this.elaboratedType, Metadata metadata, List<EnumValueDeclaration> values}) : super(metadata: metadata) {
    if (elaboratedType == null) {
      throw new ArgumentError.notNull("elaboratedType");
    }

    if (elaboratedType.kind != "enum") {
      throw new ArgumentError.value(elaboratedType, "elaboratedType");
    }

    _values = new _ListCloner<EnumValueDeclaration>(values, "values").list;
  }

  String get name => elaboratedType.kind;

  TypeSpecificationKind get typeKind => TypeSpecificationKind.ENUM;

  List<EnumValueDeclaration> get values => _values;

  String toString() {
    var sb = new StringBuffer();
    sb.write(elaboratedType);
    if (!values.isEmpty) {
      sb.write(" { ");
      sb.write(values.join(", "));
      sb.write(" }");
    }

    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }
}

class EnumValueDeclaration extends Declaration {
  final String name;

  final int value;

  EnumValueDeclaration({this.name, this.value}) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value(name, "name");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write(name);
    if (value != null) {
      sb.write(" = ");
      sb.write(value);
    }

    return sb.toString();
  }
}

class FloatTypeSpecification extends TypeSpecification {
  final String name;

  FloatTypeSpecification({Metadata metadata, this.name, TypeQualifierList qualifiers}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value(name, "name");
    }
  }

  TypeSpecificationKind get typeKind => TypeSpecificationKind.FLOAT;

  String toString() {
    var sb = new StringBuffer();
    sb.write(_Utils.qualifiersToString(qualifiers));
    sb.write(name);
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }
}

class FunctionDeclaration extends Declaration {
  final FunctionTypeSpecification type;

  FunctionDeclaration({Metadata metadata, this.type}) : super(metadata: metadata) {
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

    sb.write(type);
    return sb.toString();
  }
}

class FunctionParameters {
  final Metadata metadata;

  List<ParameterDeclaration> _parameters;

  FunctionParameters({this.metadata, List<ParameterDeclaration> parameters}) {
    var list = <ParameterDeclaration>[];
    if (parameters != null) {
      var length = parameters.length;
      for (var i = 0; i < length; i++) {
        var parameter = parameters[i];
        if (parameter == null) {
          throw new ArgumentError("List of parameters contains illegal elements.");
        }

        var type = parameter.type;
        if (type is VoidTypeSpecification) {
          if (i != 0) {
            throw new ArgumentError("Parameter $i should not have a '$type' type.");
          }

          continue;
        } else if (type is VaListTypeSpecification) {
          if (i != length - 1) {
            throw new ArgumentError("Parameter $i should not have a '$type' type.");
          }
        }

        list.add(parameter);
      }
    }

    _parameters = new UnmodifiableListView<ParameterDeclaration>(list);
  }

  List<ParameterDeclaration> get parameters => _parameters;

  String toString() {
    var sb = new StringBuffer();
    sb.write("(");
    sb.write(parameters.join(", "));
    sb.write(")");
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }
}

class FunctionTypeSpecification extends TypeSpecification {
  final Identifier identifier;

  final TypeSpecification returnType;

  final FunctionParameters parameters;

  FunctionTypeSpecification({this.identifier, Metadata metadata, this.parameters, this.returnType}) : super(metadata: metadata) {
    if (identifier == null) {
      throw new ArgumentError.notNull("identifier");
    }

    if (parameters == null) {
      throw new ArgumentError.notNull("parameters");
    }
  }

  String get name => identifier.name;

  TypeSpecificationKind get typeKind => TypeSpecificationKind.FUNCTION;

  String toString() {
    var sb = new StringBuffer();
    if (returnType != null) {
      sb.write(returnType);
      sb.write(" ");
    }

    sb.write(identifier);
    sb.write(parameters);
    if (metadata != null) {
      sb.write(metadata);
      sb.write(" ");
    }

    return sb.toString();
  }
}

class Identifier extends Declaration {
  final Metadata metadata;

  final String name;

  Identifier({this.metadata, this.name}) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value(name, "name");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write(name);
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }
}

class IntegerTypeSpecification extends TypeSpecification {
  final String name;

  IntegerTypeSpecification({Metadata metadata, this.name, TypeQualifierList qualifiers}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value(name, "name");
    }
  }

  TypeSpecificationKind get typeKind => TypeSpecificationKind.INTEGER;

  String toString() {
    var sb = new StringBuffer();
    sb.write(_Utils.qualifiersToString(qualifiers));
    sb.write(name);
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }
}

class Metadata {
  List<AttributeList> _attributeList;

  Metadata(List<AttributeList> attributeList) {
    if (attributeList != null) {
      _attributeList = new _ListCloner<AttributeList>(attributeList, "attributeList").list;
    } else {
      _attributeList = const <AttributeList>[];
    }
  }

  List<AttributeList> get attributeList => _attributeList;

  String toString() {
    var sb = new StringBuffer();
    sb.write(_attributeList.join(" "));
    return sb.toString();
  }
}

class ParameterDeclaration extends Declaration {
  final Identifier identifier;

  final TypeSpecification type;

  final int width;

  ParameterDeclaration({this.identifier, Metadata metadata, this.type, this.width}) : super(metadata: metadata) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    if (width != null && width < 0) {
      throw new ArgumentError.value(width, "width");
    }
  }

  bool get isBitField => width != null;

  String toString() {
    var sb = new StringBuffer();
    if (identifier != null) {
      sb.write(type.toStringWithIdentifier(identifier.toString()));
    } else {
      sb.write(type);
    }

    if (isBitField) {
      sb.write(" : ");
      sb.write(width);
    }

    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }
}

class PointerTypeSpecification extends TypeSpecification {
  final TypeSpecification type;

  PointerTypeSpecification({Metadata metadata, TypeQualifierList qualifiers, this.type}) : super(metadata: metadata, qualifiers: qualifiers) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String get name {
    var sb = new StringBuffer();
    if (type.typeKind == TypeSpecificationKind.ARRAY) {
      sb.write(type.toStringWithIdentifier("${type.name}*"));
    } else {
      sb.write(type.name);
      sb.write("*");
    }

    return sb.toString();
  }

  TypeSpecificationKind get typeKind => TypeSpecificationKind.POINTER;

  String toString() {
    var sb = new StringBuffer();
    if (type.typeKind == TypeSpecificationKind.ARRAY) {
      sb.write(type.toStringWithIdentifier("${type}*"));
    } else {
      sb.write(type);
      sb.write("*");
    }

    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

    return sb.toString();
  }
}

class StructureDeclaration extends Declaration {
  final StructureTypeSpecification type;

  StructureDeclaration({Metadata metadata, this.type}) : super(metadata: metadata) {
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

    sb.write(type);
    return sb.toString();
  }
}

class StructureTypeSpecification extends TypeSpecification {
  final ElaboratedTypeSpecifier elaboratedType;

  List<ParameterDeclaration> _members;

  StructureTypeSpecification({this.elaboratedType, Metadata metadata, List<ParameterDeclaration> members}) : super(metadata: metadata) {
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

  String get name => elaboratedType.toString();

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

    return sb.toString();
  }
}

class TaggedTypeKinds {
  static const TaggedTypeKinds ENUM = const TaggedTypeKinds("enum");

  static const TaggedTypeKinds STRUCT = const TaggedTypeKinds("struct");

  static const TaggedTypeKinds UNION = const TaggedTypeKinds("union");

  final String name;

  const TaggedTypeKinds(this.name);

  String toString() => name;
}

class TypeQualifierList {
  List<String> _qualifiers;

  TypeQualifierList(List<String> qualifiers) {
    _qualifiers = new _ListCloner<String>(qualifiers, "name").list;
  }

  List<String> get qualifiers => _qualifiers;

  String toString() {
    return _qualifiers.join(" ");
  }
}

abstract class TypeSpecification {
  final Metadata metadata;

  TypeQualifierList _qualifiers;

  TypeSpecification({this.metadata, TypeQualifierList qualifiers}) {
    if (qualifiers == null) {
      qualifiers = new TypeQualifierList(const <String>[]);
    }

    _qualifiers = qualifiers;
  }

  String get name;

  TypeQualifierList get qualifiers => _qualifiers;

  TypeSpecificationKind get typeKind;

  String toStringWithIdentifier(String identifier) {
    var sb = new StringBuffer();
    sb.write(this);
    if (identifier != null) {
      sb.write(" ");
      sb.write(identifier);
    }

    return sb.toString();
  }
}

class TypeSpecificationKind {
  static const TypeSpecificationKind ARRAY = const TypeSpecificationKind("ARRAY");

  static const TypeSpecificationKind DEFINED = const TypeSpecificationKind("DEFINED");

  static const TypeSpecificationKind ENUM = const TypeSpecificationKind("ENUM");

  static const TypeSpecificationKind FLOAT = const TypeSpecificationKind("FLOAT");

  static const TypeSpecificationKind FUNCTION = const TypeSpecificationKind("FUNCTION");

  static const TypeSpecificationKind INTEGER = const TypeSpecificationKind("INTEGER");

  static const TypeSpecificationKind POINTER = const TypeSpecificationKind("POINTER");

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

  List<TypeSpecification> _synonyms;

  TypedefDeclaration({Metadata metadata, List<TypeSpecification> synonyms, this.type, this.typedef}) : super(metadata: metadata) {
    if (synonyms == null) {
      throw new ArgumentError.notNull("synonyms");
    }

    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    if (typedef == null) {
      throw new ArgumentError.notNull("typedef");
    }

    _synonyms = new _ListCloner<TypeSpecification>(synonyms, "synonyms").list;

    for (var synonym in _synonyms) {
      if (!(synonym is ArrayTypeSpecification || synonym is DefinedTypeSpecification || synonym is FunctionTypeSpecification || synonym is PointerTypeSpecification)) {
        throw new ArgumentError("The list of synonyms contains invalid elements");
      }
    }
  }

  List<TypeSpecification> get synonyms => _synonyms;

  String toString() {
    var sb = new StringBuffer();
    if (metadata != null) {
      sb.write(metadata);
      sb.write(" ");
    }

    sb.write(typedef);
    sb.write(" ");
    sb.write(type);
    sb.write(" ");
    sb.write(synonyms.map((e) => _synonymToString(e)).join(", "));
    return sb.toString();
  }

  String _synonymToString(TypeSpecification synonym) {
    switch (synonym.typeKind) {
      case TypeSpecificationKind.DEFINED:
        var sb = new StringBuffer();
        sb.write(synonym);
        return sb.toString();
      case TypeSpecificationKind.POINTER:
        var pointerType = synonym as PointerTypeSpecification;
        var sb = new StringBuffer();
        sb.write(_Utils.qualifiersToString(pointerType.qualifiers));
        sb.write("*");
        var metatada = pointerType.metadata;
        if (metatada != null) {
          sb.write(" ");
          sb.write(metatada);
          sb.write(" ");
        }

        sb.write(_synonymToString(pointerType.type));
        return sb.toString();
      case TypeSpecificationKind.ARRAY:
        var arrayType = synonym as ArrayTypeSpecification;
        var sb = new StringBuffer();
        sb.write(_synonymToString(arrayType.type));
        sb.write(arrayType.dimensions);
        return sb.toString();
      case TypeSpecificationKind.FUNCTION:
        var sb = new StringBuffer();
        sb.write(synonym);
        return sb.toString();
      default:
        return "<invalid>";
    }
  }
}

class TypedefSpecifier {
  final Metadata metadata;

  TypedefSpecifier({this.metadata});

  String toString() {
    var sb = new StringBuffer();
    sb.write("typedef");
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
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
  final Identifier identifier;

  final TypeSpecification type;

  VariableDeclaration({this.identifier, Metadata metadata, this.type}) : super(metadata: metadata) {
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

    sb.write(type.toStringWithIdentifier(identifier.toString()));
    return sb.toString();
  }
}

class VoidTypeSpecification extends TypeSpecification {
  VoidTypeSpecification({Metadata metadata, TypeQualifierList qualifiers}) : super(metadata: metadata, qualifiers: qualifiers);

  String get name => "void";

  TypeSpecificationKind get typeKind => TypeSpecificationKind.VOID;

  String toString() {
    var sb = new StringBuffer();
    sb.write(_Utils.qualifiersToString(qualifiers));
    sb.write("void");
    if (metadata != null) {
      sb.write(" ");
      sb.write(metadata);
    }

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
  static String qualifiersToString(TypeQualifierList qualifiers) {
    if (qualifiers == null || qualifiers.qualifiers.isEmpty) {
      return "";
    }

    var sb = new StringBuffer();
    sb.write(qualifiers);
    sb.write(" ");
    return sb.toString();
  }
}
