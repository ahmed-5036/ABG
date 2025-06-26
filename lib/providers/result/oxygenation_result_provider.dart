// lib/providers/result/oxygenation_result_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/abg_result.dart';
import '../../services/enum.dart';
import '../calculator/calculator_result_provider.dart';
import '../input/input_state_provider.dart';

final Provider<OxygenWaterLevel> oxygenationResultProvider =
    Provider<OxygenWaterLevel>((ProviderRef<OxygenWaterLevel> ref) {
  final ABGResult result = ref.watch(calculatorResultProvider);
  return result.oxygenResult.findingLevel;
});

final Provider<Map<String, dynamic>> oxygenationDetailsProvider =
    Provider<Map<String, dynamic>>((ProviderRef<Map<String, dynamic>> ref) {
  final ABGResult result = ref.watch(calculatorResultProvider);
  return result.oxygenResult.additionalData ?? <String, dynamic>{};
});

// Oxygenation State Providers

final Provider<double> pAOutputO2Provider =
    Provider<double>((ProviderRef<double> ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double fio2 = values['fio2'] ?? 0;
  final double pco2 = values['pco2'] ?? 0;
  return (fio2 * 7) - (pco2 / 0.8);
});

final Provider<double> paInputO2Provider =
    Provider<double>((ProviderRef<double> ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  return values['pao2'] ?? 0;
});

final Provider<double> aAProvider = Provider<double>((ProviderRef<double> ref) {
  return ref.watch(pAOutputO2Provider) - ref.watch(paInputO2Provider);
});

final Provider<double> expectedAaProvider =
    Provider<double>((ProviderRef<double> ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double hco3 = values['hco3'] ?? 0;
  final double ph = values['ph'] ?? 0;
  final double fio2 = values['fio2'] ?? 0;
  final double age = values['age'] ?? 0;
  if (hco3 == 0 || ph == 0) return 0;
  double calculatedValue = (((fio2 / 100) * age) + 2.5);
  double roundedValue = (calculatedValue * 10).round() / 10.0;
  return roundedValue;
});

final Provider<OxygenWaterLevel> diagnosisFourthResultProvider =
    Provider<OxygenWaterLevel>((ProviderRef<OxygenWaterLevel> ref) {
  final Map<String, double> values = ref.watch(inputStateProvider).values;
  final double fio2 = values['fio2'] ?? 0;
  final double age = values['age'] ?? 0;
  final double pao2 = values['pao2'] ?? 0;
  if (fio2 == 0 || age == 0 || pao2 == 0) return OxygenWaterLevel.unknown;
  return (ref.watch(expectedAaProvider) + 5) < ref.watch(aAProvider)
      ? OxygenWaterLevel.hypoxemia
      : OxygenWaterLevel.normoxia;
});
