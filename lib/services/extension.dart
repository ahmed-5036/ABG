import 'package:flutter/material.dart'
    show BuildContext, Navigator, NavigatorState, TextTheme, Theme;

extension StringExtension on String {
  String toParsableString() {
    return trim().isEmpty ? "0.0" : replaceAll(",", ".");
  }
}

extension BoolExtension on bool {
  bool toggle() => !this;
}

extension BuildContextExtension on BuildContext {
  NavigatorState get navigator => Navigator.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
}
