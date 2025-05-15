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
import '../organism/first_sections_fields.dart';
import '../organism/second_sections_fields.dart';
import '../organism/third_sections_fields.dart';

class PatientTypeSelectionPage extends ConsumerWidget {
  const PatientTypeSelectionPage({super.key});

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
                  StringConstants.fromHistory,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  StringConstants.selectModule,
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
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          BorderedButton(
                            customWidgetLabel: const Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                      text: StringConstants.patientTypeOne,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.deepRed2,
                                          fontSize: 18)),
                                  TextSpan(
                                      text: "\n",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14)),
                                  TextSpan(
                                    text: StringConstants
                                        .patientTypeOneDetailsPartOneOfThree,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: StringConstants
                                        .patientTypeOneDetailsPartTwoOfThree,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.deepRed2,
                                        fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: StringConstants
                                        .patientTypeOneDetailsPartThreeOfThree,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            color: Colors.transparent,
                            verticalPadding: 8,
                            customHeight: 100,
                            action: () async {
                              resetControllers(
                                  ref, firstSectionControllersProvider);
                              resetControllers(
                                  ref, secondSectionControllersProvider);
                              resetControllers(
                                  ref, thirdSectionControllersProvider);
                              // Set the calculator type to the first option (Normal)
                              ref.read(calculatorTypeProvider.notifier).state =
                                  calculatorTypes?[0] ??
                                      CalculatorType.admissionABGNormal;

                              ref.read(patientTypeProvider.notifier).update(
                                  (PatientType? state) =>
                                      PatientType.patientTypeOne);

                              context.navigator.pushNamed(RouteNames.inputData);
                            },
                          ),
                          Positioned(
                            top: -10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.deepRed2,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                "The commonest",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  secondInput: Padding(
                    padding: const EdgeInsets.all(16),
                    child: BorderedButton(
                      customWidgetLabel: const Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                                text: StringConstants.patientTypeTwo,
                                style: TextStyle(
                                    color: AppColors.deepRed2,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            TextSpan(
                                text: "\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14)),
                            TextSpan(
                                text: StringConstants
                                    .patientTypeTwoDetailsPartOneOfThree,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14)),
                            TextSpan(
                                text: StringConstants
                                    .patientTypeTwoDetailsPartTwoOfThree,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.deepRed2,
                                    fontSize: 14)),
                            TextSpan(
                                text: StringConstants
                                    .patientTypeTwoDetailsPartThreeOfThree,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      color: AppColors.blue,
                      verticalPadding: 8,
                      customHeight: 100,
                      action: () async {
                        // Set the calculator type to the second option (High)
                        resetControllers(ref, firstSectionControllersProvider);
                        resetControllers(ref, secondSectionControllersProvider);
                        resetControllers(ref, thirdSectionControllersProvider);
                        ref.read(calculatorTypeProvider.notifier).state =
                            calculatorTypes?[1] ??
                                CalculatorType.admissionABGHigh;

                        ref.read(patientTypeProvider.notifier).update(
                            (PatientType? state) => PatientType.patientTypeTwo);
                        context.navigator.pushNamed(RouteNames.inputData);
                      },
                    ),
                  ))),
        ],
      ),
    );
  }
}
