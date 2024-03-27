import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../resources/constants/string_constants.dart';
import '../../services/enum.dart';

final AutoDisposeStateProvider<CurrentStep> stepStateProvider = StateProvider.autoDispose<CurrentStep>((AutoDisposeStateProviderRef<CurrentStep> ref) {
  return CurrentStep.measuredData;
});

class ProgressBarWithTitle extends StatelessWidget {
  const ProgressBarWithTitle({
    required this.step, super.key,
  });
  final CurrentStep step;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return Column(
            children: <Widget>[
              // Text(ref.watch(stepStateProvider).value.toString()),
              Row(
                children: <Widget>[
                  ProgressBarItem(
                    text: StringConstants.measuredData,
                    providedStep: CurrentStep.measuredData,
                    currentStep: ref.watch(stepStateProvider),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  ProgressBarItem(
                    text: StringConstants.definitions,
                    providedStep: CurrentStep.definitions,
                    currentStep: ref.watch(stepStateProvider),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProgressBarItem extends StatelessWidget {
  const ProgressBarItem({
    required this.text, required this.providedStep, required this.currentStep, super.key,
  });

  final String text;
  final CurrentStep providedStep;
  final CurrentStep currentStep;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: <Widget>[
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: currentStep.value > providedStep.value
                    ? const Color.fromRGBO(200, 200, 200, 1)
                    : currentStep == providedStep
                        ? Theme.of(context).primaryColor
                        : const Color.fromRGBO(200, 200, 200, 1)),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: LinearProgressIndicator(
                  value: 1,
                  color: currentStep.value >= providedStep.value
                      ? Theme.of(context).primaryColor
                      : const Color.fromRGBO(200, 200, 200, 1),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
