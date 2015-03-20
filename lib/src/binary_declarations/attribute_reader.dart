part of binary_declarations.attribute_reader;

class AttributeReader {
  Map<String, List<List<Expression>>> _arguments;

  AttributeReader(List<DeclarationSpecifiers> specifiers) {
    if (specifiers == null) {
      throw new ArgumentError.notNull("specifiers");
    }

    _arguments = _joinArguments(specifiers);
  }

  bool defined(String name, {int maxLength: 0, int minLength: 0}) {
    var arguments = getArguments(name, fromEnd: true);
    if (arguments == null) {
      return false;
    }

    _checkNumberOfArguments(name, arguments.length, minLength, maxLength);
    return true;
  }

  Expression getArgument(String name, int index, Expression value, {bool fromEnd: true, int maxLength, int minLength}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    if (index == null) {
      throw new ArgumentError.notNull("index");
    }

    if (index < 0) {
      throw new ArgumentError.value(index, "index");
    }

    if (fromEnd == null) {
      throw new ArgumentError.value(fromEnd, "last");
    }

    var arguments = getArguments(name, fromEnd: fromEnd);
    if (arguments == null) {
      return null;
    }

    var length = arguments.length;
    _checkNumberOfArguments(name, length, minLength, maxLength);
    if (length == null) {
      return value;
    }

    if (index >= length) {
      return value;
    }

    return arguments[index];
  }

  List getArguments(String name, {bool fromEnd: true}) {
    if (name == null) {
      throw new ArgumentError.notNull("name");
    }

    if (fromEnd == null) {
      throw new ArgumentError.notNull("first");
    }

    var arguments = _arguments[name];
    if (arguments == null) {
      return null;
    }

    if (fromEnd) {
      return new UnmodifiableListView(arguments.last);
    } else {
      return new UnmodifiableListView(arguments.first);
    }
  }

  IntegerLiteral getIntegerArgument(String name, int index, IntegerLiteral value, {bool fromEnd: true, int maxLength, int minLength}) {
    Object argument = getArgument(name, index, value, fromEnd: fromEnd, maxLength: maxLength, minLength: minLength);
    if (argument != null && argument is! IntegerLiteral) {
      _wrongArgumentType(name, "integer");
    }

    return argument;
  }

  StringLiteral getStringArgument(String name, int index, StringLiteral value, {bool fromEnd: true, int maxLength, int minLength}) {
    Object argument = getArgument(name, index, value, fromEnd: fromEnd, maxLength: maxLength, minLength: minLength);
    if (argument != null && argument is! StringLiteral) {
      _wrongArgumentType(name, "string");
    }

    return argument;
  }

  void _checkNumberOfArguments(String name, int length, int minLength, int maxLength) {
    if (minLength != null && length < minLength) {
      _wrongNumberOfArguments(name);
    }

    if (maxLength != null && length > maxLength) {
      _wrongNumberOfArguments(name);
    }
  }

  Map<String, List<List<Expression>>> _getArguments(DeclarationSpecifiers specifier, Map<String, List<List<Expression>>> arguments) {
    if (arguments == null) {
      arguments = <String, List<List<Expression>>>{};
    }

    if (specifier == null) {
      return arguments;
    }

    for (var specifier in specifier.elements) {
      for (var modifier in specifier.modifiers.elements) {
        var name = modifier.identifier.name;
        var list = arguments[name];
        if (list == null) {
          list = <List<Expression>>[];
          arguments[name] = list;
        }

        list.add(modifier.arguments.elements);
      }
    }

    return arguments;
  }

  Map<String, List<List<Expression>>> _joinArguments(List<DeclarationSpecifiers> specifiers) {
    Map<String, List<List<Expression>>> arguments;
    for (var specifier in specifiers) {
      arguments = _getArguments(specifier, arguments);
    }

    return arguments;
  }

  void _wrongArgumentType(String name, String type) {
    throw new StateError("Attribute '$name' argument not a $type");
  }

  void _wrongNumberOfArguments(String name) {
    throw new StateError("Wrong number of arguments specified for '$name' attribute");
  }
}