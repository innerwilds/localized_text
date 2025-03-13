import 'dart:io';
import 'dart:math' as math;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';

typedef InitializerParameter = ({String fieldName, String paramName});

bool isReturnsNull(FunctionTypedElement element) {
  return element.returnType.nullabilitySuffix != NullabilitySuffix.none;
}

bool isNamedOrPositionalParameter(ParameterElement element) {
  return element.isNamed || element.isPositional;
}

bool isPositionalParameter(ParameterElement element) {
  return element.isPositional;
}

bool isNamedParameter(ParameterElement element) {
  return element.isNamed;
}

bool isOptionalParameter(ParameterElement element) {
  return element.isOptional;
}

bool isOptionalPositionalParameter(ParameterElement element) {
  return element.isOptionalPositional;
}

bool isRequiredPositionalParameter(ParameterElement element) {
  return element.isRequiredPositional;
}

extension on ParameterElement {
  String toCodeString() {
    final typeName = type.element?.name ?? 'dynamic';

    var code = '';

    if (isRequiredNamed) {
      code += 'required ';
    }

    final isNullable =
        this.type.nullabilitySuffix == NullabilitySuffix.question;

    code += '$typeName';

    if (isNullable) {
      code += '?';
    }

    code += ' $name';

    if (hasDefaultValue) {
      code += ' = $defaultValueCode';
    }

    return code;
  }
}

extension on MethodElement {
  String parametersToString({
    /// If true, generates produces this method element invocation.
    required bool isCallMode,
    void Function(ParameterElement)? visitor,
    String Function(ParameterElement)? getArgumentValue,
  }) {
    final positionals =
        parameters.where(isRequiredPositionalParameter).toList();
    final nameds = parameters.where(isNamedParameter).toList();
    final optionalPositionals =
        parameters.where(isOptionalPositionalParameter).toList();

    if (nameds.isNotEmpty && optionalPositionals.isNotEmpty) {
      throw UnsupportedError('');
    }

    var code = '';

    if (isCallMode) {
      for (final param in positionals) {
        visitor?.call(param);
        code += getArgumentValue!(param) + ',';
      }

      if (optionalPositionals.isNotEmpty) {
        for (final param in optionalPositionals) {
          visitor?.call(param);
          code += getArgumentValue!(param) + ',\n';
        }
      }

      if (nameds.isNotEmpty) {
        for (final named in nameds) {
          visitor?.call(named);
          code += '${named.name}: ${getArgumentValue!(named)},\n';
        }
      }
    } else {
      for (final positional in positionals) {
        visitor?.call(positional);
        code += positional.toCodeString() + ',';
      }

      if (optionalPositionals.isNotEmpty) {
        code += '[\n';
        for (final param in optionalPositionals) {
          visitor?.call(param);
          code += param.toCodeString() + ',\n';
        }
        code += ']';
      }

      if (nameds.isNotEmpty) {
        code += '{\n';
        for (final named in nameds) {
          visitor?.call(named);
          code += named.toCodeString() + ',\n';
        }
        code += '}';
      }
    }

    return code;
  }
}

class ResourceTemplate {
  ResourceTemplate({
    required this.rName,
    required this.classElement,
    required this.skipDeprecatedMembers,
  }) : rType = classElement.name;

  final String rName;
  final String rType;
  final bool skipDeprecatedMembers;

  final ClassElement classElement;

  bool skipGeneral(Element element) {
    return skipDeprecatedMembers && element.hasDeprecated;
  }

  bool skipMethod(MethodElement element) {
    return skipGeneral(element) ||
        element.isStatic ||
        element.isOperator ||
        element.isPrivate ||
        !element.returnType.isDartCoreString;
  }

  bool skipAccessor(PropertyAccessorElement element) {
    return skipGeneral(element) ||
        element.isStatic ||
        element.isSetter ||
        element.isOperator ||
        element.isPrivate ||
        !element.returnType.isDartCoreString;
  }

  @override
  String toString() {
    var nameCount = 0;

    final getters = <PropertyAccessorElement, int>{};
    final methods = <MethodElement, int>{};

    for (final element in classElement.children) {
      if (element case PropertyAccessorElement() when !skipAccessor(element))
        getters[element] = nameCount++;
      else if (element case MethodElement() when !skipMethod(element))
        methods[element] = nameCount++;
    }

    final statics = <String>[];
    final ctors = <String>[];
    final cases = <String>[];

    final parameterToFieldMap = <ParameterElement, int>{};

    var fieldsCount = 0;

    {
      for (final method in methods.keys) {
        var count = 0;
        for (final parameter in method.parameters) {
          parameterToFieldMap[parameter] = count++;
        }
        fieldsCount = math.max(fieldsCount, count);
      }
    }
    ;

    String createFieldName(int i) {
      return '_\$arg$i';
    }

    (String ctorArgs, String callArgs, String initializer)
    createCtorToMethodMap(MethodElement method) {
      final paramsCount = method.parameters.length;
      final argsInitializer = <String>[];
      final ctorArgs = method.parametersToString(
        isCallMode: false,
        visitor: (param) {
          final fieldName = createFieldName(parameterToFieldMap[param]!);
          argsInitializer.add('$fieldName = ${param.name}');
        },
      );

      for (var i = paramsCount; i < fieldsCount; i++) {
        final fieldName = createFieldName(i);
        argsInitializer.add('$fieldName = null');
      }

      final callArgs = method.parametersToString(
        isCallMode: true,
        getArgumentValue: (param) {
          final fieldName = createFieldName(parameterToFieldMap[param]!);
          return fieldName;
        },
      );

      return (ctorArgs, callArgs, argsInitializer.join(','));
    }

    for (final entry in getters.entries) {
      final name = entry.key.name;
      final type = entry.value;
      statics.add('static const $name = $rName._($type);');
      cases.add('$type => resource.$name');
    }

    for (final entry in methods.entries) {
      final name = entry.key.name;
      final type = entry.value;
      final (ctorArgs, callArgs, argsInitializers) = createCtorToMethodMap(
        entry.key,
      );
      ctors.add(
        'const $rName.$name($ctorArgs) : _\$type=$type, $argsInitializers;',
      );
      cases.add('$type => resource.$name($callArgs)');
    }

    final fields = {
      for (var i = 0; i < fieldsCount; i++)
        'final dynamic ${createFieldName(i)};',
    };

    final allFieldsInitializedWithNull = {
      for (var i = 0; i < fieldsCount; i++) '${createFieldName(i)} = null',
    };

    final asserts = {
      for (final entry in methods.entries)
        if (isReturnsNull(entry.key))
          "assert(_\$type != ${entry.value}, 'Obtain ${entry.key.name} using getNullable');",
      for (final entry in getters.entries)
        if (isReturnsNull(entry.key))
          "assert(_\$type != ${entry.value}, 'Obtain ${entry.key.name} using getNullable');",
    };

    final hasFields = allFieldsInitializedWithNull.isNotEmpty;

    return '''
class $rName extends LocalizedTextGetter<$rType> {
  ${statics.join('${Platform.lineTerminator}')}
  
  const $rName._(this._\$type)${ hasFields ? ' : ' + allFieldsInitializedWithNull.join(',\n') : ''};
  
  ${ctors.join('${Platform.lineTerminator}')}
  
  final int _\$type;
  ${fields.join('${Platform.lineTerminator}')}
  
  @override
  String get($rType resource) {
    ${asserts.join('\n')}
    return getNullable(resource)!;
  }
  
  @override
  String? getNullable($rType resource) => switch(_\$type) {
    ${cases.join(',${Platform.lineTerminator}')},
    _ => throw UnimplementedError('\${_\$type} is unimplemented. This is a error of localized_text builder.'),
  };
}
    ''';
  }
}
