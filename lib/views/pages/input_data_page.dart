import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/input/input_state_provider.dart';
import '../../providers/input/input_validation_provider.dart';
import '../../providers/calculator/calculator_result_provider.dart';
import '../../providers/input/navigation_validation_provider.dart';
import '../../resources/constants/app_constants.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/constants/route_names.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/calculators/calculator_factory.dart';
import '../../services/enum.dart';
import '../../services/extension.dart';
import '../atoms/primary_button.dart';
import '../molecules/header_title.dart';
import '../molecules/progress_bar_with_title.dart';
import '../organism/app_drawer.dart';
import '../organism/first_sections_fields.dart';
import '../organism/second_sections_fields.dart';
import '../organism/third_sections_fields.dart';
import 'abg_admission.dart';

class InputDataPage extends ConsumerStatefulWidget {
  const InputDataPage({super.key});

  @override
  ConsumerState<InputDataPage> createState() => _InputDataPageState();
}

class _InputDataPageState extends ConsumerState<InputDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              IconButton(
                icon: const Icon(Icons.replay_outlined),
                tooltip: StringConstants.resetAllInputs,
                onPressed: () async {
                  final confirm = await showOkCancelAlertDialog(
                    context: context,
                    isDestructiveAction: true,
                    okLabel: StringConstants.resetNow,
                    title: StringConstants.resetAnalysis,
                    message: StringConstants.startCollectingNewData,
                  );
                  if (confirm == OkCancelResult.ok) {
                    ref.read(inputStateProvider.notifier).resetAll();
                    FirstSection.clearControllers(ref);

                    // Reset other necessary providers
                    ref.invalidate(calculatorResultProvider);
                    // Add any other providers that need to be reset
                  }
                },
              ),
              IconButton(
                tooltip: StringConstants.newPatient,
                icon: const Icon(Icons.group_add_sharp),
                onPressed: () async {
                  final confirm = await showOkCancelAlertDialog(
                    context: context,
                    isDestructiveAction: true,
                    title: StringConstants.startAnalysisForNewPatient,
                    message: StringConstants.startCollectingNewData,
                  );
                  if (confirm == OkCancelResult.ok) {
                    ref.invalidate(inputStateProvider);
                    ref.invalidate(inputCompleteProvider);
                    ref.invalidate(calculatorResultProvider);
                    if (!context.mounted) return;
                    context.navigator.pushNamedAndRemoveUntil(
                      RouteNames.initialSelection,
                      (route) => false,
                    );
                  }
                },
              )
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Consumer(
              builder: (context, ref, _) {
                final type = ref.watch(patientTypeProvider)?.type ?? "";
                final calculatorMetadata =
                    ref.watch(calculatorMetadataProvider);
                final calculatorName = calculatorMetadata['name'] ?? '';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: HeaderTitle(
                          customWidgetLabel: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: StringConstants.analysis,
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                TextSpan(
                                  text: ' $calculatorName',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (type.isNotEmpty)
                                  TextSpan(
                                    text: ' ($type)',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: kDefaultPagePadding,
              child: Consumer(
                builder: (context, ref, _) => ProgressBarWithTitle(
                  step: ref.watch(stepStateProvider),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, -2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: kDefaultPagePadding,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const FirstSection(),
                    const SizedBox(height: 16),
                    const SecondSection(),
                    const SizedBox(height: 16),
                    const ThirdSection(),
                    const SizedBox(height: 24),
                    Consumer(
                      builder: (context, ref, _) {
                        final isReady = ref.watch(navigateToResultProvider);
                        return BorderedButton(
                          label: StringConstants.calculate,
                          enabled: true,
                          action: () {
                            Future<void>.delayed(
                                const Duration(milliseconds: 100), () {
                              ref.read(stepStateProvider.notifier).state =
                                  CurrentStep.definitions;
                            });
                            context.navigator.pushNamed(RouteNames.resultData);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
