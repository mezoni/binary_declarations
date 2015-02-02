part of binary_declarations;

class ArrayTypeSpecification extends TypeSpecification {
  List<int> _dimensions;

  final TypeSpecification type;

  ArrayTypeSpecification({AttributeSpecifications attributes, bool isConst, List<int> dimensions, this.type}) : super(attributes: attributes, isConst: isConst) {
    if (dimensions == null) {
      throw new ArgumentError.notNull("dimensions");
    }

    var list = <int>[];
    for (var dimension in dimensions) {
      if (dimension == null || dimension is int) {
        list.add(dimension);
      } else {
        throw new ArgumentError("List of dimension contains illegal elements.");
      }
    }

    _dimensions = new UnmodifiableListView<int>(list);
  }

  List<int> get dimensions => _dimensions;

  String toString() {
    var sb = new StringBuffer();
    sb.write(type);
    sb.write(_dimensionsToString());
    return sb.toString();
  }

  String toStringWithIdentifier(String identifier) {
    var sb = new StringBuffer();
    sb.write(type);
    if (identifier != null) {
      sb.write(" ");
      sb.write(identifier);
    }

    sb.write(_dimensionsToString());
    return sb.toString();
  }

  String _dimensionsToString() {
    var sb = new StringBuffer();
    sb.write("[");
    var result = <String>[];
    for (var length in dimensions) {
      if (length == null) {
        result.add("");
      } else {
        result.add("$length");
      }
    }

    sb.write(result.join("]["));
    sb.write("]");
    return sb.toString();
  }
}

class AttributeSpecification {
  List<BinaryAttribute> _values;

  AttributeSpecification(List<BinaryAttribute> values) {
    _values = new _ListCloner<BinaryAttribute>(values, "values").list;
  }

  List<BinaryAttribute> get values => _values;

  String toString() {
    var sb = new StringBuffer();
    sb.write("__attribute__((");
    sb.write(_values.join(", "));
    sb.write("))");
    return sb.toString();
  }
}

class AttributeSpecifications {
  List<AttributeSpecification> _attributes;

  AttributeSpecifications(List<AttributeSpecification> attributes) {
    if (attributes != null) {
      _attributes = new _ListCloner<AttributeSpecification>(attributes, "attributes").list;
    } else {
      _attributes = const <AttributeSpecification>[];
    }
  }

  List<AttributeSpecification> get attributes => _attributes;

  String toString() {
    var sb = new StringBuffer();
    sb.write(_attributes.join(" "));
    return sb.toString();
  }
}

class BinaryAttribute {
  final String name;

  List<String> _parameters;

  BinaryAttribute(this.name, [List parameters]) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    var list = <String>[];
    if (parameters != null) {
      for (var value in parameters) {
        list.add(value.toString());
      }
    }

    _parameters = new UnmodifiableListView<String>(list);
  }

  List<String> get parameters => _parameters;

  String toString() {
    var sb = new StringBuffer();
    sb.write(name);
    if (!parameters.isEmpty) {
      sb.write("(");
      sb.write(parameters.join(", "));
      sb.write(")");
    }

    return sb.toString();
  }
}

abstract class BinaryDeclaration {
  final AttributeSpecifications attributes;

  BinaryDeclaration({this.attributes});
}

class BinaryDeclarations extends Object with IterableMixin<BinaryDeclaration> {
  List<BinaryDeclaration> _declarations;

  BinaryDeclarations(String source, {Map<String, String> environment}) {
    if (source == null) {
      throw new ArgumentError.notNull("source");
    }

    if (environment == null) {
      environment = <String, String>{};
    }

    _declarations = <BinaryDeclaration>[];
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

  Iterator<BinaryDeclaration> get iterator => _declarations.iterator;
}

class EmptyDeclaration extends BinaryDeclaration {
  String toString() => ";";
}

class EnumDeclaration extends BinaryDeclaration {
  EnumTypeSpecification _type;

  EnumDeclaration({AttributeSpecifications attributes, TaggedTypeSpecification taggedType, List<EnumValueDeclaration> values}) : super(attributes: attributes) {
    _type = new EnumTypeSpecification(attributes: attributes, values: values, taggedType: taggedType);
  }

  EnumTypeSpecification get type => _type;

  String toString() {
    var sb = new StringBuffer();
    sb.write(type);
    return sb.toString();
  }
}

class EnumTypeSpecification extends TypeSpecification {
  final TaggedTypeSpecification taggedType;

  List<EnumValueDeclaration> _values;

  EnumTypeSpecification({AttributeSpecifications attributes, this.taggedType, List<EnumValueDeclaration> values}) : super(attributes: attributes) {
    if (taggedType == null) {
      throw new ArgumentError.notNull("taggedType");
    }

    if (taggedType.kind != TaggedTypeKinds.ENUM) {
      throw new ArgumentError.value(taggedType, "taggedType");
    }

    if (values == null) {
      throw new ArgumentError.notNull("values");
    }

    _values = new _ListCloner<EnumValueDeclaration>(values, "values").list;
  }

  List<EnumValueDeclaration> get values => _values;

  String toString() {
    var sb = new StringBuffer();
    sb.write(taggedType);
    sb.write(" { ");
    sb.write(values.join(", "));
    sb.write(" }");
    if (attributes != null) {
      sb.write(" ");
      sb.write(attributes);
    }

    return sb.toString();
  }
}

class EnumValueDeclaration extends BinaryDeclaration {
  final String name;

  final int value;

  EnumValueDeclaration({this.name, this.value}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
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

  FloatTypeSpecification({AttributeSpecifications attributes, this.name, bool isConst}) : super(attributes: attributes, isConst: isConst) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write(name);
    if (attributes != null) {
      sb.write(" ");
      sb.write(attributes);
    }

    return sb.toString();
  }
}

class FunctionDeclaration extends BinaryDeclaration {
  final String name;

  final TypeSpecification returnType;

  List<ParameterDeclaration> _parameters;

  FunctionDeclaration({AttributeSpecifications attributes, this.name, List<ParameterDeclaration> parameters, this.returnType}) : super(attributes: attributes) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value(name, "name");
    }

    if (returnType == null) {
      throw new ArgumentError.value(returnType, "returnType");
    }

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
    if (returnType != null) {
      sb.write(returnType);
      sb.write(" ");
    }

    sb.write(name);
    sb.write("(");
    if (parameters != null) {
      sb.write(parameters.join(", "));
    }

    sb.write(")");
    if (attributes != null) {
      sb.write(" ");
      sb.write(attributes);
    }

    return sb.toString();
  }
}

class IntegerTypeSpecification extends TypeSpecification {
  final String name;

  IntegerTypeSpecification({AttributeSpecifications attributes, bool isConst, this.name}) : super(attributes: attributes, isConst: isConst) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write(name);
    if (attributes != null) {
      sb.write(" ");
      sb.write(attributes);
    }

    return sb.toString();
  }
}

class ParameterDeclaration extends BinaryDeclaration {
  final String name;

  final TypeSpecification type;

  final int width;

  ParameterDeclaration({AttributeSpecifications attributes, this.name, this.type, this.width}) : super(attributes: attributes) {
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
    sb.write(type.toStringWithIdentifier(name));
    if (isBitField) {
      sb.write(" : ");
      sb.write(width);
    }

    if (attributes != null) {
      sb.write(" ");
      sb.write(attributes);
    }

    return sb.toString();
  }
}

class PointerTypeSpecification extends TypeSpecification {
  final TypeSpecification type;

  PointerTypeSpecification({AttributeSpecifications attributes, this.type}) : super(attributes: attributes) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() => "$type*";
}

class StructureDeclaration extends BinaryDeclaration {
  StructureTypeSpecification _type;

  StructureDeclaration({AttributeSpecifications attributes, List<ParameterDeclaration> members, TaggedTypeSpecification taggedType}) : super(attributes: attributes) {
    _type = new StructureTypeSpecification(attributes: attributes, members: members, taggedType: taggedType);
  }

  StructureTypeSpecification get type => _type;

  String toString() {
    var sb = new StringBuffer();
    sb.write(type);
    return sb.toString();
  }
}

class StructureTypeSpecification extends TypeSpecification {
  final TaggedTypeSpecification taggedType;

  List<ParameterDeclaration> _members;

  StructureTypeSpecification({AttributeSpecifications attributes, List<ParameterDeclaration> members, this.taggedType}) : super(attributes: attributes) {
    if (taggedType == null) {
      throw new ArgumentError.notNull("taggedType");
    }

    switch (taggedType.kind) {
      case TaggedTypeKinds.STRUCT:
      case TaggedTypeKinds.UNION:
        break;
      default:
        throw new ArgumentError.value(taggedType, "taggedType");
    }

    _members = new _ListCloner<ParameterDeclaration>(members, "members").list;
  }

  List<ParameterDeclaration> get members => _members;

  String toString() {
    var sb = new StringBuffer();
    sb.write(taggedType);
    sb.write(" { ");
    if (!members.isEmpty) {
      for (var member in members) {
        sb.write(member);
        sb.write("; ");
      }
    }

    sb.write("}");
    if (attributes != null) {
      sb.write(" ");
      sb.write(attributes);
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

class TaggedTypeSpecification extends TypeSpecification {
  final String tag;

  TaggedTypeKinds _kind;

  String _name;

  TaggedTypeSpecification({AttributeSpecifications attributes, String kind, bool isConst, this.tag}) : super(attributes: attributes, isConst: isConst) {
    if (kind == null) {
      throw new ArgumentError.notNull("kind");
    }

    switch (kind) {
      case "enum":
        _kind = TaggedTypeKinds.ENUM;
        break;
      case "struct":
        _kind = TaggedTypeKinds.STRUCT;
        break;
      case "union":
        _kind = TaggedTypeKinds.UNION;
        break;
      default:
        throw new ArgumentError.value(kind, "kind");
    }

    var sb = new StringBuffer();
    sb.write(_kind);
    if (tag != null) {
      sb.write(" ");
      sb.write(tag);
    }

    _name = sb.toString();
  }

  TaggedTypeKinds get kind => _kind;

  String get name => _name;

  String toString() {
    var sb = new StringBuffer();
    sb.write(kind);
    if (attributes != null) {
      sb.write(" ");
      sb.write(attributes);
    }

    if (tag != null) {
      sb.write(" ");
      sb.write(tag);
    }

    return sb.toString();
  }
}

abstract class TypeSpecification {
  final AttributeSpecifications attributes;

  bool _isConst;

  TypeSpecification({this.attributes, bool isConst}) {
    if (isConst == null) {
      isConst = false;
    }

    _isConst = isConst;
  }

  bool get isConst => _isConst;

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

class TypedefDeclaration extends BinaryDeclaration {
  final AttributeSpecifications attributes;

  final String name;

  final TypeSpecification type;

  TypedefDeclaration({this.attributes, this.name, this.type}) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value(name, "name");
    }

    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write("typedef ");
    if (type is ArrayTypeSpecification) {
      var arrayType = type;
      sb.write(arrayType.type);
      sb.write(" ");
      sb.write(name);
      sb.write(arrayType._dimensionsToString());
    } else {
      sb.write(type);
      sb.write(" ");
      sb.write(name);
    }

    if (attributes != null) {
      sb.write(" ");
      sb.write(attributes);
    }

    return sb.toString();
  }
}

class TypedefTypeSpecification extends TypeSpecification {
  final String name;

  TypedefTypeSpecification({AttributeSpecifications attributes, bool isConst, this.name}) : super(attributes: attributes, isConst: isConst) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value(name, "name");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write(name);
    if (attributes != null) {
      sb.write(" ");
      sb.write(attributes);
    }

    return sb.toString();
  }
}

class VaListTypeSpecification extends TypeSpecification {
  String toString() => "...";
}

class VariableDeclaration extends BinaryDeclaration {
  final String name;

  final TypeSpecification type;

  VariableDeclaration({AttributeSpecifications attributes, this.name, this.type}) : super(attributes: attributes) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write(type.toStringWithIdentifier(name));
    if (attributes != null) {
      sb.write(" ");
      sb.write(attributes);
    }

    return sb.toString();
  }
}

class VoidTypeSpecification extends TypeSpecification {
  VoidTypeSpecification({AttributeSpecifications attributes, bool isConst}) : super(attributes: attributes, isConst: isConst);

  String toString() {
    var sb = new StringBuffer();
    sb.write("void");
    if (attributes != null) {
      sb.write(" ");
      sb.write(attributes);
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
