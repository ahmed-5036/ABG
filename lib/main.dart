import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_platform/universal_platform.dart';

import 'resources/constants/route_names.dart';
import 'resources/managers/route_manager.dart';
import 'resources/managers/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (UniversalPlatform.isWindows ||
      UniversalPlatform.isMacOS ||
      UniversalPlatform.isLinux) {
    await DesktopWindow.setMinWindowSize(const Size(525, 690));
  }

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Aglan ABG",
      theme: ThemeManager.getTheme(context),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.initialSelection,
      onGenerateRoute: RouteManager.instance().onGenerateRoute,
    );
  }
}
