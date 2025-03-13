## Meantime in jungle

The code we use to create localized text:
```
class _MyTitle extends StatelessWidget {
  const _MyTitle();
  
  @override
  Widget build(BuildContext context) {
    final r = CatLocalizations.of(context);
    return Text(r.yourCatTitle);
  }
}
```

Very short piece of code. Yeah?
But how many strings we have in our R?
Thousands.

We need to write this piece for every code to just update only it,
when localization is changed. We can keep in mind, that user won't
update their locale repeatedly and just depend on R in whole page/organism
build method. Yeah? I think so. But I don't want to repeat myself
writing everywhere 'final r = CatLocalizations.of(context);'.
I just want to use it like R.yourCatTitle when passing to Text.

Yeah, we can do it like:
```dart
CatLocalizations R(BuildContext context) {
  return CatLocalizations.of(context);
}
```
We now using R(context).yourCatTitle;
Or assigning it to local r, without full localizations class name.

Or we can do extension on State for this, or on BuildContext for this.

context.R.yourCatTitle
this.R.yourCatTitle

User won't update their locale repeatedly. But... if they do?
We need to update only Text widget!

So this package does next:
```dart
// cat_localizations.dart
// generated
class CatLocalizations {
  String get yourCatTitle => "Hello, Kitty!";
  String kittiesCounted(int count) {
    return '$count kitt${ count == 1 ? 'y' : 'ies' }';
  }
}
```
Then you write something like this with unused class declaration:
```dart
// cat_localized_text.dart

part 'cat_localized.text.g.dart';

@LocalizedTextAnnotation<CatLocalizations>(rName: 'CatR')
class _ {}
```
This will generate:
```dart
class CatR {
  static const yourCatTitle = CatR._yourCatTitle();
  
  const CatR._yourCatTitle() : _$type = 0;
  const CatR.kittiesCounted(int count) : _$type = 1, _$arg1 = count;
  
  final int _$type = 0;
  final dynamic _$arg1;
  
  String call(CatLocalizations r) {
    return switch(_$type) {
      0 => r.yourCatTitle,
      1 => r.kittiesCounted(_$arg1),
    };
  }
}
```

And now you can use it with LocalizedText (wrapper for Text).

```dart
class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Do you see? const.
    return const Scaffold(
      appBar: AppBar(
        title: LocalizedText(CatR.yourCatTitle),
      ),
      body: Center(
        child: LocalizedText(CatR.kittiesCounted(0)),
      ),
    );
  }
}

```




















//