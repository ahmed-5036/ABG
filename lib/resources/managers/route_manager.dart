import 'package:flutter/material.dart';

import '../../views/pages/about_page.dart';
import '../../views/pages/contact_us.dart';
import '../../views/pages/input_data_page.dart';
import '../../views/pages/patient_type_selection.dart';
import '../../views/pages/results_data_page.dart';
import '../constants/route_names.dart';

class RouteManager {
  RouteManager._();
  static final RouteManager _shared = RouteManager._();

  factory RouteManager.instance() => _shared;

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.inputData:
        return MaterialPageRoute<void>(
            builder: (BuildContext ctx) => const InputDataPage(),
            settings: const RouteSettings(name: RouteNames.inputData));
      case RouteNames.resultData:
        return MaterialPageRoute<void>(
            builder: (BuildContext ctx) => const ResultsDataPage(),
            settings: const RouteSettings(name: RouteNames.resultData));
      case RouteNames.contactUs:
        return MaterialPageRoute<void>(
            builder: (BuildContext ctx) => const ContactusPage(),
            settings: const RouteSettings(name: RouteNames.contactUs));
      case RouteNames.aboutUs:
        return MaterialPageRoute<void>(
            builder: (BuildContext ctx) => const AboutPage(),
            settings: const RouteSettings(name: RouteNames.aboutUs));
      case RouteNames.patientTypeSelection:
        return MaterialPageRoute<void>(
            builder: (BuildContext ctx) => const PatientTypeSelectionPage(),
            settings:
                const RouteSettings(name: RouteNames.patientTypeSelection));
    }
    return null;
  }
}
