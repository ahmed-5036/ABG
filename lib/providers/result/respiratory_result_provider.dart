// lib/providers/result/respiratory_result_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/abg_result.dart';
import '../../services/enum.dart';
import '../calculator/calculator_result_provider.dart';
import '../input/input_state_provider.dart';
import '../../resources/constants/calculation_constants.dart';

final Provider<RespiratoryLevel> respiratoryResultProvider =
    Provider<RespiratoryLevel>((ProviderRef<RespiratoryLevel> ref) {
  final ABGResult result = ref.watch(calculatorResultProvider);
  return result.respiratoryResult.findingLevel;
});

final Provider<Map<String, dynamic>> respiratoryDetailsProvider =
    Provider<Map<String, dynamic>>((ProviderRef<Map<String, dynamic>> ref) {
  final ABGResult result = ref.watch(calculatorResultProvider);
  return result.respiratoryResult.additionalData ?? <String, dynamic>{};
});

// Ventilatory State Providers

// Expected PCO2 Calculation Provider
final Provider<double> expectedPCo2CalculationProvider = Provider<double>((ProviderRef<double> ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double ph = values['ph'] ?? 0;
  final double pco2 = values['pco2'] ?? 0;
  final double hco3 = values['hco3'] ?? 0;
  
  return (ph == 0 || pco2 == 0)
      ? 0
      : (hco3 * 1.5) + 8;
});

// Expected PCO2 Result Provider
final Provider<RespiratoryLevel> expectedPCo2ResultProvider = Provider<RespiratoryLevel>((ProviderRef<RespiratoryLevel> ref) {
  final double expectedPCO2 = ref.watch(expectedPCo2CalculationProvider);
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double pco2 = values['pco2'] ?? 0;
  
  if (expectedPCO2 == 0) {
    return RespiratoryLevel.unknown;
  } else if (expectedPCO2 < pco2) {
    return RespiratoryLevel.hypoVentilatoryRespiratoryAcidosis;
  } else if (expectedPCO2 > pco2) {
    return RespiratoryLevel.hyperVentilatoryRespiratoryAlkalosis;
  } else if (expectedPCO2 > 40 && pco2 > 40 && expectedPCO2 == pco2) {
    return RespiratoryLevel.compensatoryRespiratoryAcidosis;
  } else if (expectedPCO2 < 40 && pco2 < 40 && expectedPCO2 == pco2) {
    return RespiratoryLevel.compensatoryRespiratoryAlkalosis;
  } else {
    return RespiratoryLevel.normocarbia;
  }
});

// Diagnosis Third Result Provider
final Provider<String> diagnosisThirdResultProvider = Provider<String>((ProviderRef<String> ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double pco2 = values['pco2'] ?? 0;
  final double ph = values['ph'] ?? 0;
  final double hco3 = values['hco3'] ?? 0;
  
  return (pco2 == 0 || ph == 0 || hco3 == 0)
      ? CalculationConstants.noData
      : ref.watch(expectedPCo2ResultProvider).level.$1;
});
