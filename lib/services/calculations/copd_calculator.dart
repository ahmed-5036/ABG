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
    // Calculate corrected AG
    double correctedAG = (sodium - chlorine - hco3) + ((4 - albumin) * 2.5);

    // Calculate expected HCO3 for normal AG scenario
    double expectedHCO3 = hco3 + (correctedAG - 12);

    // Calculate expected PCO2
    double expectedPCO2 = 40 + ((expectedHCO3 - hco3) / 0.35);

    // Calculate expected pH
    double expectedPH = 7.4 -
        (((expectedPCO2 - 40) * 0.08) / 10) +
        (((expectedHCO3 - 24) * 0.15) / 10);

    MetabolicLevel metabolicState;
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
      additionalData: {
        'expectedPCO2': expectedPCO2,
        'expectedHCO3': expectedHCO3,
        'expectedPH': expectedPH,
        'correctedAG': correctedAG,
      },
    );
  }

  @override
  FinalResult<RespiratoryLevel> calculateRespiratoryState({
    required double pco2,
    required double hco3,
    required double ph,
  }) {
    // Calculate expected PCO2 using the same formula as metabolic state
    double expectedPCO2 = 40 + ((hco3 - 24) / 0.35);

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
    // Calculate measured SID
    double measuredSID = sodium - chlorine;

    // Calculate expected HCO3 for high AG scenario
    double expectedHCO3 = hco3 + (36 - measuredSID);

    // Calculate expected PCO2
    double expectedPCO2 = 40 + ((expectedHCO3 - hco3) / 0.35);

    // Calculate expected pH
    double expectedPH = 7.4 -
        ((expectedPCO2 - 40) * 0.08 / 10) +
        ((expectedHCO3 - 24) * 0.15 / 10);

    MetabolicLevel metabolicState;
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
      additionalData: {
        'expectedPCO2': expectedPCO2,
        'expectedHCO3': expectedHCO3,
        'expectedPH': expectedPH,
        'measuredSID': measuredSID,
      },
    );
  }

  @override
  FinalResult<RespiratoryLevel> calculateRespiratoryState({
    required double pco2,
    required double hco3,
    required double ph,
  }) {
    // Calculate expected PCO2 using the same formula as metabolic state
    double expectedPCO2 = 40 + ((hco3 - 24) / 0.35);

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
