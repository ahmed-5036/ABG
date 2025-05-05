// lib/services/calculations/admission_calculator.dart
import '../../models/abg_result.dart';
import '../enum.dart';
import 'base_calculator.dart';

abstract class AdmissionABGCalculator implements ABGCalculator {
  @override
  String getFinalDiagnosis({
    required String metabolicDiagnosis,
    required String respiratoryDiagnosis,
    required String oxygenationDiagnosis,
  }) {
    return "This Patient has $metabolicDiagnosis with $respiratoryDiagnosis and $oxygenationDiagnosis";
  }
}

class AdmissionABGNormalCalculator extends AdmissionABGCalculator {
  @override
  FinalResult<MetabolicLevel> calculateMetabolicState({
    required double sodium,
    required double chlorine,
    required double hco3,
    required double albumin,
  }) {
    // Calculate Corrected AG
    double correctedAG = (sodium - chlorine - hco3) + ((4 - albumin) * 2.5);

    // Calculate Expected HCO3
    double expectedHCO3 = hco3 + (correctedAG - 12);

    // Calculate Expected PCO2
    double expectedPCO2 = 40 + ((expectedHCO3 - hco3) / 0.35);

    // Calculate Expected pH
    double expectedPH = 7.4 -
        ((expectedPCO2 - 40) / 10 * 0.08) +
        ((expectedHCO3 - 24) / 10 * 0.15);

    MetabolicLevel metabolicState;
    if (hco3 == 24) {
      metabolicState = MetabolicLevel.normal;
    } else if (hco3 < 24) {
      metabolicState = MetabolicLevel.metabolicAcidosis;
    } else {
      metabolicState = MetabolicLevel.metabolicAlkalosis;
    }

    return FinalResult(
      findingLevel: metabolicState,
      findingNumber: hco3,
      additionalData: {
        'correctedAG': correctedAG,
        'expectedHCO3': expectedHCO3,
        'expectedPCO2': expectedPCO2,
        'expectedPH': expectedPH,
      },
    );
  }

  @override
  FinalResult<RespiratoryLevel> calculateRespiratoryState({
    required double pco2,
    required double hco3,
    required double ph,
  }) {
    double expectedPCO2 = 40 + ((hco3 - 24) * 1.5);

    RespiratoryLevel respiratoryState;
    if ((expectedPCO2 - pco2).abs() <= 2) {
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
    // Same implementation as Follow-up calculator
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

class AdmissionABGHighCalculator extends AdmissionABGCalculator {
  @override
  FinalResult<MetabolicLevel> calculateMetabolicState({
    required double sodium,
    required double chlorine,
    required double hco3,
    required double albumin,
  }) {
    // Calculate SID
    double sid = sodium - chlorine;

    // Calculate Expected HCO3
    double expectedHCO3 = hco3 + (36 - sid);

    // Calculate Expected PCO2
    double expectedPCO2 = 40 + ((expectedHCO3 - hco3) / 0.35);

    // Calculate Expected pH
    double expectedPH = 7.4 -
        ((expectedPCO2 - 40) / 10 * 0.08) +
        ((expectedHCO3 - 24) / 10 * 0.15);

    MetabolicLevel metabolicState;
    if (expectedHCO3 == hco3) {
      metabolicState = MetabolicLevel.normal;
    } else if (expectedHCO3 > hco3) {
      metabolicState = MetabolicLevel.metabolicAcidosis;
    } else {
      metabolicState = MetabolicLevel.metabolicAlkalosis;
    }

    return FinalResult(
      findingLevel: metabolicState,
      findingNumber: hco3,
      additionalData: {
        'sid': sid,
        'expectedHCO3': expectedHCO3,
        'expectedPCO2': expectedPCO2,
        'expectedPH': expectedPH,
      },
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
