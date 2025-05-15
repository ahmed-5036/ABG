// lib/providers/index.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/abg_result.dart';
import '../services/enum.dart';
import 'calculator/calculator_result_provider.dart';
import 'input/input_state_provider.dart';
import 'result/metabolic_result_provider.dart';
import 'result/oxygenation_result_provider.dart';
import 'result/respiratory_result_provider.dart';
export 'input/navigation_validation_provider.dart';
export 'calculator/calculator_type_provider.dart';
export 'calculator/calculator_state_provider.dart';
export 'calculator/calculator_result_provider.dart';
export 'input/input_state_provider.dart';
export 'input/input_validation_provider.dart';
export 'result/metabolic_result_provider.dart';
export 'result/respiratory_result_provider.dart';
export 'result/oxygenation_result_provider.dart';

// Convenience providers
final Provider<String> finalDiagnosisProvider =
    Provider<String>((ProviderRef<String> ref) {
  final InputState inputs = ref.watch(inputStateProvider);
  debugPrint("Inputs: $inputs");

  if (!inputs.isComplete) {
    return "INCOMPLETE MEASURED ITEMS, PLEASE FILL THE INPUT FIELDS";
  }

  final MetabolicLevel metabolic = ref.watch(metabolicResultProvider);
  final RespiratoryLevel respiratory = ref.watch(respiratoryResultProvider);
  final OxygenWaterLevel oxygenation = ref.watch(oxygenationResultProvider);

  return "Patient has ${metabolic.level.$1} with ${respiratory.level.$1} and ${oxygenation.level.$1}";
});

final Provider<List<Map<String, dynamic>>> resultDetailsProvider =
    Provider<List<Map<String, dynamic>>>(
        (ProviderRef<List<Map<String, dynamic>>> ref) {
  final MetabolicLevel metabolicLevel = ref.watch(metabolicResultProvider);
  final RespiratoryLevel respiratoryLevel =
      ref.watch(respiratoryResultProvider);
  final OxygenWaterLevel oxygenationLevel =
      ref.watch(oxygenationResultProvider);

  final Map<String, dynamic> metabolicDetails =
      ref.watch(metabolicDetailsProvider);
  final Map<String, dynamic> respiratoryDetails =
      ref.watch(respiratoryDetailsProvider);
  final Map<String, dynamic> oxygenationDetails =
      ref.watch(oxygenationDetailsProvider);

  return <Map<String, dynamic>>[
    <String, dynamic>{
      "label": "Metabolic State",
      "result": metabolicLevel,
      "details": metabolicDetails,
      "description": _getMetabolicDescription(metabolicLevel),
    },
    <String, dynamic>{
      "label": "Respiratory State",
      "result": respiratoryLevel,
      "details": respiratoryDetails,
      "description": _getRespiratoryDescription(respiratoryLevel),
    },
    <String, dynamic>{
      "label": "Oxygenation State",
      "result": oxygenationLevel,
      "details": oxygenationDetails,
      "description": _getOxygenationDescription(oxygenationLevel),
    },
  ];
});

// Helper functions for descriptions
String _getMetabolicDescription(MetabolicLevel level) {
  switch (level) {
    case MetabolicLevel.normal:
      return "Normal metabolic state";
    case MetabolicLevel.metabolicAcidosis:
      return "Metabolic acidosis present";
    case MetabolicLevel.metabolicAlkalosis:
      return "Metabolic alkalosis present";
    case MetabolicLevel.simpleMetabolicAcidosis:
      return "Simple metabolic acidosis";
    case MetabolicLevel.simpleMetabolicAlkalosis:
      return "Simple metabolic alkalosis";
    case MetabolicLevel.mixedMetabolicAcidosis:
      return "Mixed metabolic acidosis";
    case MetabolicLevel.mixedMetabolicAlkalosis:
      return "Mixed metabolic alkalosis";
    case MetabolicLevel.unknown:
    default:
      return "Not available";
  }
}

String _getRespiratoryDescription(RespiratoryLevel level) {
  switch (level) {
    case RespiratoryLevel.normocarbia:
      return "Normal respiratory state";
    case RespiratoryLevel.hypoVentilatoryRespiratoryAcidosis:
      return "Hypoventilatory respiratory acidosis";
    case RespiratoryLevel.hyperVentilatoryRespiratoryAlkalosis:
      return "Hyperventilatory respiratory alkalosis";
    case RespiratoryLevel.compensatoryRespiratoryAcidosis:
      return "Compensatory respiratory acidosis";
    case RespiratoryLevel.compensatoryRespiratoryAlkalosis:
      return "Compensatory respiratory alkalosis";
    case RespiratoryLevel.unknown:
    default:
      return "Not available";
  }
}

String _getOxygenationDescription(OxygenWaterLevel level) {
  switch (level) {
    case OxygenWaterLevel.normoxia:
      return "Normal oxygenation";
    case OxygenWaterLevel.hypoxemia:
      return "Hypoxemia present";
    case OxygenWaterLevel.unknown:
    default:
      return "Not available";
  }
}

// Additional helper providers
final Provider<bool> hasValidInputsProvider =
    Provider<bool>((ProviderRef<bool> ref) {
  final InputState inputs = ref.watch(inputStateProvider);
  return inputs.isComplete;
});

final Provider<CalculationState> calculationStateProvider =
    Provider<CalculationState>((ProviderRef<CalculationState> ref) {
  final bool hasValidInputs = ref.watch(hasValidInputsProvider);
  final ABGResult result = ref.watch(calculatorResultProvider);

  if (!hasValidInputs) {
    return CalculationState.incomplete;
  }

  if (result == ABGResult.initial()) {
    return CalculationState.ready;
  }

  return CalculationState.complete;
});

enum CalculationState {
  incomplete,
  ready,
  complete,
}
