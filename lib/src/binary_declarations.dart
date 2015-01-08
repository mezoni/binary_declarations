part of binary_declarations;

class ArrayTypeSpecification extends TypeSpecification {
  List<int> _dimensions;

  final TypeSpecification type;

  ArrayTypeSpecification({BinaryAttributes attributes, List<int> dimensions, this.type}) : super(attributes: attributes) {
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

class BinaryAttributes {
  List<BinaryAttribute> _values;

  BinaryAttributes(List<BinaryAttribute> values) {
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

abstract class BinaryDeclaration {
}

class BinaryDeclarations extends Object with IterableMixin<BinaryDeclaration> {
  List<BinaryDeclaration> _declarations;

  BinaryDeclarations(String text) {
    var parser = new CParser(text);
    var result = parser.parse_Declarations();
    if (!parser.success) {
      var text = new Text(parser.text);
      for (var error in parser.errors()) {
        var position = error.position;
        var location = "EOF";
        if (position < text.length) {
          location = text.locationAt(error.position);
        }

        var message = "Parser error at $location. ${error.message}";
        print(message);
      }

      throw new FormatException();
    }

    _declarations = <BinaryDeclaration>[];
    _declarations.addAll(result);
  }

  Iterator<BinaryDeclaration> get iterator => _declarations.iterator;
}

class EmptyDeclaration extends BinaryDeclaration {
  String toString() => ";";
}

class FloatTypeSpecification extends TypeSpecification {
  final String kind;

  FloatTypeSpecification({BinaryAttributes attributes, this.kind}) : super(attributes: attributes) {
    switch (kind) {
      case "double":
      case "float":
        break;
      default:
        throw new ArgumentError.value("kind", kind);
    }
  }

  String toString() => kind;
}

class FunctionDeclaration extends BinaryDeclaration {
  final String name;

  final TypeSpecification returnType;

  List<ParameterDeclaration> _parameters;

  FunctionDeclaration({this.name, List<ParameterDeclaration> parameters, this.returnType}) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value("name", name);
    }

    var list = <ParameterDeclaration>[];
    if (parameters != null) {
      list.addAll(parameters);
      if (list.length == 1) {
        var first = list.first;
        if (first.type is VoidTypeSpecification) {
          list.removeAt(0);
        }
      }
    }

    _parameters = new UnmodifiableListView(list);
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
    return sb.toString();
  }
}

class IntegerTypeSpecification extends TypeSpecification {
  final String name;

  IntegerTypeSpecification({BinaryAttributes attributes, this.name}) : super(attributes: attributes) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }
  }

  String toString() => name;
}

class ParameterDeclaration {
  final String name;

  final TypeSpecification type;

  ParameterDeclaration({this.name, this.type}) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() {
    if (name == null) {
      return type.toString();
    } else {
      return type.toStringWithIdentifier(name);
    }
  }
}

class PointerTypeSpecification extends TypeSpecification {
  final TypeSpecification type;

  PointerTypeSpecification({BinaryAttributes attributes, this.type}) : super(attributes: attributes) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() => "$type*";
}

class StructureDeclaration extends BinaryDeclaration {
  StructureDefTypeSpecification _type;

  StructureDeclaration({List<BinaryAttribute> attributes, String kind, List members, String tag}) {
    _type = new StructureDefTypeSpecification(kind: kind, members: members, tag: tag);
  }

  StructureDefTypeSpecification get type => _type;

  String toString() {
    return type.toString();
  }
}

class StructureDefTypeSpecification extends TypeSpecification {
  final String kind;

  final String tag;

  List<VariableDeclaration> _members;

  StructureDefTypeSpecification({BinaryAttributes attributes, this.kind, List members, this.tag}) : super(attributes: attributes) {
    switch (kind) {
      case "struct":
      case "union":
        break;
      default:
        throw new ArgumentError.value("kind", kind);
    }

    _members = new _ListCloner(members, "members").list;
  }

  List<VariableDeclaration> get members => _members;

  String toString() {
    var sb = new StringBuffer();
    sb.write(kind);
    if (tag != null) {
      sb.write(" ");
      sb.write(tag);
    }

    sb.write(" { ");
    if (!members.isEmpty) {
      for (var member in members) {
        sb.write(member);
        sb.write("; ");
      }
    }

    sb.write("}");
    return sb.toString();
  }
}

class StructureTypeSpecification extends TypeSpecification {
  final String kind;

  final String tag;

  StructureTypeSpecification({BinaryAttributes attributes, this.kind, this.tag}) : super(attributes: attributes) {
    if (tag == null) {
      throw new ArgumentError.notNull("tag");
    }

    switch (kind) {
      case "struct":
      case "union":
        break;
      default:
        throw new ArgumentError.value("kind", kind);
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write(kind);
    if (tag != null) {
      sb.write(" ");
      sb.write(tag);
    }

    return sb.toString();
  }
}

abstract class TypeSpecification {
  final BinaryAttributes attributes;

  TypeSpecification({this.attributes});

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
  final BinaryAttributes attributes;

  final String name;

  final TypeSpecification type;

  TypedefDeclaration({this.attributes, this.name, this.type}) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value("name", name);
    }

    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() {
    var sb = new StringBuffer();
    sb.write("typedef ");
    if (attributes != null) {
      sb.write(attributes);
      sb.write(" ");
    }

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

    return sb.toString();
  }
}

class TypedefTypeSpecification extends TypeSpecification {
  final String name;

  TypedefTypeSpecification({BinaryAttributes attributes, this.name}) : super(attributes: attributes) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value("name", name);
    }
  }

  String toString() => name;
}

class VaListTypeSpecification extends TypeSpecification {
  String toString() => "...";
}

class VariableDeclaration extends BinaryDeclaration {
  final String name;

  final TypeSpecification type;

  VariableDeclaration({this.name, this.type}) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() {
    return type.toStringWithIdentifier(name);
  }
}

class VoidTypeSpecification extends TypeSpecification {
  String toString() => "void";
}

class _ListCloner<T> {
  List<T> list;

  String name;

  _ListCloner(List source, this.name) {
    var temp = <T>[];
    if (source != null) {
      for (var element in source) {
        if (element is! T) {
          throw new ArgumentError("List of $name contains illegal elements.");
        }

        temp.add(element);
      }
    }

    list = new UnmodifiableListView<T>(temp);
  }
}
