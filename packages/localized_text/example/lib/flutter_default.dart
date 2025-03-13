import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localized_text_annotation/localized_text_annotation.dart';
import 'package:localized_text_common/localized_text_common.dart';

part 'flutter_default.g.dart';

@LocalizedTextAnnotation({
  'MaterialR': MaterialLocalizations,
  'CupertinoR': CupertinoLocalizations,
  'WidgetsR': WidgetsLocalizations,
}, skipDeprecatedMembers: true)
class _ {}