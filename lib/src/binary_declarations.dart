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

  ArrayTypeSpecification({int align, List<int> dimensions, this.type}) : super(align: align) {
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

  FloatTypeSpecification({int align, this.kind}) : super(align: align) {
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

  IntegerTypeSpecification({int align, this.name}) : super(align: align) {
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

  PointerTypeSpecification({int align, this.type}) : super(align: align) {
    if (type == null) {
      throw new ArgumentError.notNull("type");
    }
  }

  String toString() => "$type*";
}

class StructureDeclaration extends BinaryDeclaration {
  StructureDefTypeSpecification _type;

  StructureDeclaration({String kind, List members, int pack, String tag}) {
    _type = new StructureDefTypeSpecification(kind: kind, members: members, pack: pack, tag: tag);
  }

  StructureDefTypeSpecification get type => _type;

  String toString() {
    return type.toString();
  }
}

class StructureTypeSpecification extends TypeSpecification {
  final String kind;

  final int pack;

  final String tag;

  StructureTypeSpecification({int align, this.kind, this.pack, this.tag}) : super(align: align) {
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

class StructureDefTypeSpecification extends TypeSpecification {
  final String kind;

  final int pack;

  final String tag;

  List<VariableDeclaration> _members;

  StructureDefTypeSpecification({int align, this.kind, List members, this.pack, this.tag}) : super(align: align) {
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

abstract class TypeSpecification {
  final int align;

  TypeSpecification({this.align}) {
    _checkAlignment(align);
  }

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

  TypedefTypeSpecification({int align, this.name}) : super(align: align) {
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
