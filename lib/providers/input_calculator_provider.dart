import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/final_result.dart';
import '../resources/constants/calculation_constants.dart';
import '../services/enum.dart';
import 'result_calculator_providers.dart';

final StateProvider<bool> navigateToResultProviderProvider =
    StateProvider<bool>((StateProviderRef<bool> ref) {
  return (ref.watch(potassiumNotifierProvider).findingLevel.level.$2 != null) &&
      (ref.watch(sodiumNotifierProvider).findingLevel.level.$2 != null) &&
      // (ref.watch(albuminNotifierProvider).findingLevel.level.$2 != null) &&
      (ref.watch(chlorineNotifierProvider).findingLevel.level.$2 != null) &&
      (ref.watch(hco3NotifierProvider).findingLevel.level.$2 != null) &&
      (ref.watch(phNotifierProvider).findingLevel.level.$2 != null) &&
      (ref.watch(pCO2NotifierProvider).findingLevel.level.$2 != null);
});

//-----------------------First Providers --------------------//

final StateNotifierProvider<PotassiumNotifier, FinalResult<PotassiumLevel>>
    potassiumNotifierProvider =
    StateNotifierProvider<PotassiumNotifier, FinalResult<PotassiumLevel>>(
        (StateNotifierProviderRef<PotassiumNotifier,
                FinalResult<PotassiumLevel>>
            ref) {
  return PotassiumNotifier();
});

class PotassiumNotifier extends StateNotifier<FinalResult<PotassiumLevel>> {
  PotassiumNotifier()
      : super(const FinalResult<PotassiumLevel>(
            findingLevel: PotassiumLevel.na, findingNumber: 0));

  void getPotassiumDiagnosis(double? number) {
    switch (number) {
      case null:
      case 0:
        state = FinalResult<PotassiumLevel>(
            findingLevel: PotassiumLevel.na, findingNumber: number);
        break;
      case == CalculationConstants.normokalemiaThreshold:
        state = FinalResult<PotassiumLevel>(
            findingLevel: PotassiumLevel.normokalemia, findingNumber: number);
        break;

      case > CalculationConstants.hyperkalemiaThreshold:
        state = FinalResult<PotassiumLevel>(
            findingLevel: PotassiumLevel.hyperkalemia, findingNumber: number);
        break;
      case < CalculationConstants.normokalemiaThreshold:
        state = FinalResult<PotassiumLevel>(
            findingLevel: PotassiumLevel.hypokalemia, findingNumber: number);
        break;
      default:
        state = FinalResult<PotassiumLevel>(
            findingLevel: PotassiumLevel.normokalemia, findingNumber: number);
        break;
    }
  }
}

final StateNotifierProvider<SodiumNotifier, FinalResult<SodiumLevel>>
    sodiumNotifierProvider =
    StateNotifierProvider<SodiumNotifier, FinalResult<SodiumLevel>>(
        (StateNotifierProviderRef<SodiumNotifier, FinalResult<SodiumLevel>>
            ref) {
  return SodiumNotifier();
});

class SodiumNotifier extends StateNotifier<FinalResult<SodiumLevel>> {
  SodiumNotifier()
      : super((const FinalResult<SodiumLevel>(
            findingLevel: SodiumLevel.na, findingNumber: 1)));

  void getSodiumDiagnosis(double? number) {
    switch (number) {
      case null:
      case 0:
        state = FinalResult<SodiumLevel>(
            findingLevel: SodiumLevel.na, findingNumber: number);
        break;
      case (== CalculationConstants.normonatremicThreshold):
        state = FinalResult<SodiumLevel>(
            findingLevel: SodiumLevel.normonatremic, findingNumber: number);

        break;

      case > CalculationConstants.hypernatremicThreshold:
        state = FinalResult<SodiumLevel>(
            findingLevel: SodiumLevel.hypernatremic, findingNumber: number);
        break;
      case < CalculationConstants.normonatremicThreshold:
        state = FinalResult<SodiumLevel>(
            findingLevel: SodiumLevel.hyponatremic, findingNumber: number);
        break;
      default:
        state = FinalResult<SodiumLevel>(
            findingLevel: SodiumLevel.normonatremic, findingNumber: number);
        break;
    }
  }
}

final StateNotifierProvider<AlbuminNotifier, FinalResult<AlbuminLevel>>
    albuminNotifierProvider =
    StateNotifierProvider<AlbuminNotifier, FinalResult<AlbuminLevel>>(
        (StateNotifierProviderRef<AlbuminNotifier, FinalResult<AlbuminLevel>>
            ref) {
  return AlbuminNotifier();
});

class AlbuminNotifier extends StateNotifier<FinalResult<AlbuminLevel>> {
  AlbuminNotifier()
      : super(const FinalResult<AlbuminLevel>(
            findingLevel: AlbuminLevel.na, findingNumber: 1));

  void getAlbuminDiagnosis(double? number) {
    switch (number) {
      case null:
      case 0:
        state = FinalResult<AlbuminLevel>(
            findingLevel: AlbuminLevel.na, findingNumber: number);
        break;
      case == CalculationConstants.normalAlbuminThreshold:
        state = FinalResult<AlbuminLevel>(
            findingLevel: AlbuminLevel.normonalbumin, findingNumber: number);
        break;

      case > CalculationConstants.hyperalbuminemiaThreshold:
        state = FinalResult<AlbuminLevel>(
            findingLevel: AlbuminLevel.hyperalbuminemia, findingNumber: number);
        break;
      case < CalculationConstants.normalAlbuminThreshold:
        state = FinalResult<AlbuminLevel>(
            findingLevel: AlbuminLevel.hypoalbuminemia, findingNumber: number);
        break;
      default:
        state = FinalResult<AlbuminLevel>(
            findingLevel: AlbuminLevel.normonalbumin, findingNumber: number);
        break;
    }
  }
}

final StateNotifierProvider<ChlorineNotifier, FinalResult<ChlorineLevel>>
    chlorineNotifierProvider =
    StateNotifierProvider<ChlorineNotifier, FinalResult<ChlorineLevel>>(
        (StateNotifierProviderRef<ChlorineNotifier, FinalResult<ChlorineLevel>>
            ref) {
  return ChlorineNotifier();
});

class ChlorineNotifier extends StateNotifier<FinalResult<ChlorineLevel>> {
  ChlorineNotifier()
      : super(const FinalResult<ChlorineLevel>(
            findingLevel: ChlorineLevel.na, findingNumber: 0));

  void getChlorineDiagnosis(double? number) {
    switch (number) {
      case null:
      case 0:
        state = FinalResult<ChlorineLevel>(
            findingLevel: ChlorineLevel.na, findingNumber: number);
        break;
      case == CalculationConstants.normochloremicThreshold:
        state = FinalResult<ChlorineLevel>(
            findingLevel: ChlorineLevel.normochloremic, findingNumber: number);
        break;

      case > CalculationConstants.hyperchloremicThreshold:
        state = FinalResult<ChlorineLevel>(
            findingLevel: ChlorineLevel.hyperchloremic, findingNumber: number);
        break;
      case < CalculationConstants.normochloremicThreshold:
        state = FinalResult<ChlorineLevel>(
            findingLevel: ChlorineLevel.hypochloremic, findingNumber: number);
        break;
      default:
        state = FinalResult<ChlorineLevel>(
            findingLevel: ChlorineLevel.normochloremic, findingNumber: number);
        break;
    }
  }
}

//-----------------------First Providers --------------------//

//-----------------------Second Providers --------------------//

final StateNotifierProvider<HCo3Notifier, FinalResult<MetabolicLevel>>
    hco3NotifierProvider =
    StateNotifierProvider<HCo3Notifier, FinalResult<MetabolicLevel>>(
        (StateNotifierProviderRef<HCo3Notifier, FinalResult<MetabolicLevel>>
            ref) {
  return HCo3Notifier();
});

class HCo3Notifier extends StateNotifier<FinalResult<MetabolicLevel>> {
  HCo3Notifier()
      : super(const FinalResult<MetabolicLevel>(
            findingLevel: MetabolicLevel.na, findingNumber: 0));

  void getHCo3Diagnosis(double? number) {
    switch (number) {
      case null:
      case 0:
        state = FinalResult<MetabolicLevel>(
            findingLevel: MetabolicLevel.na, findingNumber: number);
        break;
      case == CalculationConstants.normalHCO3Threshold:
        state = FinalResult<MetabolicLevel>(
            findingLevel: MetabolicLevel.normal, findingNumber: number);
        break;

      case > CalculationConstants.normalHCO3Threshold:
        state = FinalResult<MetabolicLevel>(
            findingLevel: MetabolicLevel.metabolicAlkalosis,
            findingNumber: number);
        break;
      case < CalculationConstants.normalHCO3Threshold:
        state = FinalResult<MetabolicLevel>(
            findingLevel: MetabolicLevel.metabolicAcidosis,
            findingNumber: number);
        break;
      default:
        state = FinalResult<MetabolicLevel>(
            findingLevel: MetabolicLevel.normal, findingNumber: number);
        break;
    }
  }
}

final StateNotifierProvider<PhNotifier, FinalResult<PhLevel>>
    phNotifierProvider =
    StateNotifierProvider<PhNotifier, FinalResult<PhLevel>>(
        (StateNotifierProviderRef<PhNotifier, FinalResult<PhLevel>> ref) {
  return PhNotifier();
});

class PhNotifier extends StateNotifier<FinalResult<PhLevel>> {
  PhNotifier()
      : super(const FinalResult<PhLevel>(
            findingLevel: PhLevel.na, findingNumber: 1));

  void getPhDiagnosis(double? number) {
    switch (number) {
      case null:
      case 0:
        state = FinalResult<PhLevel>(
            findingLevel: PhLevel.na, findingNumber: number);
        break;
      case == CalculationConstants.normalPhThreshold:
        state = FinalResult<PhLevel>(
            findingLevel: PhLevel.normal, findingNumber: number);
        break;

      case > CalculationConstants.normalPhThreshold:
        state = FinalResult<PhLevel>(
            findingLevel: PhLevel.alkalosis, findingNumber: number);
        break;
      case < CalculationConstants.normalPhThreshold:
        state = FinalResult<PhLevel>(
            findingLevel: PhLevel.acidosis, findingNumber: number);
        break;
      default:
        state = FinalResult<PhLevel>(
            findingLevel: PhLevel.normal, findingNumber: number);
        break;
    }
  }
}

//-----------------------Second Providers ------- -------------//

//-----------------------Third Providers --------------------//
final StateNotifierProvider<PCO2Notifier, FinalResult<PCO2Level>>
    pCO2NotifierProvider =
    StateNotifierProvider<PCO2Notifier, FinalResult<PCO2Level>>(
        (StateNotifierProviderRef<PCO2Notifier, FinalResult<PCO2Level>> ref) {
  return PCO2Notifier();
});

class PCO2Notifier extends StateNotifier<FinalResult<PCO2Level>> {
  PCO2Notifier()
      : super(const FinalResult<PCO2Level>(
            findingLevel: PCO2Level.na, findingNumber: 1));

  void getPco2Diagnosis(double? number) {
    switch (number) {
      case null:
      case 0:
        state = FinalResult<PCO2Level>(
            findingLevel: PCO2Level.na, findingNumber: number);
        break;
      case == CalculationConstants.pCo2Threshold:
        state = FinalResult<PCO2Level>(
            findingLevel: PCO2Level.normocarpic, findingNumber: number);
        break;

      case > CalculationConstants.pCo2Threshold:
        state = FinalResult<PCO2Level>(
            findingLevel: PCO2Level.respiratoryAcidosis, findingNumber: number);
        break;
      case < CalculationConstants.pCo2Threshold:
        state = FinalResult<PCO2Level>(
            findingLevel: PCO2Level.respiratoryAlkalosis,
            findingNumber: number);
        break;
      default:
        state = FinalResult<PCO2Level>(
            findingLevel: PCO2Level.normocarpic, findingNumber: number);
        break;
    }
  }
}

//-----------------------Third Providers --------------------//

//-----------------------Fourth Providers --------------------//
final StateProvider<double?> fiO2Provider =
    StateProvider<double?>((StateProviderRef<double?> ref) {
  return 0;
});

final StateProvider<double?> agesProvider =
    StateProvider<double?>((StateProviderRef<double?> ref) {
  return 0;
});

final StateProvider<double?> paInputO2Provider =
    StateProvider<double?>((StateProviderRef<double?> ref) {
  return 0;
});

//-----------------------Type 2 Patients --------------------//

final StateProvider<double?> correctedCLProvider =
    StateProvider<double?>((StateProviderRef<double?> ref) {
  double hco3Val = ref.watch(hco3NotifierProvider).findingNumber ?? 0;
  double correctedHco3Val = ref.watch(correctedHCO3Provider) ?? 0;
  double clVal = ref.watch(chlorineNotifierProvider).findingNumber ?? 0;

  // LogManager.logToConsole(hco3Val, "hco3 317");
  // LogManager.logToConsole(correctedHco3Val, "correctedHco3Val 317");
  // LogManager.logToConsole(clVal, "clVal 317");

  return (hco3Val - correctedHco3Val) + clVal;
});
