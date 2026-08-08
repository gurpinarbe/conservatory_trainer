import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localeControllerProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale?> {
  static const Locale english = Locale('en');
  static const Locale turkish = Locale('tr');

  @override
  Locale? build() => null;

  void useSystemLocale() {
    state = null;
  }

  void selectEnglish() {
    state = english;
  }

  void selectTurkish() {
    state = turkish;
  }

  void selectLocale(Locale? locale) {
    state = locale;
  }
}
