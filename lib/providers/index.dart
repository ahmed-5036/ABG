// lib/providers/index.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/input/navigation_validation_provider.dart';
import '../models/abg_result.dart';
import '../services/enum.dart';
import '../services/calculators/calculator_factory.dart';
import 'calculator/calculator_result_provider.dart';
import 'input/input_state_provider.dart';
import 'input/input_validation_provider.dart';
import 'result/metabolic_result_provider.dart';
import 'result/oxygenation_result_provider.dart';
import 'result/respiratory_result_provider.dart';
import 'input/navigation_validation_provider.dart';
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
final finalDiagnosisProvider = Provider<String>((ref) {
  final inputs = ref.watch(inputStateProvider);
  debugPrint("Inputs: $inputs");

  if (!inputs.isComplete) {
    return "INCOMPLETE MEASURED ITEMS, PLEASE FILL THE INPUT FIELDS";
  }

  final metabolic = ref.watch(metabolicResultProvider);
  final respiratory = ref.watch(respiratoryResultProvider);
  final oxygenation = ref.watch(oxygenationResultProvider);

  return "Patient has ${metabolic.level.$1} with ${respiratory.level.$1} and ${oxygenation.level.$1}";
});

final resultDetailsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final metabolicLevel = ref.watch(metabolicResultProvider);
  final respiratoryLevel = ref.watch(respiratoryResultProvider);
  final oxygenationLevel = ref.watch(oxygenationResultProvider);

  final metabolicDetails = ref.watch(metabolicDetailsProvider);
  final respiratoryDetails = ref.watch(respiratoryDetailsProvider);
  final oxygenationDetails = ref.watch(oxygenationDetailsProvider);

  return [
    {
      "label": "Metabolic State",
      "result": metabolicLevel,
      "details": metabolicDetails,
      "description": _getMetabolicDescription(metabolicLevel),
    },
    {
      "label": "Respiratory State",
      "result": respiratoryLevel,
      "details": respiratoryDetails,
      "description": _getRespiratoryDescription(respiratoryLevel),
    },
    {
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
final hasValidInputsProvider = Provider<bool>((ref) {
  final inputs = ref.watch(inputStateProvider);
  return inputs.isComplete;
});

final calculationStateProvider = Provider<CalculationState>((ref) {
  final hasValidInputs = ref.watch(hasValidInputsProvider);
  final result = ref.watch(calculatorResultProvider);

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
