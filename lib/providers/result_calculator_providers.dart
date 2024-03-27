import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../resources/constants/calculation_constants.dart';
import '../services/enum.dart';
import '../services/logger.dart';
import '../views/organism/table_four_diagnosis.dart';
import '../views/organism/table_one_diagnosis.dart';
import '../views/organism/table_three_diagnosis.dart';
import '../views/organism/table_two_diagnosis.dart';
import '../views/pages/patient_type_selection.dart';
import 'input_calculator_provider.dart';

//--------------------First Section-------------------------

final Provider<int> clNaCalculationProvider =
    Provider<int>((ProviderRef<int> ref) {
  double calVal = ref.watch(patientTypeProvider) == PatientType.patientTypeOne
      ? (ref.watch(chlorineNotifierProvider).findingNumber ?? 1)
      : ref.watch(correctedCLProvider) ?? 0;

  return (ref.watch(sodiumNotifierProvider).findingNumber ?? 0) < 0
      ? 0
      : ((calVal / (ref.watch(sodiumNotifierProvider).findingNumber ?? 1)) *
              100)
          .floor();
});
final Provider<CLNaLevel> clNaResultProvider =
    Provider<CLNaLevel>((ProviderRef<CLNaLevel> ref) {
  switch (ref.watch(clNaCalculationProvider)) {
    case 0:
      return CLNaLevel.na;
    case == CalculationConstants.normalClNaThreshold:
      return CLNaLevel.normalOrHemo;
    case > CalculationConstants.normalClNaThreshold:
      return CLNaLevel.hyperTwoCases;
    case < CalculationConstants.normalClNaThreshold:
      return CLNaLevel.hypoTwoCases;

    default:
      return CLNaLevel.na;
  }
});

final Provider<double> sidCalculationProvider =
    Provider<double>((ProviderRef<double> ref) {
  return (ref.watch(sodiumNotifierProvider).findingNumber ?? 1) -
      (ref.watch(chlorineNotifierProvider).findingNumber ?? 1);
});
final Provider<double> sidCalculationTypeTwoPatientProvider =
    Provider<double>((ProviderRef<double> ref) {
  return (ref.watch(sodiumNotifierProvider).findingNumber ?? 0) -
      (ref.watch(correctedCLProvider) ?? 0);
});

//this sid will return data according to patien type
final Provider<double> sidGeneralProvider =
    Provider<double>((ProviderRef<double> ref) {
  switch (ref.watch(patientTypeProvider)) {
    case PatientType.patientTypeOne:
      return ref.watch(sidCalculationProvider);
    case PatientType.patientTypeTwo:
      return ref.watch(sidCalculationTypeTwoPatientProvider);

    default:
      return 0;
  }
});

final Provider<MetabolicLevel> sidResultProvider =
    Provider<MetabolicLevel>((ProviderRef<MetabolicLevel> ref) {
  double normalThreshold =
      ref.watch(patientTypeProvider) == PatientType.patientTypeOne
          ? CalculationConstants.sidNormalThreshold
          : CalculationConstants.sidNormalTypeTwoThreshold;

  if (ref.watch(sidGeneralProvider) == normalThreshold) {
    return MetabolicLevel.normal;
  } else if (ref.watch(sidGeneralProvider) > normalThreshold) {
    return MetabolicLevel.metabolicAlkalosis;
  } else if (ref.watch(sidGeneralProvider) < normalThreshold) {
    return MetabolicLevel.metabolicAlkalosis;
  } else {
    return MetabolicLevel.na;
  }
});

final Provider<double?> correctedHCO3Provider =
    Provider<double?>((ProviderRef<double?> ref) {
  final bool isPatientTypeOne =
      ref.watch(patientTypeProvider) == PatientType.patientTypeOne;
  return isPatientTypeOne
      ? ref.watch(correctedHCO3TypeOneProvider)
      : ref.watch(correctedHCO3TypeTwoProvider);
});

final Provider<double?> correctedHCO3TypeOneProvider =
    Provider<double?>((ProviderRef<double?> ref) {
  return (ref.watch(potassiumNotifierProvider).findingNumber == 0 ||
          ref.watch(sodiumNotifierProvider).findingNumber == 0)
      ? 0

      ///[Old Calculations]
      : (ref.watch(hco3NotifierProvider).findingNumber ?? 0) +
          (ref.watch(aG2CalculationProvider) - 12);
  //Sid2 in the last sheet
  ///[https://docs.google.com/spreadsheets/d/1AnluS_vj5SXzkDmPUZIIU1xj5xKksgNJt-YLGQj2i9Q/edit#gid=2132098061]
});
final Provider<double?> correctedHCO3TypeTwoProvider =
    Provider<double?>((ProviderRef<double?> ref) {
  return (ref.watch(potassiumNotifierProvider).findingNumber == 0 ||
          ref.watch(sodiumNotifierProvider).findingNumber == 0)
      ? 0

      ///[Old Calculations]
      // : (ref.watch(hco3NotifierProvider).findingNumber ?? 0) +
      //     (ref.watch(aG2CalculationProvider) - 12);
      : 24 + (36 - ref.watch(sidCalculationProvider)); //Sid2 in the last sheet
  ///[https://docs.google.com/spreadsheets/d/1AnluS_vj5SXzkDmPUZIIU1xj5xKksgNJt-YLGQj2i9Q/edit#gid=2132098061]
});

final Provider<double?> correctedHCO3TwoCorrelationProvider =
    Provider<double?>((ProviderRef<double?> ref) {
  return (ref.watch(potassiumNotifierProvider).findingNumber == 0 ||
          ref.watch(sodiumNotifierProvider).findingNumber == 0)
      ? 0
      : (ref.watch(hco3NotifierProvider).findingNumber ?? 0) +
          (ref.watch(correctedAGPresentProvider) - 12);
});

final Provider<MetabolicLevel> correctedHCO3ResultProvider =
    Provider<MetabolicLevel>((ProviderRef<MetabolicLevel> ref) {
  switch (ref.watch(correctedHCO3Provider)) {
    case null:
    case 0:
      return MetabolicLevel.na;
    case == 24:
      return MetabolicLevel.normal;
    case < 24:
      return MetabolicLevel.metabolicAcidosis;
    case > 24:
      return MetabolicLevel.metabolicAlkalosis;
    default:
      return MetabolicLevel.na;
  }
});

final Provider<String> diagnosisOneResultProvider =
    Provider<String>((ProviderRef<String> ref) {
  return (ref.watch(potassiumNotifierProvider).findingNumber == 0) ||
          (ref.watch(albuminNotifierProvider).findingNumber == 0) ||
          (ref.watch(sodiumNotifierProvider).findingNumber == 0) ||
          (ref.watch(chlorineNotifierProvider).findingNumber == 0)
      ? CalculationConstants.noData
      // : "${ref.watch(sodiumNotifierProvider).findingLevel.level.$1} ${ref.watch(chlorineNotifierProvider).findingLevel.level.$1} ${ref.watch(sidResultProvider).level.$1} ${ref.watch(correctedAGStartResultProvider)}";
      // : "Patient had ${ref.watch(chlorineNotifierProvider).findingLevel.level.$1} ${ref.watch(sodiumNotifierProvider).findingLevel.level.$1} ${ref.watch(correctedAGStartResultProvider)}  ${ref.watch(correctedHCO3ResultProvider).level.$1}";
      : "${ref.watch(correctedAGStartResultProvider)}, ${ref.watch(chlorineNotifierProvider).findingLevel.level.$1}, ${ref.watch(correctedHCO3ResultProvider).level.$1}";
});

//--------------------First Section-------------------------

//--------------------Second Section-------------------------

final Provider<double> bbCalculationProvider =
    Provider<double>((ProviderRef<double> ref) {
  return (ref.watch(hco3NotifierProvider).findingNumber == 0 ||
          ref.watch(phNotifierProvider).findingNumber == 0)
      ? 0
      : (ref.watch(hco3NotifierProvider).findingNumber ?? 0) +
          ((2.5 * (ref.watch(albuminNotifierProvider).findingNumber ?? 0)) + 6);
});

final Provider<MetabolicLevel> bbResultProvider =
    Provider<MetabolicLevel>((ProviderRef<MetabolicLevel> ref) {
  switch (ref.watch(bbCalculationProvider)) {
    case 0:
      return MetabolicLevel.na;
    case == 36:
      return MetabolicLevel.normal;
    case > 36:
      return MetabolicLevel.metabolicAlkalosis;
    case < 36:
      return MetabolicLevel.metabolicAcidosis;

    default:
      return MetabolicLevel.na;
  }
});

final Provider<double> correctedAGPresentProvider =
    Provider<double>((ProviderRef<double> ref) {
  //Guarding before entering equation
  return (ref.watch(hco3NotifierProvider).findingNumber == 0 ||
          ref.watch(phNotifierProvider).findingNumber == 0)
      ? 0
      //Guarding before entering equation
      : (ref.watch(sodiumNotifierProvider).findingNumber ?? 0) -
          (ref.watch(chlorineNotifierProvider).findingNumber ?? 0) -
          (ref.watch(hco3NotifierProvider).findingNumber ?? 0) +
          ((4 - (ref.watch(albuminNotifierProvider).findingNumber ?? 0)) * 2.5);
});

//TODO Issues: 1
//TODO 1 - : Corrected Ag Start
final Provider<double> correctedAGStartProvider =
    Provider<double>((ProviderRef<double> ref) {
  //Guarding before entering equation
  double naRes = ref.watch(sodiumNotifierProvider).findingNumber ?? 0;
  LogManager.logToConsole(naRes, "na:");
  double clRes = ref.watch(patientTypeProvider) == PatientType.patientTypeOne
      ? ref.watch(chlorineNotifierProvider).findingNumber ?? 0
      : ref.watch(correctedCLProvider) ?? 0;
  LogManager.logToConsole(clRes, "cl:");

  double hco3Res = ref.watch(correctedHCO3Provider) ?? 0;
  LogManager.logToConsole(hco3Res, "hco3Res:");
  double albuminRes = ref.watch(albuminNotifierProvider).findingNumber ?? 0;
  LogManager.logToConsole(albuminRes, "albuminRes:");

  return (ref.watch(hco3NotifierProvider).findingNumber == 0 ||
          ref.watch(phNotifierProvider).findingNumber == 0)
      ? 0
      //Guarding before entering equation
      // : (naRes - clRes - hco3Res) + ((4 - albuminRes) * 2.5);
      : (naRes - clRes - hco3Res) + ((4 - albuminRes) * 2.5);
});

final Provider<String> correctedAGStartResultProvider =
    Provider<String>((ProviderRef<String> ref) {
  //Guarding before entering equation
  AGLevel result = (ref.watch(hco3NotifierProvider).findingNumber == 0 ||
          ref.watch(phNotifierProvider).findingNumber == 0)
      ? AGLevel.na
//Guarding before entering equation

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
  //old data : return "${result.level.$1} and AG: ${ref.watch(aG2CalculationProvider)}";
  //old data 2 return "${result.level.$1} and AG: ${ref.watch(aG2CalculationProvider)}";
  // return "${result.level.$1} and AG: ${ref.watch(aG2CalculationProvider)}";
  return result.level.$1;
});

final Provider<AGLevel> correctedAGPresentResultProvider =
    Provider<AGLevel>((ProviderRef<AGLevel> ref) {
  //Guarding before entering equation
  return (ref.watch(hco3NotifierProvider).findingNumber == 0 ||
          ref.watch(phNotifierProvider).findingNumber == 0)
      ? AGLevel.na
//Guarding before entering equation

      : ref.watch(correctedAGPresentProvider) ==
              CalculationConstants.agNormalThreshold
          ? AGLevel.normalAG
          : ref.watch(correctedAGPresentProvider) >
                  CalculationConstants.agNormalThreshold
              ? AGLevel.highAG
              : ref.watch(correctedAGPresentProvider) <
                      CalculationConstants.agNormalThreshold
                  ? AGLevel.lowAG
                  : AGLevel.na;
});

final Provider<double> sigProvider =
    Provider<double>((ProviderRef<double> ref) {
  return (ref.watch(hco3NotifierProvider).findingNumber == 0 ||
          ref.watch(phNotifierProvider).findingNumber == 0)
      ? 0
      : (ref.watch(sidCalculationProvider)) -
          (ref.watch(bbCalculationProvider));
});

final Provider<SIGLevel> sigResultProvider =
    Provider<SIGLevel>((ProviderRef<SIGLevel> ref) {
  return ref.watch(sigProvider) == 0
      ? SIGLevel.na
      : ref.watch(sigProvider) > 1
          ? SIGLevel.withFixedAcids
          : ref.watch(sigProvider) < 1
              ? SIGLevel.withNoFixedAcids
              : SIGLevel.na;
});

// =IFS(B10=0,"N/A",AND(B8=24,B10=24),"NORMAL METABOLIC STATE",AND(B8<24,B10<24,B8=B10),"SIMPLE METABOLIC ACIDOSIS",AND(B8>24,B10>24,B8=B10),"SIMPLE METABOLIC ALKALOSIS",B8<10,"METABOLIC ALKALOSIS",B8>10,"METABOLIC ACIDOSIS")

//"SIMPLE METABOLIC ALKALOSIS",B8<10,"METABOLIC ALKALOSIS",B8>10,"METABOLIC ACIDOSIS")

final Provider<MetabolicLevel> correlationHCO3Provider =
    Provider<MetabolicLevel>((ProviderRef<MetabolicLevel> ref) {
  if (ref.watch(hco3NotifierProvider).findingNumber == 0) {
    return MetabolicLevel.na;
  } else if (ref.watch(correctedHCO3Provider) == 24 &&
      ref.watch(hco3NotifierProvider).findingNumber == 24) {
    return MetabolicLevel.normal;
  } else if ((ref.watch(correctedHCO3Provider) ?? 0) <= 24 &&
      (ref.watch(hco3NotifierProvider).findingNumber ?? 0) <= 24 &&
      (ref.watch(correctedHCO3Provider) ==
          ref.watch(hco3NotifierProvider).findingNumber)) {
    return MetabolicLevel.simpleMetabolicAcidosis;
  } else if ((ref.watch(correctedHCO3Provider) ?? 0) >= 24 &&
      (ref.watch(hco3NotifierProvider).findingNumber ?? 0) >= 24 &&
      (ref.watch(correctedHCO3Provider) ==
          ref.watch(hco3NotifierProvider).findingNumber)) {
    return MetabolicLevel.simpleMetabolicAlkalosis;
  } else if ((ref.watch(correctedHCO3Provider)! <
      ref.watch(hco3NotifierProvider).findingNumber!)) {
    return MetabolicLevel.mixedMetabolicAlkalosis;
  } else if ((ref.watch(correctedHCO3Provider)! >
      ref.watch(hco3NotifierProvider).findingNumber!)) {
    return MetabolicLevel.mixedMetabolicAcidosis;
  } else {
    return MetabolicLevel.na;
  }
});

///TODO:[Old correlationHCO3Provider calculations]
// final correlationHCO3Provider = Provider<MetabolicLevel>((ref) {
//   if (ref.watch(hco3NotifierProvider).findingNumber == 0) {
//     return MetabolicLevel.na;
//   } else if (ref.watch(correctedHCO3Provider) == 8 &&
//       ref.watch(hco3NotifierProvider).findingNumber == 24) {
//     return MetabolicLevel.normal;
//   } else if ((ref.watch(correctedHCO3Provider) ?? 0) < 24 &&
//       (ref.watch(hco3NotifierProvider).findingNumber ?? 0) < 24 &&
//       (ref.watch(correctedHCO3Provider) ==
//           ref.watch(hco3NotifierProvider).findingNumber)) {
//     return MetabolicLevel.simpleMetabolicAcidosis;
//   } else if ((ref.watch(correctedHCO3Provider) ?? 0) > 24 &&
//       (ref.watch(hco3NotifierProvider).findingNumber ?? 0) > 24 &&
//       (ref.watch(correctedHCO3Provider) ==
//           ref.watch(hco3NotifierProvider).findingNumber)) {
//     return MetabolicLevel.simpleMetabolicAlkalosis;
//   } else if ((ref.watch(correctedHCO3Provider) ?? 0) < 10) {
//     return MetabolicLevel.metabolicAlkalosis;
//   } else if ((ref.watch(correctedHCO3Provider) ?? 0) > 10) {
//     return MetabolicLevel.metabolicAcidosis;
//   } else {
//     return MetabolicLevel.na;
//   }
// });

final Provider<String> diagnosisSecondResultProvider =
    Provider<String>((ProviderRef<String> ref) {
  return (ref.watch(hco3NotifierProvider).findingNumber == 0) ||
          (ref.watch(phNotifierProvider).findingNumber == 0)
      ? CalculationConstants.noData
      : "${ref.watch(correctedAGPresentResultProvider).level.$1}, ${ref.watch(hco3NotifierProvider).findingLevel.level.$1}, (${ref.watch(correlationHCO3Provider).level.$1}), ${ref.watch(sigResultProvider).level.$1}";
});

//--------------------Second Section-------------------------

//--------------------Third Section-------------------------

final Provider<double> aG2CalculationProvider =
    Provider<double>((ProviderRef<double> ref) {
  return (ref.watch(sodiumNotifierProvider).findingNumber ?? 0) -
      (ref.watch(chlorineNotifierProvider).findingNumber ?? 0) -
      (ref.watch(hco3NotifierProvider).findingNumber ?? 0);
});

final Provider<double> expectedPCo2CalculationProvider =
    Provider<double>((ProviderRef<double> ref) {
  return (ref.watch(phNotifierProvider).findingNumber == 0 ||
          ref.watch(pCO2NotifierProvider).findingNumber == 0)
      ? 0
      : ((ref.watch(hco3NotifierProvider).findingNumber ?? 0) * 1.5) + 8;
});

final Provider<RespiratoryLevel> expectedPCo2ResultProvider =
    Provider<RespiratoryLevel>((ProviderRef<RespiratoryLevel> ref) {
  ///[New requirements upon changes in 22/10/2023]
  if (ref.watch(expectedPCo2CalculationProvider) == 0) {
    return RespiratoryLevel.na;
  }

  ///
  else if ((ref.watch(expectedPCo2CalculationProvider)) <
      (ref.watch(pCO2NotifierProvider).findingNumber ?? 0)) {
    return RespiratoryLevel.hypoVentilatoryRespiratoryAcidosis;
  }

  ///

  else if ((ref.watch(expectedPCo2CalculationProvider)) >
      (ref.watch(pCO2NotifierProvider).findingNumber ?? 0)) {
    return RespiratoryLevel.hyperVentilatoryRespiratoryAlkalosis;
  }

  ///
  else if ((ref.watch(expectedPCo2CalculationProvider)) > 40 &&
      (ref.watch(pCO2NotifierProvider).findingNumber ?? 0) > 40 &&
      (ref.watch(expectedPCo2CalculationProvider)) ==
          (ref.watch(pCO2NotifierProvider).findingNumber)) {
    return RespiratoryLevel.compensatoryRespiratoryAcidosis;
  }

  ///
  else if ((ref.watch(expectedPCo2CalculationProvider)) < 40 &&
      (ref.watch(pCO2NotifierProvider).findingNumber ?? 0) < 40 &&
      (ref.watch(expectedPCo2CalculationProvider)) ==
          (ref.watch(pCO2NotifierProvider).findingNumber)) {
    return RespiratoryLevel.compensatoryRespiratoryAlkalosis;
  }

  ///
  else {
    return RespiratoryLevel.normocarbia;
  }
});

final Provider<String> diagnosisThirdResultProvider =
    Provider<String>((ProviderRef<String> ref) {
  return (ref.watch(pCO2NotifierProvider).findingNumber == 0) ||
          (ref.watch(phNotifierProvider).findingNumber == 0) ||
          (ref.watch(hco3NotifierProvider).findingNumber == 0)
      ? CalculationConstants.noData
      : ref.watch(expectedPCo2ResultProvider).level.$1;
});

//--------------------Third Section-------------------------

//--------------------Fourth Section-------------------------
final Provider<double> pAOutputO2Provider =
    Provider<double>((ProviderRef<double> ref) {
  return ((ref.watch(fiO2Provider) ?? 0) * 7) -
      ((ref.watch(pCO2NotifierProvider).findingNumber ?? 0) / 0.8);
});

final Provider<double> aAProvider = Provider<double>((ProviderRef<double> ref) {
  return ((ref.watch(pAOutputO2Provider)) - (ref.watch(paInputO2Provider) ?? 0))
      .toDouble();
});

final Provider<double> expectedAaProvider =
    Provider<double>((ProviderRef<double> ref) {
  return (ref.watch(hco3NotifierProvider).findingNumber == 0) ||
          (ref.watch(phNotifierProvider).findingNumber == 0)
      ? 0
      : (((ref.watch(fiO2Provider) ?? 0) / 100) *
                  (ref.watch(agesProvider) ?? 0) +
              2.5)
          .roundToDouble();
});

final Provider<OxygenWaterLevel> diagnosisFourthResultProvider =
    Provider<OxygenWaterLevel>((ProviderRef<OxygenWaterLevel> ref) {
  LogManager.logToConsole((ref.watch(expectedAaProvider) + 5));
  LogManager.logToConsole(ref.watch(aAProvider));
  return (ref.watch(fiO2Provider) == 0) ||
          (ref.watch(agesProvider) == 0) ||
          (ref.watch(paInputO2Provider) == 0)
      ? OxygenWaterLevel.na
      : (ref.watch(expectedAaProvider) + 5) < ref.watch(aAProvider)
          ? OxygenWaterLevel.hypoxemia
          : OxygenWaterLevel.normoxia;
});

//--------------------Fourth Section-------------------------

// =IF(OR(B9=CalculationConstants.noData,B16=CalculationConstants.noData,B21=CalculationConstants.noData,B28=CalculationConstants.noData),"INCOMPLETE MEASURED ITEMS, PLEASE FILL THE INPUT FIELDS IN GRREEN",CONCATENATE("This patient had ",B9," then developed ",B16," with ",B21," and ",B28))

//--------------------Final Section-------------------------

//,CONCATENATE("This patient had ",B9," then developed ",B16," with ",B21," and ",B28))
final Provider<String> finalDiagnosisResultProvider =
    Provider<String>((ProviderRef<String> ref) {
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

final Provider<List<Map<String, dynamic>>> fourResultDiagnosisProvider =
    Provider<List<Map<String, dynamic>>>(
        (ProviderRef<List<Map<String, dynamic>>> ref) {
  return <Map<String, dynamic>>[
    <String, Object>{
      "label": "Start metabolic State",
      "title": ref.watch(diagnosisOneResultProvider),
      "desc": const TableOneDiagnosis()
    },
    <String, Object>{
      "label": "Present metabolic change",
      "title": ref.watch(diagnosisSecondResultProvider),
      "desc": const TableTwoDiagnosis()
    },
    <String, Object>{
      "label": "Ventilatroy state",
      "title": ref.watch(diagnosisThirdResultProvider),
      "desc": const TableThreeDiagnosis()
    },
    <String, Object>{
      "label": "Oxygenation state",
      "title": ref.watch(diagnosisFourthResultProvider).level.$1,
      "desc":
          // "PAO2 mmHg: ${ref.watch(pAOutputO2Provider)}\nA-a: ${ref.watch(aAProvider)}\nExpected A-a: ${ref.watch(expectedAaProvider)} "
          const TableFourDiagnosis()
    },
  ];
});

//--------------------Final Section-------------------------

final Provider<CLNaLevel> correctedCLProviderResult =
    Provider<CLNaLevel>((ProviderRef<CLNaLevel> ref) {
  double clValue = ref.watch(correctedCLProvider) ?? 0;
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
