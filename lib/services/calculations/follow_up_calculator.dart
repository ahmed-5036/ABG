import '../../models/abg_result.dart';
import '../enum.dart';
import 'base_calculator.dart';

// Base calculator for Follow-up ABG
abstract class FollowUpABGCalculator implements ABGCalculator {
  @override
  String getFinalDiagnosis({
    required String metabolicDiagnosis,
    required String respiratoryDiagnosis,
    required String oxygenationDiagnosis,
  }) {
    return "This Patient had $metabolicDiagnosis, then developed $respiratoryDiagnosis, with $oxygenationDiagnosis";
  }
}

// Metabolic Primary Insult Calculator
class MetabolicPrimaryCalculator extends FollowUpABGCalculator {
  @override
  FinalResult<MetabolicLevel> calculateMetabolicState({
    required double sodium,
    required double chlorine,
    required double hco3,
    required double albumin,
  }) {
    // Calculate SID2 (Strong Ion Difference)
    double sid2 = sodium - chlorine;

    // Calculate BB (Buffer Base)
    double bb = hco3 + 6 + (albumin * 2.5);

    // Calculate Corrected AG2
    double correctedAG2 = (sodium - chlorine - hco3) + ((4 - albumin) * 2.5);

    // Determine metabolic state based on HCO3
    MetabolicLevel metabolicState;
    if (hco3 == 24) {
      metabolicState = MetabolicLevel.normal;
    } else if (hco3 < 24) {
      if (sid2 < 36) {
        metabolicState = MetabolicLevel.simpleMetabolicAcidosis;
      } else {
        metabolicState = MetabolicLevel.mixedMetabolicAcidosis;
      }
    } else {
      if (sid2 > 36) {
        metabolicState = MetabolicLevel.simpleMetabolicAlkalosis;
      } else {
        metabolicState = MetabolicLevel.mixedMetabolicAlkalosis;
      }
    }

    return FinalResult(
      findingLevel: metabolicState,
      findingNumber: hco3,
      additionalData: {
        'sid2': sid2,
        'bb': bb,
        'correctedAG2': correctedAG2,
      },
    );
  }

  @override
  FinalResult<RespiratoryLevel> calculateRespiratoryState({
    required double pco2,
    required double hco3,
    required double ph,
  }) {
    // Calculate Expected PCO2 for metabolic cases
    double expectedPCO2;
    if (hco3 < 24) {
      expectedPCO2 = 40 - ((24 - hco3) * 1.2);
    } else {
      expectedPCO2 = 40 - ((24 - hco3) * 0.6);
    }

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

// Respiratory Primary Insult Calculator
class RespiratoryPrimaryCalculator extends FollowUpABGCalculator {
  @override
  FinalResult<MetabolicLevel> calculateMetabolicState({
    required double sodium,
    required double chlorine,
    required double hco3,
    required double albumin,
  }) {
    // Calculate Expected HCO3 for respiratory cases
    double expectedHCO3;
    if (hco3 < 40) {
      expectedHCO3 = 24 - ((40 - hco3) * 0.1);
    } else {
      expectedHCO3 = 24 - ((40 - hco3) * 0.2);
    }

    MetabolicLevel metabolicState;
    if (expectedHCO3 == hco3) {
      if (hco3 == 24) {
        metabolicState = MetabolicLevel.normal;
      } else if (hco3 > 24) {
        metabolicState = MetabolicLevel.simpleMetabolicAlkalosis;
      } else {
        metabolicState = MetabolicLevel.simpleMetabolicAcidosis;
      }
    } else if (expectedHCO3 > hco3) {
      metabolicState = MetabolicLevel.mixedMetabolicAcidosis;
    } else {
      metabolicState = MetabolicLevel.mixedMetabolicAlkalosis;
    }

    return FinalResult(
      findingLevel: metabolicState,
      findingNumber: hco3,
      additionalData: {'expectedHCO3': expectedHCO3},
    );
  }

  @override
  FinalResult<RespiratoryLevel> calculateRespiratoryState({
    required double pco2,
    required double hco3,
    required double ph,
  }) {
    RespiratoryLevel respiratoryState;
    if (pco2 == 40) {
      respiratoryState = RespiratoryLevel.normocarbia;
    } else if (pco2 > 40) {
      respiratoryState = RespiratoryLevel.hypoVentilatoryRespiratoryAcidosis;
    } else {
      respiratoryState = RespiratoryLevel.hyperVentilatoryRespiratoryAlkalosis;
    }

    return FinalResult(
      findingLevel: respiratoryState,
      findingNumber: pco2,
    );
  }

  @override
  FinalResult<OxygenWaterLevel> calculateOxygenationState({
    required double fio2,
    required double pco2,
    required double pao2,
    required double age,
  }) {
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

// Factory to get the appropriate calculator
enum FollowUpType {
  metabolic,
  respiratory,
}

class ABGCalculatorFactory {
  static ABGCalculator getCalculator(FollowUpType type) {
    switch (type) {
      case FollowUpType.metabolic:
        return MetabolicPrimaryCalculator();
      case FollowUpType.respiratory:
        return RespiratoryPrimaryCalculator();
      default:
        throw Exception('Invalid calculator type');
    }
  }
}
