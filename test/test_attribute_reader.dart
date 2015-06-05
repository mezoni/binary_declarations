import "package:binary_declarations/attribute_reader.dart";
import "package:binary_declarations/binary_declarations.dart";
import "package:test/test.dart";

void main() {
  group("Attribute reader", () {
    test("Get arguments", () {
      var _16 = new IntegerLiteral(text: "16", value: 16);
      var text = "__attribute__((aligned)) int i;";
      var files = {"header.h": text};
      var declarations = new Declarations("header.h", files);
      var declaration = declarations.first;
      var metadata = declaration.metadata;
      var reader = new AttributeReader([metadata, null]);
      var defined = reader.defined("aligned", minLength: 0, maxLength: 1);
      expect(defined, true, reason: "Not defined: aligned");
      var value = reader.getIntegerArgument("aligned", 0, _16, minLength: 0, maxLength: 1);
      expect(value, 16, reason: "Not correct default value: aligned");
      //
      text = "__attribute__((aligned(4 + 4))) int i;";
      files = {"header.h": text};
      declarations = new Declarations("header.h", files);
      declaration = declarations.first;
      metadata = declaration.metadata;
      reader = new AttributeReader([metadata, null]);
      defined = reader.defined("aligned", minLength: 0, maxLength: 1);
      expect(defined, true, reason: "Not defined: aligned(4 + 4)");
      value = reader.getIntegerArgument("aligned", 0, _16, minLength: 0, maxLength: 1);
      expect(value, 8, reason: "Not correct value: aligned(4 + 4)");
      //
      text = "__attribute__((aligned())) int i;";
      files = {"header.h": text};
      declarations = new Declarations("header.h", files);
      declaration = declarations.first;
      metadata = declaration.metadata;
      reader = new AttributeReader([metadata, null]);
      defined = reader.defined("aligned", minLength: 0, maxLength: 1);
      expect(defined, true, reason: "Not defined: aligned()");
      value = reader.getIntegerArgument("aligned", 0, _16, minLength: 0, maxLength: 1);
      expect(value, 16, reason: "Not correct value: aligned()");
      //
      text = "__attribute__((string(\"foo\"))) int i;";
      files = {"header.h": text};
      declarations = new Declarations("header.h", files);
      declaration = declarations.first;
      metadata = declaration.metadata;
      reader = new AttributeReader([metadata, null]);
      defined = reader.defined("string", minLength: 1, maxLength: 1);
      expect(defined, true, reason: "Not defined: string(\"foo\")");
      value = reader.getStringArgument("string", 0, null, minLength: 1, maxLength: 1);
      expect(value, "foo", reason: "Not correct value: string(\"foo\")");
      //
      text = "__attribute__((alias(foo))) int i;";
      files = {"header.h": text};
      declarations = new Declarations("header.h", files);
      declaration = declarations.first;
      metadata = declaration.metadata;
      reader = new AttributeReader([metadata, null]);
      defined = reader.defined("alias", minLength: 1, maxLength: 1);
      expect(defined, true, reason: "Not defined: alias(foo)");
      value = reader.getArgument("alias", 0, null, minLength: 1, maxLength: 1);
      expect(value is Identifier, true, reason: "Not an Identifier: alias(foo)");
      expect(value.name, "foo", reason: "Not correct identifier: alias(foo)");
    });
  });
}
