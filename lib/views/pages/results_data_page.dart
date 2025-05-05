import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../providers/index.dart';
import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_constants.dart';
import '../../resources/constants/route_names.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/extension.dart';
import '../atoms/primary_button.dart';
import '../molecules/progress_bar_with_title.dart';
import '../../providers/reset/reset_providers.dart';

class ResultsDataPage extends ConsumerWidget {
  const ResultsDataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(stepStateProvider);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(StringConstants.resutls),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: kDefaultPagePadding,
            child: Column(
              children: [
                ProgressBarWithTitle(step: ref.watch(stepStateProvider)),

                // Diagnosis List
                ...ref.watch(resultDetailsProvider).map(
                      (diagnosis) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: BorderedButton(
                          label: diagnosis["label"] as String,
                          color: AppColors.blue,
                          verticalPadding: 8,
                          action: () {
                            Alert(
                              context: context,
                              type: AlertType.none,
                              title: diagnosis["label"] as String,
                              desc: "",
                              content: Text(
                                diagnosis["description"] as String,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              ),
                              buttons: [
                                DialogButton(
                                  onPressed: () => context.navigator.pop(),
                                  color: AppColors.deepRed,
                                  child: const Text(
                                    StringConstants.close,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              ],
                            ).show();
                          },
                        ),
                      ),
                    ),

                const SizedBox(height: 48),

                // Final Diagnosis
                BorderedButton(
                  label: StringConstants.finalDiagnosis,
                  color: AppColors.blue,
                  verticalPadding: 24,
                  customHeight: 20,
                  action: () {
                    Alert(
                      context: context,
                      type: AlertType.none,
                      title: StringConstants.finalDiagnosis,
                      desc: "",
                      content: Text(
                        ref.watch(finalDiagnosisProvider),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buttons: [
                        DialogButton(
                          onPressed: () => context.navigator.pop(),
                          color: AppColors.deepRed,
                          child: const Text(
                            StringConstants.close,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        )
                      ],
                    ).show();
                  },
                ),

                const SizedBox(height: 24),

                // New Patient Button
                BorderedButton(
                  label: StringConstants.newPatient,
                  color: AppColors.appbarBackground,
                  verticalPadding: 24,
                  customHeight: 20,
                  action: () async {
                    final choice = await showModalActionSheet<String>(
                      context: context,
                      title: StringConstants.newPatient,
                      message: StringConstants.startAnalysisForNewPatient,
                      actions: [
                        const SheetAction<String>(
                          label: StringConstants.newPatient,
                          key: RouteNames.patientTypeSelection,
                        ),
                        const SheetAction<String>(
                          label: StringConstants.goBack,
                          key: null,
                        ),
                      ].nonNulls.toList(),
                    );

                    if (!context.mounted) return;
                    if (choice == null) {
                      if (context.navigator.canPop()) {
                        context.navigator.pop();
                      }
                      return;
                    }

                    // Reset all used providers
                    for (final provider in [
                      ...inputResetProviders,
                      ...resultResetProviders,
                    ]) {
                      ref.invalidate(provider);
                    }

                    context.navigator.pushNamedAndRemoveUntil(
                        choice as String, (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
