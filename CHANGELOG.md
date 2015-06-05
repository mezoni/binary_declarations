## 0.0.59

- Made adaptations to the new version of package `test`

## 0.0.58

- Fixed minor bug

## 0.0.57

- Fixed bug in `BoolTypeSpecification`

## 0.0.56

- Breaking changes: Declarations now based on header files
- Initial support of header files

## 0.0.54

- Fixed bug in `C grammar`

## 0.0.53

- Fixed bug in `C grammar`

## 0.0.52

- Fixed bug in ExpressionEvaluator.visitBinaryExpression() with logical expression

## 0.0.51

- Changes in `c.peg` grammar

## 0.0.50

- Added support of expressions
- Breaking changes. Significant changes of several classes
- Changes in `c.peg` grammar

## 0.0.46

- Added support of string concatenation

## 0.0.45

- Breaking changes: All the direct values replaced on the literals
- Changes in `c.peg` grammar

## 0.0.44

- Changes in `c.peg` grammar
- Minor bug fixes in the constructor `FunctionParameters.FunctionParameters()`

## 0.0.43

- Changes in `c.peg` grammar

## 0.0.37

- Breaking changes. Significant changes of several classes
- Declarations are now based on the declarator. The declarator is the main concept of C-like declarations
- Significant changes in `c.peg` grammar. 

## 0.0.36

- Breaking changes. Several classes have been changed and renamed
- Changes in `c.peg` grammar 

## 0.0.35

- Added support of the `typedef` the function types
- Changes in `c.peg` grammar

## 0.0.33

- Added library `attribute_reader`

## 0.0.32

- Breaking changes. Attribute parameters can be only `integers` or `strings`  
- Changes in `c.peg` grammar

## 0.0.30

- Breaking changes. Several classes have been renamed and changed for extending the functionality
- Changes in `c.peg` grammar

## 0.0.29

- Breaking changes. Removed class `TypeSynonym`
- Changes in `c.peg` grammar

## 0.0.28

- Breaking changes. Several classes have been changed and renamed. Added possibility to declare several type synonyms in the one `typedef` declaration
- Changes in `c.peg` grammar 

## 0.0.27

- Breaking changes. Several classes have been renamed for the better consistency with package `binary types`

## 0.0.26

- Continuing the adjustment of the support of attribute specifiers `__attribute__`

## 0.0.24

- Added support of attribute specifiers in `tagged` types

## 0.0.22

- Initial support of attribute specifiers `__attribute__`

## 0.0.21

- Added support of the `bit-field` parameter declarations
- Fixed bug with the preprocessing
- Minor improvements and bug fixes in `c.peg` grammar

## 0.0.20

- Minor changes in `c.peg` grammar

## 0.0.19

- Breaking changes: Function declaration should explicitly specify the return type

## 0.0.18

- Generated new `c.peg` parser using new version of `peg` generator

## 0.0.16

- Initial support of macro processing

## 0.0.15

- Fixed bug in `c.peg` grammar. Underscore character `_` added to `IDENT_START`

## 0.0.14

- Generated new `c.peg` parser using new version of `peg` generator. Now the error messages should be a more understandable

## 0.0.12

- Breaking changes. Most of classes reworked
- Initial support of enums

## 0.0.11

- Added complex test
- Removed dependency to `binary_types`

## 0.0.10

- Fixed bugs in `C grammar`
- Initial support of attributes (currently only for typedef's)
- Removed `StructureDeclaration.pack` in favor of attributes
- Removed `TypeSpecification.align` in favor of attributes 

## 0.0.9

- Fixed bugs in `C grammar`

## 0.0.8

- Fixed bugs in `C grammar`

## 0.0.7

- Added `StructureTypeSpecification.pack`
- Added `TypeSpecification.align`

## 0.0.6

- Fixed bug in `C grammar`, now an identifiers and builtin types parsed correctly

## 0.0.5

- Fixed bug in `C grammar`, IDENTIFIER now can contains underscore character `_` 

## 0.0.4

- Fixed bug in `C grammar`
- Initial support of variable declarations

## 0.0.3

- Added support of va_list parameters `...` for function parameters
- Initial support of typedef declarations

## 0.0.2

- Added support of `const` type qualifier for function pointer parameters

## 0.0.1

- Initial release
- Initial support of function declarations

