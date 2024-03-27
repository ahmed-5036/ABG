import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_constants.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/constants/route_names.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/extension.dart';
import '../../services/utils.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(children: <Widget>[
        SizedBox(
          height: size.height * 0.22,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                color: AppColors.appbarBackground.withOpacity(0.8),
                child: Center(
                    child: Container(
                  decoration: BoxDecoration(
                      color:
                          const Color.fromRGBO(44, 47, 63, 1).withOpacity(0.3),
                      shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      maxRadius: size.height * 0.1,
                      backgroundImage: const AssetImage(AppImages.profile),
                    ),
                  ),
                )),
              )),
            ],
          ),
        ),
        Visibility(
          visible: !isLandScape,
          child: const SizedBox(
            height: 32,
          ),
        ),
        ListTile(
          title: const Text(StringConstants.measurement),
          hoverColor: AppColors.blue.withOpacity(0.3),
          leading: const Icon(
            Icons.legend_toggle,
          ),
          onTap: () async {
            context.navigator.pushNamedAndRemoveUntil(
                RouteNames.inputData, (Route route) => false);
          },
        ),
        ListTile(
          title: const Text(StringConstants.aboutUs),
          hoverColor: AppColors.blue.withOpacity(0.3),
          leading: const Icon(Icons.info_outline),
          onTap: () async {
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (_) => const AboutPage()),
            // );
            context.navigator.pushNamed(RouteNames.aboutUs);
          },
        ),
        ListTile(
          title: const Text(StringConstants.contactUs),
          hoverColor: AppColors.blue.withOpacity(0.3),
          leading: const Icon(Icons.call),
          onTap: () async {
            // if (kIsWeb) {
            //  html.window.open("https://ahmedaglan.com/", "_self");

            //  return;
            // }

            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (_) => const ContactusPage()),
            // );
            context.navigator.pushNamed(RouteNames.contactUs);
          },
        ),
        Visibility(visible: !isLandScape, child: const Spacer()),
        const Divider(),
        ListTile(
          title: const Text(StringConstants.youtubeChannel),
          hoverColor: AppColors.blue.withOpacity(0.3),
          leading: const Icon(Icons.smart_display),
          onTap: () async {
            Utils.launchInBrowser(AppConstants.youtubeLink,
                urlMode: LaunchMode.externalApplication);
          },
        ),
        ListTile(
          title: const Text(StringConstants.website),
          hoverColor: AppColors.blue.withOpacity(0.3),
          leading: const Icon(Icons.language),
          onTap: () async {
            Utils.launchInBrowser(AppConstants.websiteLink,
                urlMode: LaunchMode.externalApplication);
          },
        ),
        Visibility(
          visible: !isLandScape,
          child: const Spacer(
            flex: 4,
          ),
        ),
      ]),
    );
  }
}
