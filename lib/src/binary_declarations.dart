part of binary_declarations;

void _checkAlignment(int align) {
  if (align != null) {
    var powerOf2 = (align != 0) && ((align & (align - 1)) == 0);
    if (!powerOf2) {
      throw new ArgumentError("Align '$align' should be power of 2 value.");
    }
  }
}

class ArrayTypeSpecification extends TypeSpecification {
  List<int> _dimensions;

  final TypeSpecification type;

  ArrayTypeSpecification({List<int> dimensions, this.type}) {
    if (dimensions == null) {
      throw new ArgumentError.notNull("dimensions");
    }

    var list = <int>[];
    list.addAll(dimensions);
    _dimensions = new UnmodifiableListView<int>(list);
  }

  List<int> get dimensions => _dimensions;

  String toString() {
    var sb = new StringBuffer();
    sb.write(type);
    sb.write(_dimensionsToString());
    return sb.toString();
  }

  String toStringWithIdentifier(String identifier, {bool short: true}) {
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

class FloatTypeSpecification extends TypeSpecification {
  final String kind;

  FloatTypeSpecification({this.kind}) {
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
  final String kind;

  final bool sign;

  IntegerTypeSpecification({this.kind, this.sign}) {
    switch (kind) {
      case "char":
      case "int":
      case "long":
      case "long int":
      case "long long":
      case "long long int":
      case "short":
      case "short int":
        break;
      default:
        throw new ArgumentError.value("kind", kind);
    }
  }

  String toString() {
    var sb = new StringBuffer();
    if (sign == true) {
      sb.write("signed ");
    } else if (sign == false) {
      sb.write("unsigned ");
    }

    sb.write(kind);
    return sb.toString();
  }
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
    return type.toStringWithIdentifier(name);
  }
}

class PointerTypeSpecification extends TypeSpecification {
  final TypeSpecification type;

  PointerTypeSpecification({this.type}) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() => "$type*";
}

class StructDeclaration extends BinaryDeclaration {
  StructureTypeSpecification _type;

  StructDeclaration({String kind, List members, String tag}) {
    _type = new StructureTypeSpecification(kind: kind, members: members, tag: tag);
  }

  StructureTypeSpecification get type => _type;

  String toString() {
    return type.toStringWithMembers();
  }
}

class StructureTypeSpecification extends TypeSpecification {
  final String kind;

  final String tag;

  List<VariableDeclaration> _members;

  StructureTypeSpecification({this.kind, List members, this.tag}) {
    switch (kind) {
      case "struct":
      case "union":
        break;
      default:
        throw new ArgumentError.value("kind", kind);
    }

    var list = <VariableDeclaration>[];
    if (members != null) {
      list.addAll(members);
    }

    _members = new UnmodifiableListView<VariableDeclaration>(list);
  }

  List<VariableDeclaration> get members => _members;

  String toString() {
    var sb = new StringBuffer();
    sb.write(kind);
    if (tag != null) {
      sb.write(" ");
      sb.write(tag);
    }

    return sb.toString();
  }

  String toStringWithIdentifier(String identifier, {bool short: true}) {
    var sb = new StringBuffer();
    if (short) {
      sb.write(this);
    } else {
      sb.write(toStringWithMembers());
    }

    sb.write(" ");
    sb.write(identifier);
    return sb.toString();
  }

  String toStringWithMembers() {
    var sb = new StringBuffer();
    sb.write(this);
    sb.write(" { ");
    if (!members.isEmpty) {
      sb.write(" ");
      for (var member in members) {
        sb.write(member);
        sb.write("; ");
      }
    }

    sb.write("}");
    return sb.toString();
  }
}

abstract class TypeSpecification {
  String toStringWithIdentifier(String identifier, {bool short: true}) {
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
  final int align;

  final String name;

  final TypeSpecification type;

  TypedefDeclaration({this.align, this.name, this.type}) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value("name", name);
    }

    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    _checkAlignment(align);
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
    } else if (type is StructureTypeSpecification) {
      var structureType = type;
      sb.write(structureType.toStringWithMembers());
      sb.write(" ");
      sb.write(name);
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

  TypedefTypeSpecification({this.name}) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value("name", name);
    }
  }

  String toString() => name;
}

class VaListTypeSpecification extends TypeSpecification {
  String toString() => "...";
}

class VariableDeclaration {
  final String name;

  final TypeSpecification type;

  VariableDeclaration({this.name, this.type}) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() {
    return type.toStringWithIdentifier(name, short: false);
  }
}

class VoidTypeSpecification extends TypeSpecification {
  String toString() => "void";
}
