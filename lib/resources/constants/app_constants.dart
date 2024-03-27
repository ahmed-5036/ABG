import 'package:flutter/widgets.dart';

EdgeInsets get kDefaultPagePadding =>
    const EdgeInsets.only(left: 16, right: 16, top: 12);

RegExp get numberWithDecimalRegex => RegExp(r"^[0-9\d]*\.?[0-9\d]*$");

class AppConstants {
  static const String youtubeLink = "https://www.youtube.com/@DrAhmedAglan/";
  static const String websiteLink = "https://ahmedaglan.com/";
}
