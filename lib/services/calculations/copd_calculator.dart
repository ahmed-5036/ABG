// lib/services/calculations/copd_calculator.dart
import '../../models/abg_result.dart';
import '../enum.dart';
import 'base_calculator.dart';

abstract class COPDCalculator implements ABGCalculator {
  @override
  String getFinalDiagnosis({
    required String metabolicDiagnosis,
    required String respiratoryDiagnosis,
    required String oxygenationDiagnosis,
  }) {
    return "COPD Patient has $metabolicDiagnosis with $respiratoryDiagnosis";
  }
}

class COPDNormalCalculator extends COPDCalculator {
  @override
  FinalResult<MetabolicLevel> calculateMetabolicState({
    required double sodium,
    required double chlorine,
    required double hco3,
    required double albumin,
  }) {
    MetabolicLevel metabolicState;
    // For HCO3 < 24 (Metabolic Acidosis)
    double expectedPCO2 = 40 - ((24 - hco3) * 1.2);

    if (hco3 < 24) {
      metabolicState = MetabolicLevel.metabolicAcidosis;
    } else if (hco3 == 24) {
      metabolicState = MetabolicLevel.normal;
    } else {
      metabolicState = MetabolicLevel.metabolicAlkalosis;
    }

    return FinalResult(
      findingLevel: metabolicState,
      findingNumber: hco3,
      additionalData: {'expectedPCO2': expectedPCO2},
    );
  }

  @override
  FinalResult<RespiratoryLevel> calculateRespiratoryState({
    required double pco2,
    required double hco3,
    required double ph,
  }) {
    double expectedPCO2 = 40 - ((24 - hco3) * 1.2);

    RespiratoryLevel respiratoryState;
    if ((expectedPCO2 - pco2).abs() <= 3) {
      respiratoryState = RespiratoryLevel.normocarbia;
    } else if (pco2 > expectedPCO2) {
      respiratoryState = RespiratoryLevel.hypoVentilatoryRespiratoryAcidosis;
    } else {
      respiratoryState = RespiratoryLevel.hyperVentilatoryRespiratoryAlkalosis;
    }

    return FinalResult(
      findingLevel: respiratoryState,
      findingNumber: pco2,
      additionalData: {'expectedPCO2': expectedPCO2},
    );
  }

  @override
  FinalResult<OxygenWaterLevel> calculateOxygenationState({
    required double fio2,
    required double pco2,
    required double pao2,
    required double age,
  }) {
    // Same implementation as other calculators
    double pAO2 = (fio2 * 7) - (pco2 / 0.8);
    double aA = pAO2 - pao2;
    double expectedAa = ((fio2 / 100) * age + 2.5);

    return FinalResult(
      findingLevel: (expectedAa + 5) < aA
          ? OxygenWaterLevel.hypoxemia
          : OxygenWaterLevel.normoxia,
      findingNumber: aA,
      additionalData: {
        'pAO2': pAO2,
        'expectedAa': expectedAa,
      },
    );
  }
}

class COPDHighCalculator extends COPDCalculator {
  @override
  FinalResult<MetabolicLevel> calculateMetabolicState({
    required double sodium,
    required double chlorine,
    required double hco3,
    required double albumin,
  }) {
    MetabolicLevel metabolicState;
    // For HCO3 > 24 (Metabolic Alkalosis)
    double expectedPCO2 = 40 - ((24 - hco3) * 0.6);

    if (hco3 > 24) {
      metabolicState = MetabolicLevel.metabolicAlkalosis;
    } else if (hco3 == 24) {
      metabolicState = MetabolicLevel.normal;
    } else {
      metabolicState = MetabolicLevel.metabolicAcidosis;
    }

    return FinalResult(
      findingLevel: metabolicState,
      findingNumber: hco3,
      additionalData: {'expectedPCO2': expectedPCO2},
    );
  }

  @override
  FinalResult<RespiratoryLevel> calculateRespiratoryState({
    required double pco2,
    required double hco3,
    required double ph,
  }) {
    double expectedPCO2 = 40 - ((24 - hco3) * 1.2);

    RespiratoryLevel respiratoryState;
    if ((expectedPCO2 - pco2).abs() <= 3) {
      respiratoryState = RespiratoryLevel.normocarbia;
    } else if (pco2 > expectedPCO2) {
      respiratoryState = RespiratoryLevel.hypoVentilatoryRespiratoryAcidosis;
    } else {
      respiratoryState = RespiratoryLevel.hyperVentilatoryRespiratoryAlkalosis;
    }

    return FinalResult(
      findingLevel: respiratoryState,
      findingNumber: pco2,
      additionalData: {'expectedPCO2': expectedPCO2},
    );
  }

  @override
  FinalResult<OxygenWaterLevel> calculateOxygenationState({
    required double fio2,
    required double pco2,
    required double pao2,
    required double age,
  }) {
    // Same implementation as other calculators
    double pAO2 = (fio2 * 7) - (pco2 / 0.8);
    double aA = pAO2 - pao2;
    double expectedAa = ((fio2 / 100) * age + 2.5);

    return FinalResult(
      findingLevel: (expectedAa + 5) < aA
          ? OxygenWaterLevel.hypoxemia
          : OxygenWaterLevel.normoxia,
      findingNumber: aA,
      additionalData: {
        'pAO2': pAO2,
        'expectedAa': expectedAa,
      },
    );
  }
}
