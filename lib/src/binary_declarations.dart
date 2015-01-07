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

  String toStringWithParameter(String parameter) {
    var sb = new StringBuffer();
    sb.write(type);
    if (parameter != null) {
      sb.write(" ");
      sb.write(parameter);
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

  final List<ParameterDeclaration> parameters;

  final TypeSpecification returnType;

  FunctionDeclaration({this.name, this.parameters, this.returnType}) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value("name", name);
    }
  }

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
    return type.toStringWithParameter(name);
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

class StructureTypeSpecification extends TypeSpecification {
  final String kind;

  final String tag;

  StructureTypeSpecification({this.kind, this.tag}) {
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
  String toStringWithParameter(String parameter) {
    var sb = new StringBuffer();
    sb.write(this);
    if (parameter != null) {
      sb.write(" ");
      sb.write(parameter);
    }

    return sb.toString();
  }
}

class TypedefDeclaration extends BinaryDeclaration {
  final int align;

  final String name;

  final Type type;

  TypedefDeclaration({this.align, this.name, this.type}) {
    if (name == null || name.isEmpty) {
      throw new ArgumentError.value("name", name);
    }

    if (type == null) {
      throw new ArgumentError.notNull("type");
    }

    _checkAlignment(align);
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
