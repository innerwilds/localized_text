import 'package:localized_text_annotation/localized_text_annotation.dart';
import 'package:localized_text_common/localized_text_common.dart';

part 'example.g.dart';

@LocalizedTextAnnotation({
  'CatR': CatLocalizations,
})
class CatLocalizations {
  String get meow => "meow";
  String countedMeows(int count) {
    return 'Kitty meows $count ${ count == 1 ? 'time' : 'times' }';
  }
  String kittiesJungle(int count, {
    required String someKittyName,
  }) {
    return 'There is $count kitt${ count == 1 ? 'y' : 'ies' } and one of them called $someKittyName';
  }
  String namedOnly({
    required String someKittyName,
  }) {
    return someKittyName;
  }
  String positionalOnly(int count) {
    return '';
  }
  String optionalPositionalOnly([int? count]) {
    return '';
  }
  String positionalAndOptionalPositional(int count, [String? val]) {
    return '';
  }
}