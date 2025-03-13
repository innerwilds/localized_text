// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'example.dart';

// **************************************************************************
// LocalizedTextGenerator
// **************************************************************************

class CatR extends LocalizedTextGetter<CatLocalizations> {
  static const meow = CatR._(0);

  const CatR._(this._$type) : _$arg0 = null, _$arg1 = null;

  const CatR.countedMeows(int count)
    : _$type = 1,
      _$arg0 = count,
      _$arg1 = null;
  const CatR.kittiesJungle(int count, {required String someKittyName})
    : _$type = 2,
      _$arg0 = count,
      _$arg1 = someKittyName;
  const CatR.namedOnly({required String someKittyName})
    : _$type = 3,
      _$arg0 = someKittyName,
      _$arg1 = null;
  const CatR.positionalOnly(int count)
    : _$type = 4,
      _$arg0 = count,
      _$arg1 = null;
  const CatR.optionalPositionalOnly([int? count])
    : _$type = 5,
      _$arg0 = count,
      _$arg1 = null;
  const CatR.positionalAndOptionalPositional(int count, [String? val])
    : _$type = 6,
      _$arg0 = count,
      _$arg1 = val;

  final int _$type;
  final dynamic _$arg0;
  final dynamic _$arg1;

  @override
  String get(CatLocalizations resource) {
    return getNullable(resource)!;
  }

  @override
  String? getNullable(CatLocalizations resource) => switch (_$type) {
    0 => resource.meow,
    1 => resource.countedMeows(_$arg0),
    2 => resource.kittiesJungle(_$arg0, someKittyName: _$arg1),
    3 => resource.namedOnly(someKittyName: _$arg0),
    4 => resource.positionalOnly(_$arg0),
    5 => resource.optionalPositionalOnly(_$arg0),
    6 => resource.positionalAndOptionalPositional(_$arg0, _$arg1),
    _ =>
      throw UnimplementedError(
        '${_$type} is unimplemented. This is a error of localized_text builder.',
      ),
  };
}
