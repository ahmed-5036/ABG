// lib/services/calculators/calculator_factory.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../views/pages/abg_admission.dart';
import '../calculations/admission_calculator.dart';
import '../calculations/copd_calculator.dart';
import '../enum.dart';
import 'package:aai_app/services/calculations/base_calculator.dart';
import 'package:aai_app/services/calculations/follow_up_calculator.dart';

enum CalculatorType {
  admissionABGNormal,
  admissionABGHigh,
  followUpABGMetabolic,
  followUpABGRespiratory,
  copdCalculationNormal,
  copdCalculationHigh,
}

class ABGCalculatorFactory {
  static ABGCalculator getCalculator(
      CalculatorType type, PatientType? patientType) {
    switch (type) {
      case CalculatorType.followUpABGMetabolic:
        return MetabolicPrimaryCalculator();

      case CalculatorType.followUpABGRespiratory:
        return RespiratoryPrimaryCalculator();

      case CalculatorType.admissionABGNormal:
        return AdmissionABGNormalCalculator();

      case CalculatorType.admissionABGHigh:
        return AdmissionABGHighCalculator();

      case CalculatorType.copdCalculationNormal:
        return COPDNormalCalculator();

      case CalculatorType.copdCalculationHigh:
        return COPDHighCalculator();
      default:
        throw Exception('Invalid calculator type: $type');
    }
  }

  static String getCalculatorName(CalculatorType type) {
    switch (type) {
      case CalculatorType.admissionABGNormal:
        return 'Admission ABG (Normal AG)';
      case CalculatorType.admissionABGHigh:
        return 'Admission ABG (High AG)';
      case CalculatorType.followUpABGMetabolic:
        return 'Follow-up ABG (Primary Metabolic)';
      case CalculatorType.followUpABGRespiratory:
        return 'Follow-up ABG (Primary Respiratory)';
      case CalculatorType.copdCalculationNormal:
        return 'COPD Calculation (Normal)';
      case CalculatorType.copdCalculationHigh:
        return 'COPD Calculation (High)';
      default:
        return 'Unknown Calculator';
    }
  }

  static String getCalculatorDescription(CalculatorType type) {
    switch (type) {
      case CalculatorType.admissionABGNormal:
        return 'Calculate ABG values for admission cases with normal anion gap';
      case CalculatorType.admissionABGHigh:
        return 'Calculate ABG values for admission cases with high anion gap';
      case CalculatorType.followUpABGMetabolic:
        return 'Calculate ABG values for follow-up cases with primary metabolic insult';
      case CalculatorType.followUpABGRespiratory:
        return 'Calculate ABG values for follow-up cases with primary respiratory insult';
      case CalculatorType.copdCalculationNormal:
        return 'COPD-specific calculations for normal cases';
      case CalculatorType.copdCalculationHigh:
        return 'COPD-specific calculations for high cases';
      default:
        return 'No description available';
    }
  }

  static bool validateInputs(CalculatorType type, Map<String, double?> inputs) {
    switch (type) {
      case CalculatorType.followUpABGMetabolic:
      case CalculatorType.followUpABGRespiratory:
        return _validateFollowUpInputs(inputs);
      case CalculatorType.admissionABGNormal:
      case CalculatorType.admissionABGHigh:
        return _validateAdmissionInputs(inputs);
      case CalculatorType.copdCalculationNormal:
      case CalculatorType.copdCalculationHigh:
        return _validateCopdInputs(inputs);
      default:
        return false;
    }
  }

  static bool requiresPatientType(CalculatorType type) {
    switch (type) {
      case CalculatorType.followUpABGMetabolic:
      case CalculatorType.followUpABGRespiratory:
        return true;
      default:
        return false;
    }
  }

  static bool _validateFollowUpInputs(Map<String, double?> inputs) {
    final requiredInputs = [
      'sodium',
      'chlorine',
      'hco3',
      'albumin',
      'ph',
      'pco2',
      'fio2',
      'pao2',
      'age'
    ];

    return requiredInputs.every((input) =>
        inputs.containsKey(input) &&
        inputs[input] != null &&
        inputs[input]! > 0);
  }

  static bool _validateAdmissionInputs(Map<String, double?> inputs) {
    final requiredInputs = [
      'sodium',
      'chlorine',
      'hco3',
      'albumin',
      'ph',
      'pco2'
    ];

    return requiredInputs.every((input) =>
        inputs.containsKey(input) &&
        inputs[input] != null &&
        inputs[input]! > 0);
  }

  static bool _validateCopdInputs(Map<String, double?> inputs) {
    final requiredInputs = ['hco3', 'pco2', 'ph'];

    return requiredInputs.every((input) =>
        inputs.containsKey(input) &&
        inputs[input] != null &&
        inputs[input]! > 0);
  }
}

// Riverpod Providers

final calculatorTypeProvider = StateProvider<CalculatorType>((ref) {
  return CalculatorType.followUpABGMetabolic; // default calculator
});

final calculatorProvider = Provider<ABGCalculator>((ref) {
  final type = ref.watch(calculatorTypeProvider);
  final patientType = ref.watch(patientTypeProvider);
  return ABGCalculatorFactory.getCalculator(type, patientType);
});

final inputValidationProvider =
    Provider.family<bool, Map<String, double?>>((ref, inputs) {
  final type = ref.watch(calculatorTypeProvider);
  return ABGCalculatorFactory.validateInputs(type, inputs);
});

final calculatorMetadataProvider = Provider<Map<String, String>>((ref) {
  final type = ref.watch(calculatorTypeProvider);
  return {
    'name': ABGCalculatorFactory.getCalculatorName(type),
    'description': ABGCalculatorFactory.getCalculatorDescription(type),
    'requiresPatientType':
        ABGCalculatorFactory.requiresPatientType(type).toString(),
  };
});

// Helper provider to group calculators by type
final calculatorGroupsProvider =
    Provider<Map<String, List<CalculatorType>>>((ref) {
  return {
    'Admission ABG': [
      CalculatorType.admissionABGNormal,
      CalculatorType.admissionABGHigh,
    ],
    'Follow-up ABG': [
      CalculatorType.followUpABGMetabolic,
      CalculatorType.followUpABGRespiratory,
    ],
    'COPD Calculation': [
      CalculatorType.copdCalculationNormal,
      CalculatorType.copdCalculationHigh,
    ],
  };
});
