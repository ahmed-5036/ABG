// lib/providers/result/oxygenation_result_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/abg_result.dart';
import '../../services/enum.dart';
import '../calculator/calculator_result_provider.dart';

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
