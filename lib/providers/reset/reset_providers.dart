import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../views/molecules/progress_bar_with_title.dart';
import '../index.dart';

/// Input-related providers to reset
final List<ProviderOrFamily> inputResetProviders = [
  inputStateProvider,
  inputCompleteProvider,
  stepStateProvider,
];

/// Result-related providers to reset
final List<ProviderOrFamily> resultResetProviders = [
  calculatorResultProvider,
  metabolicResultProvider,
  respiratoryResultProvider,
  oxygenationResultProvider,
  finalDiagnosisProvider,
];

void resetControllers(WidgetRef ref,
    Provider<Map<String, TextEditingController>> controllersProvider) {
  final controllers = ref.read(controllersProvider);

  // Clear each controller and reset the corresponding field in input state
  controllers.forEach((field, controller) {
    //  Clear the text controller
    controller.clear();

    // Reset the field in inputStateProvider - this clears the result text
    ref.read(inputStateProvider.notifier).resetField(field);
  });
}
