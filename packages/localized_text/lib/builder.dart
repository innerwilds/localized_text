import 'package:build/build.dart';
import 'package:localized_text/src/localized_text_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Builds generators for `build_runner` to run
Builder localized_text(BuilderOptions options) {
  return PartBuilder(
    [
      LocalizedTextGenerator(),
    ],
    '.g.dart',
    header: '''
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
  ''',
    options: options,
  );
}