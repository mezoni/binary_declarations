part of binary_declarations.attribute_reader;

class AttributeReader {
  Map<String, List<List<dynamic>>> _attributes;

  AttributeReader(List<Metadata> metadataList) {
    if (metadataList == null) {
      throw new ArgumentError.notNull("metadataList");
    }

    _attributes = _joinMetadata(metadataList);
  }

  String get alias {
    var values = getFirstValues("alias");
    if (values == null) {
      return null;
    }

    if (values.isEmpty) {
      wrongNumberOfArguments("alias");
    }

    var parameter = values.first;
    if (parameter is! String) {
      wrongArgumentType("alias", "string");
    }

    return parameter;
  }

  int get aligned {
    var values = getLastValues("aligned");
    if (values == null) {
      return null;
    }

    if (values.isEmpty) {
      return 16;
    }

    if (values.length != 1) {
      wrongNumberOfArguments("aligned");
    }

    var parameter = values.first;
    if (parameter is! int) {
      wrongArgumentType("aligned", "integer");
    }

    return parameter;
  }

  bool get packed {
    var values = getLastValues("packed");
    if (values == null) {
      return false;
    }

    if (!values.isEmpty) {
      wrongNumberOfArguments("packed");
    }

    return true;
  }

  List<String> getFirstValues(String name) {
    var values = _attributes[name];
    if (values == null) {
      return null;
    }

    return values.first;
  }

  List<String> getLastValues(String name) {
    var values = _attributes[name];
    if (values == null) {
      return null;
    }

    return values.last;
  }

  void wrongArgumentType(String name, String type) {
    throw new StateError("Attribute '$name' argument not a $type");
  }

  void wrongNumberOfArguments(String name) {
    throw new StateError("Wrong number of arguments specified for '$name' attribute");
  }

  Map<String, List<List<dynamic>>> _getAttributes(Metadata metadata, Map<String, List<List<String>>> attributes) {
    if (attributes == null) {
      attributes = <String, List<List<dynamic>>>{};
    }

    if (metadata == null) {
      return attributes;
    }

    for (var attributeList in metadata.attributeList) {
      for (var value in attributeList.attributes) {
        var name = value.name;
        var list = attributes[name];
        if (list == null) {
          list = <List<dynamic>>[];
          attributes[name] = list;
        }

        list.add(value.parameters);
      }
    }

    return attributes;
  }

  Map<String, List<List<dynamic>>> _joinMetadata(List<Metadata> metadataList) {
    Map<String, List<List<dynamic>>> result;
    for (var metadata in metadataList) {
      result = _getAttributes(metadata, result);
    }

    return result;
  }
}
