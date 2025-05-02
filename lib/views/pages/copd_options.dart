// lib/views/copd_options.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/constants/route_names.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/extension.dart';
import '../atoms/primary_button.dart';
import '../organism/adaptive_input_dialog.dart';

// Provider for COPD selection
final copdOptionProvider = StateProvider<String?>((ref) => null);

class COPDOptionsView extends ConsumerWidget {
  const COPDOptionsView({super.key});

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
                  'COPD Options',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'Select the COPD Metabolic Scenario',
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
                    customWidgetLabel: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: StringConstants.copdOptionOneTitle,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepRed2,
                                fontSize: 18,
                              ),
                            ),
                            const TextSpan(
                              text: "\n",
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: StringConstants.copdNormalAgExamples
                                  .join(', '),
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                            const TextSpan(
                              text: " then developed ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepRed2,
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text:
                                  StringConstants.copdHighAgExamples.join(', '),
                              style: const TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    color: AppColors.blue,
                    verticalPadding: 8,
                    customHeight: 100,
                    action: () {
                      ref.read(copdOptionProvider.notifier).state =
                          StringConstants.copdOptionOneTitle;

                      // _showOptionDetails(
                      //     context,
                      //     StringConstants.copdOptionOneTitle,
                      //     StringConstants.copdOptionOneDescription);
                      context.navigator.pushNamed(RouteNames.inputData);
                    },
                  ),
                ),
              ),
              secondInput: Padding(
                padding: const EdgeInsets.all(16),
                child: BorderedButton(
                  customWidgetLabel: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: StringConstants.copdOptionTwoTitle,
                            style: const TextStyle(
                              color: AppColors.deepRed2,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const TextSpan(
                            text: "\n",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: StringConstants.copdHighAgExamples.join(', '),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                          const TextSpan(
                            text: " then developed ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepRed2,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                StringConstants.copdNormalAgExamples.join(', '),
                            style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  color: AppColors.blue,
                  verticalPadding: 8,
                  customHeight: 100,
                  action: () {
                    ref.read(copdOptionProvider.notifier).state =
                        StringConstants.copdOptionTwoTitle;

                    // TODO: Add navigation or further action
                    _showOptionDetails(
                        context,
                        StringConstants.copdOptionTwoTitle,
                        StringConstants.copdOptionTwoDescription);
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
                if (title == StringConstants.copdOptionOneTitle) ...[
                  const Text('Normal AG Examples:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...StringConstants.copdNormalAgExamples
                      .map((example) => Text('• $example'))
                      .toList(),
                  const SizedBox(height: 16),
                  const Text('High AG Examples:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...StringConstants.copdHighAgExamples
                      .map((example) => Text('• $example'))
                      .toList(),
                ] else ...[
                  const Text('High AG Examples:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...StringConstants.copdHighAgExamples
                      .map((example) => Text('• $example'))
                      .toList(),
                  const SizedBox(height: 16),
                  const Text('Normal AG Examples:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...StringConstants.copdNormalAgExamples
                      .map((example) => Text('• $example'))
                      .toList(),
                ]
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
