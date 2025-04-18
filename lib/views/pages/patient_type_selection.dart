import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/constants/route_names.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/enum.dart';
import '../../services/extension.dart';
import '../atoms/primary_button.dart';
import '../organism/adaptive_input_dialog.dart';

final StateProvider<PatientType?> patientTypeProvider =
    StateProvider<PatientType?>((_) {
  return null;
});

class PatientTypeSelectionPage extends ConsumerWidget {
  const PatientTypeSelectionPage({super.key});

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
                      clipBehavior: Clip.hardEdge,
                      decoration: const BoxDecoration(),
                      padding: const EdgeInsets.all(10),
                      child: Banner(
                        message: "The commonest",
                        location: BannerLocation.topStart,
                        child: BorderedButton(
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
                          color: AppColors.blue,
                          verticalPadding: 8,
                          customHeight: 100,
                          action: () async {
                            ref.read(patientTypeProvider.notifier).update(
                                (PatientType? state) =>
                                    PatientType.patientTypeOne);

                            context.navigator
                                .pushReplacementNamed(RouteNames.inputData);
                          },
                        ),
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
                        ref.read(patientTypeProvider.notifier).update(
                            (PatientType? state) => PatientType.patientTypeTwo);
                        context.navigator
                            .pushReplacementNamed(RouteNames.inputData);
                      },
                    ),
                  ))),
        ],
      ),
    );
  }
}
