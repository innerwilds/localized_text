/// Annotation to generate R class for some localization.
///
/// It takes map of R class name -> localizations class name:
/// ```dart
/// @LocalizedTextAnnotation({
///   'MaterialLocalizationsR': MaterialLocalizations,
/// })
/// const _ = null;
/// ```
///
/// It will generate for you a class named MaterialLocalizationsR:
/// ```dart
/// class MaterialR extends LocalizedTextGetter<MaterialLocalizations> {
///   static const openAppDrawerTooltip = MaterialR._(0);
///   static const backButtonTooltip = MaterialR._(1);
///   static const clearButtonTooltip = MaterialR._(2);
///   ...
///
///   const MaterialR._(this._$type)
///     : _$arg0 = null,
///       _$arg1 = null,
///       _$arg2 = null,
///       _$arg3 = null;
///
///   const MaterialR.aboutListTileTitle(String applicationName)
///     : _$type = 126,
///       _$arg0 = applicationName,
///       _$arg1 = null,
///       _$arg2 = null,
///       _$arg3 = null;
///   const MaterialR.licensesPackageDetailText(int licenseCount)
///     : _$type = 127,
///       _$arg0 = licenseCount,
///       _$arg1 = null,
///       _$arg2 = null,
///       _$arg3 = null;
///   const MaterialR.pageRowsInfoTitle(
///     int firstRow,
///     int lastRow,
///     int rowCount,
///     bool rowCountIsApproximate,
///   ) : _$type = 128,
///       _$arg0 = firstRow,
///       _$arg1 = lastRow,
///       _$arg2 = rowCount,
///       _$arg3 = rowCountIsApproximate;
///   const MaterialR.tabLabel({required int tabIndex, required int tabCount})
///     : _$type = 129,
///       _$arg0 = tabIndex,
///       _$arg1 = tabCount,
///       _$arg2 = null,
///       _$arg3 = null;
///   const MaterialR.selectedRowCountTitle(int selectedRowCount)
///     : _$type = 130,
///       _$arg0 = selectedRowCount,
///       _$arg1 = null,
///       _$arg2 = null,
///       _$arg3 = null;
///   const MaterialR.scrimOnTapHint(String modalRouteContentName)
///     : _$type = 131,
///       _$arg0 = modalRouteContentName,
///       _$arg1 = null,
///       _$arg2 = null,
///       _$arg3 = null;
///   const MaterialR.formatDecimal(int number)
///     : _$type = 132,
///       _$arg0 = number,
///       _$arg1 = null,
///       _$arg2 = null,
///       _$arg3 = null;
///   const MaterialR.formatHour(
///     TimeOfDay timeOfDay, {
///     bool alwaysUse24HourFormat = false,
///   }) : _$type = 133,
///        _$arg0 = timeOfDay,
///        _$arg1 = alwaysUse24HourFormat,
///        _$arg2 = null,
///        _$arg3 = null;
///   const MaterialR.formatMinute(TimeOfDay timeOfDay)
///     : _$type = 134,
///       _$arg0 = timeOfDay,
///       _$arg1 = null,
///       _$arg2 = null,
///       _$arg3 = null;
///   const MaterialR.formatTimeOfDay(
///     TimeOfDay timeOfDay, {
///     bool alwaysUse24HourFormat = false,
///   }) : _$type = 135,
///        _$arg0 = timeOfDay,
///        _$arg1 = alwaysUse24HourFormat,
///        _$arg2 = null,
///        _$arg3 = null;
///   const MaterialR.formatYear(DateTime date)
///     : _$type = 136,
///       _$arg0 = date,
///       _$arg1 = null,
///       _$arg2 = null,
///       _$arg3 = null;
///   ...
///
///   final int _$type;
///   final dynamic _$arg0;
///   final dynamic _$arg1;
///   final dynamic _$arg2;
///   final dynamic _$arg3;
///
///   @override
///   String get(MaterialLocalizations resource) => switch (_$type) {
///     0 => resource.openAppDrawerTooltip,
///     1 => resource.backButtonTooltip,
///     2 => resource.clearButtonTooltip,
///     ...
///     126 => resource.aboutListTileTitle(_$arg0),
///     127 => resource.licensesPackageDetailText(_$arg0),
///     128 => resource.pageRowsInfoTitle(_$arg0, _$arg1, _$arg2, _$arg3),
///     129 => resource.tabLabel(tabIndex: _$arg0, tabCount: _$arg1),
///     130 => resource.selectedRowCountTitle(_$arg0),
///     131 => resource.scrimOnTapHint(_$arg0),
///     132 => resource.formatDecimal(_$arg0),
///     133 => resource.formatHour(_$arg0, alwaysUse24HourFormat: _$arg1),
///     134 => resource.formatMinute(_$arg0),
///     135 => resource.formatTimeOfDay(_$arg0, alwaysUse24HourFormat: _$arg1),
///     136 => resource.formatYear(_$arg0),
///     ...
///     _ =>
///       throw UnimplementedError(
///         '${_$type} is unimplemented. This is a error of localized_text builder.',
///       ),
///   };
/// }
/// ```
///
/// Generator will take all getters and methods from localization class omitting:
///   1. Deprecated members, if [skipDeprecatedMembers] is true.
///   2. Static/operator/private methods/getters.
///   3. Methods and getters which return type is not dart:core [String].
///
/// [LocalizedTextGetter] should be taken from localized_text_common package.
/// Or if you prefer to make own LocalizedTextGetter, consider to implement
/// next signatures:
/// const LocalizedTextGetter();
/// String get(L localizations);
/// String? getNullable(L localizations);
class LocalizedTextAnnotation {
  const LocalizedTextAnnotation(this.rNameToType, {
    this.skipDeprecatedMembers = false,
  });

  final Map<String, Type> rNameToType;
  final bool skipDeprecatedMembers;
}