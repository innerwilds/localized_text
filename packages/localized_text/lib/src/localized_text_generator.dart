import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:localized_text/src/template.dart';
import 'package:localized_text_annotation/localized_text_annotation.dart';
import 'package:source_gen/source_gen.dart';

class LocalizedTextGenerator extends GeneratorForAnnotation<LocalizedTextAnnotation> {
  LocalizedTextGenerator() : super(throwOnUnresolved: false);

  @override
  Iterable<String?> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) sync* {
    // Get the class name from the annotation
    final rNameToType = annotation.read('rNameToType').mapValue;
    final skipDeprecatedMembers = annotation.read('skipDeprecatedMembers').boolValue;

    final typeMap = {
      for (final entry in rNameToType.entries)
        entry.key!.toStringValue()!: entry.value!.toTypeValue()!.element as ClassElement,
    };

    for (final entry in typeMap.entries) {
      final template = ResourceTemplate(rName: entry.key, classElement: entry.value, skipDeprecatedMembers: skipDeprecatedMembers);
      yield template.toString();
    }

    yield null;
  }
}