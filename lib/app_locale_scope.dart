import 'package:flutter/material.dart';

/// Holds optional app [locale] for runtime switching. Wraps [MaterialApp].
/// Call [setLocale] from any descendant (e.g. a future language toggle).
class AppLocaleScope extends InheritedWidget {
  const AppLocaleScope({
    super.key,
    required this.locale,
    required this.setLocale,
    required super.child,
  });

  final Locale? locale;
  final void Function(Locale? locale) setLocale;

  static AppLocaleScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
  }

  static AppLocaleScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'AppLocaleScope not found');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppLocaleScope oldWidget) => locale != oldWidget.locale;
}
