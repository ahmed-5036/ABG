// lib/providers/calculator/calculator_result_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/abg_result.dart';
import '../../services/enum.dart';
import '../input/input_state_provider.dart';
import '../../services/calculations/base_calculator.dart';
import '../../services/calculators/calculator_factory.dart'
    as calculator_factory;
import 'calculator_state_provider.dart';

/// Provider that determines if COPD inputs are complete
final Provider<bool> copdInputsCompleteProvider =
    Provider<bool>((ProviderRef<bool> ref) {
  final InputState inputs = ref.watch(inputStateProvider);
  final Map<String, double> values = inputs.values;
  final Map<String, bool> isValid = inputs.isValid;

  // Check for all required COPD fields
  return values.containsKey('sodium') &&
      values.containsKey('chlorine') &&
      values.containsKey('hco3') &&
      values.containsKey('albumin') &&
      values.containsKey('pco2') &&
      values['sodium'] != null &&
      values['chlorine'] != null &&
      values['hco3'] != null &&
      values['albumin'] != null &&
      values['pco2'] != null &&
      isValid['sodium'] == true &&
      isValid['chlorine'] == true &&
      isValid['hco3'] == true &&
      isValid['albumin'] == true &&
      isValid['pco2'] == true;
});

/// Provider for COPD calculation results
final Provider<Map<String, dynamic>> copdCalculationResultProvider =
    Provider<Map<String, dynamic>>((ProviderRef<Map<String, dynamic>> ref) {
  final calculator_factory.CalculatorType calculatorType =
      ref.watch(calculator_factory.calculatorTypeProvider);
  final Map<String, double> inputs = ref.watch(inputStateProvider).values;
  final bool isCopdCalculator = calculatorType ==
          calculator_factory.CalculatorType.copdCalculationNormal ||
      calculatorType == calculator_factory.CalculatorType.copdCalculationHigh;

  // Skip if not a COPD calculator or inputs aren't complete
  if (!isCopdCalculator || !ref.watch(copdInputsCompleteProvider)) {
    return <String, dynamic>{};
  }

  // Extract values needed for calculation
  final double sodium = inputs['sodium'] ?? 0.0;
  final double chlorine = inputs['chlorine'] ?? 0.0;
  final double hco3 = inputs['hco3'] ?? 0.0;
  final double albumin = inputs['albumin'] ?? 0.0;
  final double pco2 = inputs['pco2'] ?? 0.0;

  // Determine which COPD calculator to use
  final bool isNormalCopd =
      calculatorType == calculator_factory.CalculatorType.copdCalculationNormal;

  if (isNormalCopd) {
    // Normal AG COPD calculations
    final double correctedAG =
        (sodium - chlorine - hco3) + ((4 - albumin) * 2.5);
    final double expectedHCO3 = hco3 + (correctedAG - 12);
    final double expectedPCO2 = 40 + ((expectedHCO3 - hco3) / 0.35);
    final double expectedPH = 7.4 -
        (((expectedPCO2 - 40) * 0.08) / 10) +
        (((expectedHCO3 - 24) * 0.15) / 10);

    return <String, dynamic>{
      'correctedAG': correctedAG,
      'expectedHCO3': expectedHCO3,
      'expectedPCO2': expectedPCO2,
      'expectedPH': expectedPH,
    };
  } else {
    // High AG COPD calculations
    final double measuredSID = sodium - chlorine;
    final double expectedHCO3 = hco3 + (36 - measuredSID);
    final double expectedPCO2 = 40 + ((expectedHCO3 - hco3) / 0.35);
    final double expectedPH = 7.4 -
        ((expectedPCO2 - 40) * 0.08 / 10) +
        ((expectedHCO3 - 24) * 0.15 / 10);

    return <String, dynamic>{
      'measuredSID': measuredSID,
      'expectedHCO3': expectedHCO3,
      'expectedPCO2': expectedPCO2,
      'expectedPH': expectedPH,
    };
  }
});

final Provider<ABGResult> calculatorResultProvider =
    Provider<ABGResult>((ProviderRef<ABGResult> ref) {
  final ABGCalculator calculator = ref.watch(calculatorProvider);
  final InputState inputs = ref.watch(inputStateProvider);

  if (!inputs.isComplete) return ABGResult.initial();

  final FinalResult<MetabolicLevel> metabolicResult =
      calculator.calculateMetabolicState(
    sodium: inputs.values['sodium'] ?? 0,
    chlorine: inputs.values['chlorine'] ?? 0,
    hco3: inputs.values['hco3'] ?? 0,
    albumin: inputs.values['albumin'] ?? 0,
  );

  final FinalResult<RespiratoryLevel> respiratoryResult =
      calculator.calculateRespiratoryState(
    pco2: inputs.values['pco2'] ?? 0,
    hco3: inputs.values['hco3'] ?? 0,
    ph: inputs.values['ph'] ?? 0,
  );

  final FinalResult<OxygenWaterLevel> oxygenationResult =
      calculator.calculateOxygenationState(
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
    clNaResult: const FinalResult(
      findingLevel: CLNaLevel.na,
      findingNumber: null,
    ),
    agResult: const FinalResult(
      findingLevel: AGLevel.na,
      findingNumber: null,
    ),
    sigResult: const FinalResult(
      findingLevel: SIGLevel.na,
      findingNumber: null,
    ),
    respiratoryResult: respiratoryResult,
    oxygenResult: oxygenationResult,
  );
});

// Add helper providers for individual calculations
final Provider<FinalResult<MetabolicLevel>> metabolicCalculationProvider =
    Provider<FinalResult<MetabolicLevel>>(
        (ProviderRef<FinalResult<MetabolicLevel>> ref) {
  final ABGCalculator calculator = ref.watch(calculatorProvider);
  final InputState inputs = ref.watch(inputStateProvider);

  if (!inputs.isComplete) {
    return const FinalResult(
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

final Provider<FinalResult<RespiratoryLevel>> respiratoryCalculationProvider =
    Provider<FinalResult<RespiratoryLevel>>(
        (ProviderRef<FinalResult<RespiratoryLevel>> ref) {
  final ABGCalculator calculator = ref.watch(calculatorProvider);
  final InputState inputs = ref.watch(inputStateProvider);

  if (!inputs.isComplete) {
    return const FinalResult(
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

final Provider<FinalResult<OxygenWaterLevel>> oxygenationCalculationProvider =
    Provider<FinalResult<OxygenWaterLevel>>(
        (ProviderRef<FinalResult<OxygenWaterLevel>> ref) {
  final ABGCalculator calculator = ref.watch(calculatorProvider);
  final InputState inputs = ref.watch(inputStateProvider);

  if (!inputs.isComplete) {
    return const FinalResult(
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

final Provider<double> expectedPCO2Provider =
    Provider<double>((ProviderRef<double> ref) {
  final double? hco3 = ref.watch(inputStateProvider).values['hco3'];
  if (hco3 == null) return 0;

  // Winter's Formula (for metabolic acidosis)
  return (1.5 * hco3) + 8;
});

// Provider for final diagnosis
final Provider<String> finalCalculationProvider =
    Provider<String>((ProviderRef<String> ref) {
  final FinalResult<MetabolicLevel> metabolic =
      ref.watch(metabolicCalculationProvider);
  final FinalResult<RespiratoryLevel> respiratory =
      ref.watch(respiratoryCalculationProvider);
  final FinalResult<OxygenWaterLevel> oxygenation =
      ref.watch(oxygenationCalculationProvider);

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
