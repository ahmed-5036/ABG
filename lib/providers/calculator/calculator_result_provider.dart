// lib/providers/calculator/calculator_result_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aai_app/models/abg_result.dart';
import 'package:aai_app/services/enum.dart';
import 'package:aai_app/providers/input/input_state_provider.dart';
import 'calculator_state_provider.dart';

final calculatorResultProvider = Provider<ABGResult>((ref) {
  final calculator = ref.watch(calculatorProvider);
  final inputs = ref.watch(inputStateProvider);

  if (!inputs.isComplete) return ABGResult.initial();

  final metabolicResult = calculator.calculateMetabolicState(
    sodium: inputs.values['sodium'] ?? 0,
    chlorine: inputs.values['chlorine'] ?? 0,
    hco3: inputs.values['hco3'] ?? 0,
    albumin: inputs.values['albumin'] ?? 0,
  );

  final respiratoryResult = calculator.calculateRespiratoryState(
    pco2: inputs.values['pco2'] ?? 0,
    hco3: inputs.values['hco3'] ?? 0,
    ph: inputs.values['ph'] ?? 0,
  );

  final oxygenationResult = calculator.calculateOxygenationState(
    fio2: inputs.values['fio2'] ?? 0,
    pco2: inputs.values['pco2'] ?? 0,
    pao2: inputs.values['pao2'] ?? 0,
    age: inputs.values['age'] ?? 0,
  );

  return ABGResult(
    potassiumResult: FinalResult(
      findingLevel: PotassiumLevel.na,
      findingNumber: inputs.values['potassium'],
    ),
    sodiumResult: FinalResult(
      findingLevel: SodiumLevel.na,
      findingNumber: inputs.values['sodium'],
    ),
    albuminResult: FinalResult(
      findingLevel: AlbuminLevel.na,
      findingNumber: inputs.values['albumin'],
    ),
    chlorineResult: FinalResult(
      findingLevel: ChlorineLevel.na,
      findingNumber: inputs.values['chlorine'],
    ),
    metabolicResult: metabolicResult,
    phResult: FinalResult(
      findingLevel: PhLevel.na,
      findingNumber: inputs.values['ph'],
    ),
    pco2Result: FinalResult(
      findingLevel: PCO2Level.na,
      findingNumber: inputs.values['pco2'],
    ),
    clNaResult: FinalResult(
      findingLevel: CLNaLevel.na,
      findingNumber: null,
    ),
    agResult: FinalResult(
      findingLevel: AGLevel.na,
      findingNumber: null,
    ),
    sigResult: FinalResult(
      findingLevel: SIGLevel.na,
      findingNumber: null,
    ),
    respiratoryResult: respiratoryResult,
    oxygenResult: oxygenationResult,
  );
});

// Add helper providers for individual calculations
final metabolicCalculationProvider =
    Provider<FinalResult<MetabolicLevel>>((ref) {
  final calculator = ref.watch(calculatorProvider);
  final inputs = ref.watch(inputStateProvider);

  if (!inputs.isComplete) {
    return FinalResult(
      findingLevel: MetabolicLevel.unknown,
      findingNumber: null,
    );
  }

  return calculator.calculateMetabolicState(
    sodium: inputs.values['sodium'] ?? 0,
    chlorine: inputs.values['chlorine'] ?? 0,
    hco3: inputs.values['hco3'] ?? 0,
    albumin: inputs.values['albumin'] ?? 0,
  );
});

final respiratoryCalculationProvider =
    Provider<FinalResult<RespiratoryLevel>>((ref) {
  final calculator = ref.watch(calculatorProvider);
  final inputs = ref.watch(inputStateProvider);

  if (!inputs.isComplete) {
    return FinalResult(
      findingLevel: RespiratoryLevel.unknown,
      findingNumber: null,
    );
  }

  return calculator.calculateRespiratoryState(
    pco2: inputs.values['pco2'] ?? 0,
    hco3: inputs.values['hco3'] ?? 0,
    ph: inputs.values['ph'] ?? 0,
  );
});

final oxygenationCalculationProvider =
    Provider<FinalResult<OxygenWaterLevel>>((ref) {
  final calculator = ref.watch(calculatorProvider);
  final inputs = ref.watch(inputStateProvider);

  if (!inputs.isComplete) {
    return FinalResult(
      findingLevel: OxygenWaterLevel.unknown,
      findingNumber: null,
    );
  }

  return calculator.calculateOxygenationState(
    fio2: inputs.values['fio2'] ?? 0,
    pco2: inputs.values['pco2'] ?? 0,
    pao2: inputs.values['pao2'] ?? 0,
    age: inputs.values['age'] ?? 0,
  );
});
final expectedPCO2Provider = Provider<double>((ref) {
  final hco3 = ref.watch(inputStateProvider).values['hco3'];
  if (hco3 == null) return 0;

  // Winter's Formula (for metabolic acidosis)
  return (1.5 * hco3) + 8;
});
// Provider for final diagnosis
final finalCalculationProvider = Provider<String>((ref) {
  final metabolic = ref.watch(metabolicCalculationProvider);
  final respiratory = ref.watch(respiratoryCalculationProvider);
  final oxygenation = ref.watch(oxygenationCalculationProvider);

  if (metabolic.findingLevel == MetabolicLevel.unknown ||
      respiratory.findingLevel == RespiratoryLevel.unknown ||
      oxygenation.findingLevel == OxygenWaterLevel.unknown) {
    return "INCOMPLETE MEASURED ITEMS, PLEASE FILL THE INPUT FIELDS";
  }

  return ref.watch(calculatorProvider).getFinalDiagnosis(
        metabolicDiagnosis: metabolic.findingLevel.level.$1,
        respiratoryDiagnosis: respiratory.findingLevel.level.$1,
        oxygenationDiagnosis: oxygenation.findingLevel.level.$1,
      );
});
