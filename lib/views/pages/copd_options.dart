// lib/views/pages/copd_options.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/patient_type_provider.dart';
import '../../providers/reset/reset_providers.dart';
import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/constants/route_names.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/calculators/calculator_factory.dart';
import '../../services/enum.dart';
import '../../services/extension.dart';
import '../atoms/primary_button.dart';
import '../organism/adaptive_input_dialog.dart';
import '../organism/copd_section_fields.dart';

// Provider for COPD selection
final StateProvider<String?> copdOptionProvider = StateProvider<String?>((StateProviderRef<String?> ref) => null);

class COPDOptionsView extends ConsumerWidget {
  const COPDOptionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Retrieve the calculator types passed from initial selection
    final List<CalculatorType>? calculatorTypes =
        ModalRoute.of(context)?.settings.arguments as List<CalculatorType>?;

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
                child: BorderedButton(
                  customWidgetLabel: const Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: StringConstants.copdOptionOneTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepRed2,
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: "\n",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text:
                              StringConstants.copdNormalAgDetailsPartOneOfThree,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text:
                              StringConstants.copdNormalAgDetailsPartTwoOfThree,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepRed2,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: StringConstants
                              .copdNormalAgDetailsPartThreeOfThree,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  color: AppColors.blue,
                  verticalPadding: 8,
                  customHeight: 100,
                  action: () {
                    resetControllers(ref, copdSectionControllersProvider);
                    // Set the calculator type to the first option (Normal)
                    ref.read(calculatorTypeProvider.notifier).state =
                        CalculatorType.copdCalculationNormal;

                    ref.read(copdOptionProvider.notifier).state =
                        StringConstants.copdOptionOneTitle;

                    ref.read(patientTypeProvider.notifier).update(
                        (PatientType? state) => PatientType.patientTypeOne);

                    context.navigator.pushNamed(RouteNames.inputData);
                  },
                ),
              ),
              secondInput: Padding(
                padding: const EdgeInsets.all(16),
                child: BorderedButton(
                  customWidgetLabel: const Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: StringConstants.copdOptionTwoTitle,
                          style: TextStyle(
                            color: AppColors.deepRed2,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: "\n",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: StringConstants.copdHighAgDetailsPartOneOfThree,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: StringConstants.copdHighAgDetailsPartTwoOfThree,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepRed2,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text:
                              StringConstants.copdHighAgDetailsPartThreeOfThree,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  color: AppColors.blue,
                  verticalPadding: 8,
                  customHeight: 100,
                  action: () {
                    resetControllers(ref, copdSectionControllersProvider);
                    // Set the calculator type to the second option (High)
                    ref.read(calculatorTypeProvider.notifier).state =
                        CalculatorType.copdCalculationHigh;

                    ref.read(copdOptionProvider.notifier).state =
                        StringConstants.copdOptionTwoTitle;
                    ref.read(patientTypeProvider.notifier).update(
                        (PatientType? state) => PatientType.patientTypeTwo);
                    context.navigator.pushNamed(RouteNames.inputData);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
