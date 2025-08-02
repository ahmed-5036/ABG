// lib/providers/result/metabolic_result_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/abg_result.dart';
import '../../services/calculators/calculator_factory.dart';
import '../../services/enum.dart';
import '../calculator/calculator_result_provider.dart';
import '../input/input_state_provider.dart';
import '../patient_type_provider.dart';
import '../../resources/constants/calculation_constants.dart';
import 'respiratory_result_provider.dart';
import 'oxygenation_result_provider.dart';

final Provider<MetabolicLevel> metabolicResultProvider =
    Provider<MetabolicLevel>((Ref ref) {
  final ABGResult result = ref.watch(calculatorResultProvider);
  return result.metabolicResult.findingLevel;
});

final Provider<Map<String, dynamic>> metabolicDetailsProvider =
    Provider<Map<String, dynamic>>((Ref ref) {
  final ABGResult result = ref.watch(calculatorResultProvider);
  return result.metabolicResult.additionalData ?? <String, dynamic>{};
});

// Present Metabolic Change Providers

// BB (Buffer Base) Calculation Provider
final Provider<double> bbCalculationProvider = Provider<double>((Ref ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double hco3 = values['hco3'] ?? 0;
  final double ph = values['ph'] ?? 0;
  final double albumin = values['albumin'] ?? 0;

  return (hco3 == 0 || ph == 0) ? 0 : hco3 + ((2.5 * albumin) + 6);
});

// BB Result Provider
final Provider<MetabolicLevel> bbResultProvider =
    Provider<MetabolicLevel>((Ref ref) {
  final double bb = ref.watch(bbCalculationProvider);

  if (bb == 0) return MetabolicLevel.unknown;
  if (bb == 36) return MetabolicLevel.normal;
  if (bb > 36) return MetabolicLevel.metabolicAlkalosis;
  if (bb < 36) return MetabolicLevel.metabolicAcidosis;

  return MetabolicLevel.unknown;
});

// Corrected AG Present Provider
final Provider<double> correctedAGPresentProvider = Provider<double>((Ref ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double hco3 = values['hco3'] ?? 0;
  final double ph = values['ph'] ?? 0;
  final double sodium = values['sodium'] ?? 0;
  final double chlorine = values['chlorine'] ?? 0;
  final double albumin = values['albumin'] ?? 0;

  return (hco3 == 0 || ph == 0)
      ? 0
      : sodium - chlorine - hco3 + ((4 - albumin) * 2.5);
});

// Corrected AG Present Result Provider
final Provider<AGLevel> correctedAGPresentResultProvider =
    Provider<AGLevel>((Ref ref) {
  final double correctedAG = ref.watch(correctedAGPresentProvider);
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double hco3 = values['hco3'] ?? 0;
  final double ph = values['ph'] ?? 0;

  if (hco3 == 0 || ph == 0) return AGLevel.na;

  if (correctedAG == CalculationConstants.agNormalThreshold) {
    return AGLevel.normalAG;
  }
  if (correctedAG > CalculationConstants.agNormalThreshold) {
    return AGLevel.highAG;
  }
  if (correctedAG < CalculationConstants.agNormalThreshold) {
    return AGLevel.lowAG;
  }

  return AGLevel.na;
});

// SID Calculation Provider (for patient type one - uses regular chlorine)
final Provider<double> sidCalculationProvider = Provider<double>((Ref ref) {
  return (ref.watch(inputStateProvider).values['sodium'] ?? 1) -
      (ref.watch(inputStateProvider).values['chlorine'] ?? 1);
});

// SIG Provider
final Provider<double> sigProvider = Provider<double>((Ref ref) {
  return (ref.watch(inputStateProvider).values['hco3'] == 0 ||
          ref.watch(inputStateProvider).values['ph'] == 0)
      ? 0
      : (ref.watch(sidCalculationProvider)) -
          (ref.watch(bbCalculationProvider));
});

// SIG Result Provider
final Provider<SIGLevel> sigResultProvider = Provider<SIGLevel>((Ref ref) {
  final double sig = ref.watch(sigProvider);

  if (sig == 0) return SIGLevel.na;
  if (sig > 1) return SIGLevel.withFixedAcids;
  if (sig < 1) return SIGLevel.withNoFixedAcids;

  return SIGLevel.na;
});

// Corrected HCO3 Provider (needed for correlation)
final Provider<double> correctedHCO3ForCorrelationProvider =
    Provider<double>((Ref ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double hco3 = values['hco3'] ?? 0;
  final double pco2 = values['pco2'] ?? 0;

  if (hco3 == 0 || pco2 == 0) return 0;

  // Calculate corrected HCO3 based on PCO2
  if (pco2 > 40) {
    return hco3 + (0.35 * (pco2 - 40));
  } else if (pco2 < 40) {
    return hco3 - (0.35 * (40 - pco2));
  }

  return hco3;
});

// Correlation HCO3 Provider
final Provider<MetabolicLevel> correlationHCO3Provider =
    Provider<MetabolicLevel>((Ref ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double hco3 = values['hco3'] ?? 0;
  final double correctedHCO3 = ref.watch(correctedHCO3ForCorrelationProvider);

  if (hco3 == 0) return MetabolicLevel.unknown;

  if (correctedHCO3 == 24 && hco3 == 24) {
    return MetabolicLevel.normal;
  } else if (correctedHCO3 <= 24 && hco3 <= 24 && correctedHCO3 == hco3) {
    return MetabolicLevel.simpleMetabolicAcidosis;
  } else if (correctedHCO3 >= 24 && hco3 >= 24 && correctedHCO3 == hco3) {
    return MetabolicLevel.simpleMetabolicAlkalosis;
  } else if (correctedHCO3 < hco3) {
    return MetabolicLevel.mixedMetabolicAlkalosis;
  } else if (correctedHCO3 > hco3) {
    return MetabolicLevel.mixedMetabolicAcidosis;
  }

  return MetabolicLevel.unknown;
});

// AG2 Calculation Provider (for A-G column)
final Provider<double> aG2CalculationProvider = Provider<double>((Ref ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double sodium = values['sodium'] ?? 0;
  final double chlorine = values['chlorine'] ?? 0;
  final double hco3 = values['hco3'] ?? 0;

  return sodium - chlorine - hco3;
});

// Corrected HCO3 Two Correlation Provider (for correlation display)
final Provider<double> correctedHCO3TwoCorrelationProvider =
    Provider<double>((Ref ref) {
  return ref.watch(correctedHCO3ForCorrelationProvider);
});

// Diagnosis Second Result Provider
final Provider<String> diagnosisSecondResultProvider =
    Provider<String>((Ref ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double hco3 = values['hco3'] ?? 0;
  final double ph = values['ph'] ?? 0;

  if (hco3 == 0 || ph == 0) return CalculationConstants.noData;

  return "${ref.watch(correctedAGPresentResultProvider).level.$1}, ${ref.watch(metabolicResultProvider).level.$1}, (${ref.watch(correlationHCO3Provider).level.$1}), ${ref.watch(sigResultProvider).level.$1}";
});

// Start Metabolic State Providers

// CL/NA Calculation Provider
final Provider<int> clNaCalculationProvider = Provider<int>((Ref ref) {
  // final calculatorType = ref.watch(calculatorTypeProvider);
  //
  // // For High ABG, use the specific High ABG CL/NA calculation
  // if (calculatorType == CalculatorType.admissionABGHigh) {
  //   return (ref.watch(clNaHighABGProvider) * 100).floor();
  // }

  // For other calculations, use existing logic
  double calVal = ref.watch(patientTypeProvider) == PatientType.patientTypeOne
      ? (ref.watch(inputStateProvider).values['chlorine'] ?? 1)
      : ref.watch(correctedCLProvider);

  return (ref.watch(inputStateProvider).values['sodium'] ?? 0) < 0
      ? 0
      : ((calVal / (ref.watch(inputStateProvider).values['sodium'] ?? 1)) * 100)
          .floor();
});

// CL/NA Result Provider
final Provider<CLNaLevel> clNaResultProvider = Provider<CLNaLevel>((Ref ref) {
  final CalculatorType calculatorType = ref.watch(calculatorTypeProvider);

  // For High ABG, use the percentage value for result determination
  if (calculatorType == CalculatorType.admissionABGHigh) {
    final int clNaPercentage =
        ref.watch(clNaCalculationProvider); // Percentage value

    if (clNaPercentage == 0) return CLNaLevel.na;
    if (clNaPercentage == CalculationConstants.normalClNaThreshold) {
      return CLNaLevel.normalOrHemo;
    }
    if (clNaPercentage > CalculationConstants.normalClNaThreshold) {
      return CLNaLevel.hyperTwoCases;
    }
    if (clNaPercentage < CalculationConstants.normalClNaThreshold) {
      return CLNaLevel.hypoTwoCases;
    }

    return CLNaLevel.na;
  }

  // For other calculations, use existing logic
  final int clNa = ref.watch(clNaCalculationProvider);

  if (clNa == 0) return CLNaLevel.na;
  if (clNa == CalculationConstants.normalClNaThreshold) {
    return CLNaLevel.normalOrHemo;
  }
  if (clNa > CalculationConstants.normalClNaThreshold) {
    return CLNaLevel.hyperTwoCases;
  }
  if (clNa < CalculationConstants.normalClNaThreshold) {
    return CLNaLevel.hypoTwoCases;
  }

  return CLNaLevel.na;
});

// SID Calculation Provider (for patient type two - uses corrected chlorine)
final Provider<double> sidCalculationTypeTwoPatientProvider =
    Provider<double>((Ref ref) {
  return (ref.watch(inputStateProvider).values['sodium'] ?? 0) -
      (ref.watch(correctedCLProvider));
});

// General SID Provider (returns data according to patient type and calculator type)
final Provider<double> sidGeneralProvider = Provider<double>((Ref ref) {
  final CalculatorType calculatorType = ref.watch(calculatorTypeProvider);

  // For High ABG, use the patient type two SID calculation (same as High ABG)
  if (calculatorType == CalculatorType.admissionABGHigh) {
    return ref.watch(sidCalculationTypeTwoPatientProvider);
  }

  // For other calculations, use patient type logic
  switch (ref.watch(patientTypeProvider)) {
    case PatientType.patientTypeOne:
      return ref.watch(sidCalculationProvider);
    case PatientType.patientTypeTwo:
      return ref.watch(sidCalculationTypeTwoPatientProvider);
    default:
      return 0;
  }
});

// SID Result Provider
final Provider<MetabolicLevel> sidResultProvider =
    Provider<MetabolicLevel>((Ref ref) {
  final CalculatorType calculatorType = ref.watch(calculatorTypeProvider);

  double normalThreshold;

  // For High ABG, use the regular SID threshold
  if (calculatorType == CalculatorType.admissionABGHigh) {
    normalThreshold = CalculationConstants.sidNormalThreshold;
  } else {
    // For other calculations, use patient type logic
    normalThreshold =
        ref.watch(patientTypeProvider) == PatientType.patientTypeOne
            ? CalculationConstants.sidNormalThreshold
            : CalculationConstants.sidNormalTypeTwoThreshold;
  }

  if (ref.watch(sidGeneralProvider) == normalThreshold) {
    return MetabolicLevel.normal;
  } else if (ref.watch(sidGeneralProvider) > normalThreshold) {
    return MetabolicLevel.metabolicAlkalosis;
  } else if (ref.watch(sidGeneralProvider) < normalThreshold) {
    return MetabolicLevel.metabolicAcidosis;
  } else {
    return MetabolicLevel.unknown;
  }
});

// Corrected HCO3 Provider (general)
final Provider<double?> correctedHCO3Provider = Provider<double?>((Ref ref) {
  final bool isPatientTypeOne =
      ref.watch(patientTypeProvider) == PatientType.patientTypeOne;
  return isPatientTypeOne
      ? ref.watch(correctedHCO3TypeOneProvider)
      : ref.watch(correctedHCO3TypeTwoProvider);
});

// Corrected HCO3 Type One Provider
final Provider<double?> correctedHCO3TypeOneProvider =
    Provider<double?>((Ref ref) {
  return (ref.watch(inputStateProvider).values['potassium'] == 0 ||
          ref.watch(inputStateProvider).values['sodium'] == 0)
      ? 0
      : (ref.watch(inputStateProvider).values['hco3'] ?? 0) +
          (ref.watch(aG2CalculationProvider) - 12);
});

// Corrected HCO3 Type Two Provider
final Provider<double?> correctedHCO3TypeTwoProvider =
    Provider<double?>((Ref ref) {
  return (ref.watch(inputStateProvider).values['potassium'] == 0 ||
          ref.watch(inputStateProvider).values['sodium'] == 0)
      ? 0
      : 24 + (36 - ref.watch(sidCalculationProvider));
});

// Corrected HCO3 Two Correlation Provider (for Start Metabolic State)
final Provider<double?> correctedHCO3TwoCorrelationStartProvider =
    Provider<double?>((Ref ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double potassium = values['potassium'] ?? 0;
  final double sodium = values['sodium'] ?? 0;
  final double hco3 = values['hco3'] ?? 0;
  final double correctedAG = ref.watch(correctedAGPresentProvider);

  return (potassium == 0 || sodium == 0) ? 0 : hco3 + (correctedAG - 12);
});

// Corrected HCO3 Result Provider (for Start Metabolic State)
final Provider<MetabolicLevel> correctedHCO3ResultProvider =
    Provider<MetabolicLevel>((Ref ref) {
  switch (ref.watch(correctedHCO3Provider)) {
    case null:
    case 0:
      return MetabolicLevel.unknown;
    case == 24:
      return MetabolicLevel.normal;
    case < 24:
      return MetabolicLevel.metabolicAcidosis;
    case > 24:
      return MetabolicLevel.metabolicAlkalosis;
    default:
      return MetabolicLevel.unknown;
  }
});

// Corrected AG Start Provider
final Provider<double> correctedAGStartProvider = Provider<double>((Ref ref) {
  final CalculatorType calculatorType = ref.watch(calculatorTypeProvider);

  // For High ABG, use the specific High ABG corrected AG calculation
  if (calculatorType == CalculatorType.admissionABGHigh) {
    return ref.watch(correctedAGHighABGProvider);
  }

  // For other calculations, use existing logic
  double naRes = ref.watch(inputStateProvider).values['sodium'] ?? 0;
  double clRes = ref.watch(patientTypeProvider) == PatientType.patientTypeOne
      ? ref.watch(inputStateProvider).values['chlorine'] ?? 0
      : ref.watch(correctedCLProvider);
  double hco3Res = ref.watch(correctedHCO3Provider) ?? 0;
  double albuminRes = ref.watch(inputStateProvider).values['albumin'] ?? 0;

  return (ref.watch(inputStateProvider).values['hco3'] == 0 ||
          ref.watch(inputStateProvider).values['ph'] == 0)
      ? 0
      : (naRes - clRes - hco3Res) + ((4 - albuminRes) * 2.5);
});

// Corrected AG Start Result Provider
final Provider<String> correctedAGStartResultProvider =
    Provider<String>((Ref ref) {
  AGLevel result = (ref.watch(inputStateProvider).values['hco3'] == 0 ||
          ref.watch(inputStateProvider).values['ph'] == 0)
      ? AGLevel.na
      : ref.watch(correctedAGStartProvider) ==
              CalculationConstants.agNormalThreshold
          ? AGLevel.normalAG
          : ref.watch(correctedAGStartProvider) >
                  CalculationConstants.agNormalThreshold
              ? AGLevel.highAG
              : ref.watch(correctedAGStartProvider) <
                      CalculationConstants.agNormalThreshold
                  ? AGLevel.lowAG
                  : AGLevel.na;
  return result.level.$1;
});

// Diagnosis One Result Provider
final Provider<String> diagnosisOneResultProvider = Provider<String>((Ref ref) {
  return (ref.watch(inputStateProvider).values['potassium'] == 0) ||
          (ref.watch(inputStateProvider).values['albumin'] == 0) ||
          (ref.watch(inputStateProvider).values['sodium'] == 0) ||
          (ref.watch(inputStateProvider).values['chlorine'] == 0)
      ? CalculationConstants.noData
      : "${ref.watch(correctedAGStartResultProvider)}, ${ref.watch(clNaResultProvider).level.$1}, ${ref.watch(correctedHCO3ResultProvider).level.$1}";
});

// Final Diagnosis Result Provider
final Provider<String> finalDiagnosisResultProvider =
    Provider<String>((Ref ref) {
  return (ref.watch(diagnosisOneResultProvider) ==
              CalculationConstants.noData) ||
          (ref.watch(diagnosisSecondResultProvider) ==
              CalculationConstants.noData) ||
          (ref.watch(diagnosisThirdResultProvider) ==
              CalculationConstants.noData) ||
          (ref.watch(diagnosisFourthResultProvider).level.$1 ==
              CalculationConstants.noData)
      ? "INCOMPLETE MEASURED ITEMS, PLEASE FILL THE INPUT FIELDS IN ANALYSIS PAGE"
      : "This Patient had ${ref.watch(diagnosisOneResultProvider)}, then developed ${ref.watch(diagnosisSecondResultProvider)}, with ${ref.watch(diagnosisThirdResultProvider)}, and ${ref.watch(diagnosisFourthResultProvider).level.$1}";
});

// Follow-up ABG Final Diagnosis Result Provider
final Provider<String> followUpABGFinalDiagnosisResultProvider =
    Provider<String>((Ref ref) {
  final CalculatorType calculatorType = ref.watch(calculatorTypeProvider);

  // Only for Follow-up ABG calculations
  if (calculatorType != CalculatorType.followUpABGMetabolic &&
      calculatorType != CalculatorType.followUpABGRespiratory) {
    return ref.watch(finalDiagnosisResultProvider);
  }

  return (ref.watch(diagnosisSecondResultProvider) ==
              CalculationConstants.noData) ||
          (ref.watch(diagnosisThirdResultProvider) ==
              CalculationConstants.noData) ||
          (ref.watch(diagnosisFourthResultProvider).level.$1 ==
              CalculationConstants.noData)
      ? "INCOMPLETE MEASURED ITEMS, PLEASE FILL THE INPUT FIELDS IN ANALYSIS PAGE"
      : calculatorType == CalculatorType.followUpABGMetabolic
          ? "Patient has ${ref.watch(metabolicStateDiagnosisProvider)} with ${ref.watch(diagnosisThirdResultProvider)} and ${ref.watch(diagnosisFourthResultProvider).level.$1}"
          : "Patient has ${ref.watch(diagnosisThirdResultProvider)} with ${ref.watch(respiratoryMetabolicStateDiagnosisProvider)} and ${ref.watch(diagnosisFourthResultProvider).level.$1}";
});

// Corrected CL Provider
final Provider<double> correctedCLProvider = Provider<double>((Ref ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double hco3Val = values['hco3'] ?? 0;
  final double correctedHco3Val = ref.watch(correctedHCO3Provider) ?? 0;
  final double clVal = values['chlorine'] ?? 0;

  // Corrected CL formula: (hco3Val - correctedHco3Val) + clVal
  return (hco3Val - correctedHco3Val) + clVal;
});

// Corrected CL Result Provider
final Provider<CLNaLevel> correctedCLProviderResult =
    Provider<CLNaLevel>((Ref ref) {
  double clValue = ref.watch(correctedCLProvider);
  switch (clValue) {
    case > CalculationConstants.hypoCorrectedchloremicThreshold &&
          < CalculationConstants.hyperCorrectedchloremicThreshold:
      return CLNaLevel.normal;

    case > CalculationConstants.hyperCorrectedchloremicThreshold:
      return CLNaLevel.hyper;
    case < CalculationConstants.hypoCorrectedchloremicThreshold:
      return CLNaLevel.hypo;

    default:
      return CLNaLevel.na;
  }
});

// High ABG Specific Providers

// CL/NA for High ABG (uses raw ratio, not percentage)
final Provider<double> clNaHighABGProvider = Provider<double>((Ref ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double sodium = values['sodium'] ?? 0;
  final double chlorine = values['chlorine'] ?? 0;

  return sodium > 0 ? chlorine / sodium : 0;
});

// Corrected AG for High ABG (uses regular chlorine, not corrected)
final Provider<double> correctedAGHighABGProvider = Provider<double>((Ref ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double sodium = values['sodium'] ?? 0;
  final double chlorine = values['chlorine'] ?? 0;
  final double hco3 = values['hco3'] ?? 0;
  final double albumin = values['albumin'] ?? 0;

  return (sodium - chlorine - hco3) + ((4 - albumin) * 2.5);
});

// Metabolic State Diagnosis Provider for Primary Metabolic Insult
final Provider<String> metabolicStateDiagnosisProvider = Provider<String>((Ref ref) {
  final CalculatorType calculatorType = ref.watch(calculatorTypeProvider);
  
  // Only for primary metabolic insult
  if (calculatorType != CalculatorType.followUpABGMetabolic) {
    return ref.watch(diagnosisSecondResultProvider);
  }

  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double hco3 = values['hco3'] ?? 0;
  final double sodium = values['sodium'] ?? 0;
  final double chlorine = values['chlorine'] ?? 0;
  final double albumin = values['albumin'] ?? 0;

  // Determine HCO3 status
  String hco3Status = '';
  if (hco3 == 24) {
    hco3Status = 'Normal Metabolic';
  } else if (hco3 < 24) {
    hco3Status = 'Metabolic Acidosis';
  } else {
    hco3Status = 'Metabolic Alkalosis';
  }

  // Determine CL status
  String clStatus = '';
  if (chlorine > 107) {
    clStatus = 'Hyperchloremic';
  } else if (chlorine < 97) {
    clStatus = 'Hypochloremic';
  } else {
    clStatus = 'Normo-chloremic';
  }

  // Determine Corrected AG status
  double correctedAG = (sodium - chlorine - hco3) + ((4 - albumin) * 2.5);
  String agStatus = '';
  if (correctedAG > 12) {
    agStatus = 'High AG';
  } else if (correctedAG < 12) {
    agStatus = 'Low AG';
  } else {
    agStatus = 'Normal AG';
  }

  // Concatenate the results in a readable format
  return "$hco3Status with $clStatus and $agStatus";
});

// Respiratory Metabolic State Diagnosis Provider for Primary Respiratory Insult
final Provider<String> respiratoryMetabolicStateDiagnosisProvider = Provider<String>((Ref ref) {
  final CalculatorType calculatorType = ref.watch(calculatorTypeProvider);
  
  // Only for primary respiratory insult
  if (calculatorType != CalculatorType.followUpABGRespiratory) {
    return ref.watch(diagnosisSecondResultProvider);
  }

  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double hco3 = values['hco3'] ?? 0;
  final double pco2 = values['pco2'] ?? 0;
  final double sodium = values['sodium'] ?? 0;
  final double chlorine = values['chlorine'] ?? 0;
  final double albumin = values['albumin'] ?? 0;

  // 1. Measured HCO3 status
  String measuredHCO3Status = '';
  if (hco3 == 24) {
    measuredHCO3Status = 'Normal HCO3';
  } else if (hco3 < 24) {
    measuredHCO3Status = 'Low HCO3';
  } else {
    measuredHCO3Status = 'High HCO3';
  }

  // 2. Expected HCO3 (just show the value, no status needed)
  double expectedHCO3 = pco2 < 40 ? 24 - ((40 - pco2) * 0.1) : 24 - ((40 - pco2) * 0.2);
  String expectedHCO3Status = 'Expected HCO3 ${expectedHCO3.toStringAsFixed(1)}';

  // 3. Expected vs Measured HCO3 (compensation logic)
  String compensationStatus = '';
  if (expectedHCO3 == hco3) {
    if (hco3 == 24) {
      compensationStatus = 'Normal compensation';
    } else if (hco3 > 24) {
      compensationStatus = 'Compensatory metabolic alkalosis';
    } else {
      compensationStatus = 'Compensatory metabolic acidosis';
    }
  } else if (expectedHCO3 > hco3) {
    compensationStatus = 'Non-compensatory metabolic acidosis';
  } else {
    compensationStatus = 'Non-compensatory metabolic alkalosis';
  }

  // 4. Measured Chloride status
  String clStatus = '';
  if (chlorine > 107) {
    clStatus = 'Hyperchloremia';
  } else if (chlorine < 97) {
    clStatus = 'Hypochloremia';
  } else {
    clStatus = 'Normochloremia';
  }

  // 5. Corrected AG status
  double correctedAG = (sodium - chlorine - hco3) + ((4 - albumin) * 2.5);
  String agStatus = '';
  if (correctedAG > 12) {
    agStatus = 'High AG';
  } else if (correctedAG < 12) {
    agStatus = 'Low AG';
  } else {
    agStatus = 'Normal AG';
  }

  // Concatenate the results in a readable format
  return " $compensationStatus with $clStatus and $agStatus";
});
