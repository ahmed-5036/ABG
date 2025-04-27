import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/constants/route_names.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/extension.dart';
import '../atoms/primary_button.dart';
import '../organism/adaptive_input_dialog.dart';

// Provider for Follow Up ABG selection
final followUpAbgOptionProvider = StateProvider<String?>((ref) => null);

class FollowUpAbgOptionsView extends ConsumerWidget {
  const FollowUpAbgOptionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 140,
        leadingWidth: 40,
        title: SizedBox(
          height: 100,
          child: Image.asset(
            AppImages.appLogo,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Text(
                  StringConstants.followUpAbgTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  StringConstants.followUpAbgSubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Center(
            child: AdaptiveInputDialog(
              flexFirst: 1,
              flexSecond: 1,
              firstInput: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.all(10),
                  child: BorderedButton(
                    customWidgetLabel: const Text(
                      StringConstants.primaryMetabolicInsultTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepRed2,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    color: AppColors.blue,
                    verticalPadding: 8,
                    customHeight: 100,
                    action: () {
                      ref.read(followUpAbgOptionProvider.notifier).state =
                          StringConstants.primaryMetabolicInsultTitle;

                      _showOptionDetails(
                          context,
                          StringConstants.primaryMetabolicInsultTitle,
                          StringConstants.primaryMetabolicInsultDescription);
                    },
                  ),
                ),
              ),
              secondInput: Padding(
                padding: const EdgeInsets.all(16),
                child: BorderedButton(
                  customWidgetLabel: const Text(
                    StringConstants.primaryRespiratoryInsultTitle,
                    style: TextStyle(
                      color: AppColors.deepRed2,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  color: AppColors.blue,
                  verticalPadding: 8,
                  customHeight: 100,
                  action: () {
                    ref.read(followUpAbgOptionProvider.notifier).state =
                        StringConstants.primaryRespiratoryInsultTitle;

                    _showOptionDetails(
                        context,
                        StringConstants.primaryRespiratoryInsultTitle,
                        StringConstants.primaryRespiratoryInsultDescription);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionDetails(
      BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description),
                const SizedBox(height: 16),
                Text('Examples:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                if (title == StringConstants.primaryMetabolicInsultTitle)
                  ...StringConstants.primaryMetabolicInsultExamples
                      .map((example) => Text('• $example'))
                      .toList()
                else
                  ...StringConstants.primaryRespiratoryInsultExamples
                      .map((example) => Text('• $example'))
                      .toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
