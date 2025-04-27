import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/input_calculator_provider.dart';
import '../../providers/result_calculator_providers.dart';
import '../../resources/constants/app_constants.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/constants/route_names.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/enum.dart';
import '../../services/extension.dart';
import '../atoms/primary_button.dart';
import '../molecules/header_title.dart';
import '../molecules/progress_bar_with_title.dart';
import '../organism/app_drawer.dart';
import '../organism/first_sections_fields.dart';
import '../organism/second_sections_fields.dart';
import '../organism/third_sections_fields.dart';
import 'patient_type_selection.dart';
import 'results_data_page.dart';

class InputDataPage extends StatefulWidget {
  const InputDataPage({super.key});

  @override
  State<InputDataPage> createState() => _InputDataPageState();
}

class _InputDataPageState extends State<InputDataPage> {
  // late ScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _scrollController = ScrollController()
    //   ..addListener(() {
    //     Logger.logToConsole(_scrollController.position.pixels );
    //     // if (_scrollController.position.pixels == 0) {

    //     // }
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: Visibility(
      //   // visible: _scrollController.position.pixels == 0,
      //   child: FloatingActionButton.small(
      //     onPressed: () {
      //       _scrollController.animateTo(0,
      //           duration: const Duration(milliseconds: 200),
      //           curve: Curves.bounceInOut);
      //     },
      //     child: const Icon(Icons.arrow_circle_up_rounded),
      //   ),
      // ),
      appBar: AppBar(
        toolbarHeight: 140,
        leadingWidth: 40,
        title: SizedBox(
          height: 100,
          child: Image.asset(
            AppImages.appLogo,
            fit: BoxFit.fitWidth,
          ),
        ),
        actions: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) =>
                    IconButton(
                  icon: const Icon(Icons.replay_outlined),
                  enableFeedback: true,
                  highlightColor: Colors.red,
                  tooltip: StringConstants.resetAllInputs,
                  onPressed: () async {
                    OkCancelResult resetReq = await showOkCancelAlertDialog(
                        context: context,
                        isDestructiveAction: true,
                        okLabel: StringConstants.resetNow,
                        title: StringConstants.resetAnalysis,
                        message: StringConstants.startCollectingNewData);
                    if (resetReq == OkCancelResult.cancel) return;
                    for (ProviderOrFamily provider in appProviders) {
                      ref.invalidate(provider);
                    }
                  },
                ),
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) =>
                    IconButton(
                        tooltip: StringConstants.newPatient,
                        onPressed: () async {
                          OkCancelResult newReq = await showOkCancelAlertDialog(
                              context: context,
                              isDestructiveAction: true,
                              title: StringConstants.startAnalysisForNewPatient,
                              message: StringConstants.startCollectingNewData);
                          if (newReq == OkCancelResult.cancel) return;

                          ref.invalidate(potassiumNotifierProvider);
                          ref.invalidate(sodiumNotifierProvider);
                          ref.invalidate(albuminNotifierProvider);
                          ref.invalidate(chlorineNotifierProvider);
                          ref.invalidate(firstSectionTxtEditProvider);
                          ref.invalidate(diagnosisOneResultProvider);

                          ///
                          ref.invalidate(hco3NotifierProvider);
                          ref.invalidate(phNotifierProvider);
                          ref.invalidate(secondSectionTxtEditProvider);
                          ref.invalidate(diagnosisSecondResultProvider);

                          ///
                          ref.invalidate(pCO2NotifierProvider);
                          ref.invalidate(pAOutputO2Provider);
                          ref.invalidate(paInputO2Provider);
                          ref.invalidate(aAProvider);
                          ref.invalidate(agesProvider);
                          ref.invalidate(paInputO2Provider);
                          ref.invalidate(expectedAaProvider);
                          ref.invalidate(thirdSectionTxtEditProvider);
                          ref.invalidate(diagnosisThirdResultProvider);
                          ref.invalidate(diagnosisFourthResultProvider);
                          ref.invalidate(finalDiagnosisResultProvider);
                          if (!context.mounted) return;

                          context.navigator.pushNamedAndRemoveUntil(
                              RouteNames.initialSelection,
                              (Route route) => false);
                        },
                        icon: const Icon(Icons.group_add_sharp)),
              )
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        // controller: _scrollController,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Consumer(
                  builder: (BuildContext context, WidgetRef ref,
                          Widget? child) =>
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          HeaderTitle(
                              customWidgetLabel: Text.rich(
                            TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                    text: StringConstants.analysis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge),
                                TextSpan(
                                    text:
                                        ref.watch(patientTypeProvider)?.type ??
                                            "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14)),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          )),
                        ],
                      )),
              Padding(
                padding: kDefaultPagePadding,
                child: Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) =>
                          ProgressBarWithTitle(
                    step: ref.watch(stepStateProvider),
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, -2),
                          spreadRadius: 1,
                          blurRadius: 5)
                    ],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24))),
                child: Padding(
                  padding: kDefaultPagePadding,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 24,
                      ),
                      const FirstSection(),
                      const SizedBox(
                        height: 16,
                      ),
                      const SecondSection(),
                      const SizedBox(
                        height: 16,
                      ),
                      const ThirdSection(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Consumer(
                          builder: (BuildContext context, WidgetRef ref,
                                  Widget? child) =>
                              BorderedButton(
                            label: StringConstants.calculate,
                            enabled:
                                ref.watch(navigateToResultProviderProvider),
                            // enabled: true,

                            action: () async {
                              Future<void>.delayed(
                                  const Duration(milliseconds: 100), () {
                                ref.read(stepStateProvider.notifier).state =
                                    CurrentStep.definitions;
                              });

                              context.navigator
                                  .pushNamed(RouteNames.resultData);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
