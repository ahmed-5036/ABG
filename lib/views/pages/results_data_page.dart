import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../providers/input_calculator_provider.dart';
import '../../providers/result_calculator_providers.dart';
import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_constants.dart';
import '../../resources/constants/route_names.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/extension.dart';
import '../atoms/primary_button.dart';
import '../molecules/progress_bar_with_title.dart';
import '../organism/first_sections_fields.dart';
import '../organism/second_sections_fields.dart';
import '../organism/third_sections_fields.dart';

List<ProviderOrFamily> appProviders = <ProviderOrFamily>[
  potassiumNotifierProvider,
  sodiumNotifierProvider,
  albuminNotifierProvider,
  chlorineNotifierProvider,
  firstSectionTxtEditProvider,
  diagnosisOneResultProvider,
  correctedCLProvider,
  correctedCLProviderResult,
  clNaCalculationProvider,
  sidGeneralProvider,
  correctedHCO3Provider,
  correlationHCO3Provider,
  correctedAGStartProvider,
  correctedAGStartResultProvider,

  ///
  hco3NotifierProvider,
  bbCalculationProvider,
  bbResultProvider,
  phNotifierProvider,
  correctedAGPresentProvider,
  correctedAGPresentResultProvider,
  sigProvider,
  sigResultProvider,
  correctedHCO3TwoCorrelationProvider,
  aG2CalculationProvider,
  secondSectionTxtEditProvider,
  diagnosisSecondResultProvider,

  ///
  pCO2NotifierProvider,
  pAOutputO2Provider,
  paInputO2Provider,
  expectedPCo2ResultProvider,
  expectedPCo2CalculationProvider,
  aAProvider,
  agesProvider,
  paInputO2Provider,
  expectedAaProvider,
  thirdSectionTxtEditProvider,
  diagnosisThirdResultProvider,
  diagnosisFourthResultProvider,
  finalDiagnosisResultProvider,
];

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
            child: Column(children: <Widget>[
              ProgressBarWithTitle(
                step: ref.watch(stepStateProvider),
              ),
              ListView.separated(
                itemCount: ref.read(fourResultDiagnosisProvider).length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: 16,
                ),
                itemBuilder: (BuildContext context, int index) {
                  Map<String, dynamic> diagnosis =
                      ref.watch(fourResultDiagnosisProvider)[index];
                  return BorderedButton(
                    label: diagnosis["label"] as String,
                    color: AppColors.blue,
                    verticalPadding: 8,
                    action: () async {
                      Alert(
                        context: context,
                        type: AlertType.none,
                        title: diagnosis["title"] as String,
                        desc: "",
                        content: diagnosis["desc"] as Widget,
                        buttons: <DialogButton>[
                          DialogButton(
                            onPressed: () => context.navigator.pop(),
                            color: AppColors.deepRed,
                            child: const Text(
                              StringConstants.close,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ],
                      ).show();
                    },
                  );
                },
              ),
              const SizedBox(
                height: 24 * 2,
              ),
              BorderedButton(
                label: "Final Diagnosis",
                color: AppColors.blue,
                verticalPadding: 24,
                customHeight: 20,
                action: () async {
                  Alert(
                    context: context,
                    type: AlertType.none,
                    title: StringConstants.finalDiagnosis,
                    desc: "",
                    content: Text(
                      ref.watch(finalDiagnosisResultProvider),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    buttons: <DialogButton>[
                      DialogButton(
                        onPressed: () => context.navigator.pop(),
                        // width: 120,
                        color: AppColors.deepRed,

                        child: const Text(
                          StringConstants.close,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ],
                  ).show();
                },
              ),
              const SizedBox(
                height: 24,
              ),
              BorderedButton(
                label: "New Patient",
                color: AppColors.appbarBackground,
                verticalPadding: 24,
                customHeight: 20,
                action: () async {
                  String? newReq = await showModalActionSheet(
                      context: context,
                      title: StringConstants.newPatient,
                      message: StringConstants.startAnalysisForNewPatient,
                      actions: <SheetAction<String>>[
                        const SheetAction<String>(
                            label: StringConstants.newPatient,
                            key: RouteNames.patientTypeSelection),
                        const SheetAction<String>(
                            label: StringConstants.goBack, key: null),
                      ].nonNulls.toList());
                  if (!context.mounted) return;
                  if (newReq == null) {
                    if (context.navigator.canPop()) {
                      context.navigator.pop();
                    }
                    return;
                  }

                  for (ProviderOrFamily provider in appProviders) {
                    ref.invalidate(provider);
                  }

                  context.navigator
                      .pushNamedAndRemoveUntil(newReq, (Route route) => false);
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
