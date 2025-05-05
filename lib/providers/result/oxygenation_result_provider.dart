// lib/providers/result/oxygenation_result_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/abg_result.dart';
import '../../services/enum.dart';
import '../calculator/calculator_result_provider.dart';

final oxygenationResultProvider = Provider<OxygenWaterLevel>((ref) {
  final result = ref.watch(calculatorResultProvider);
  return result.oxygenResult.findingLevel;
});

final oxygenationDetailsProvider = Provider<Map<String, dynamic>>((ref) {
  final result = ref.watch(calculatorResultProvider);
  return result.oxygenResult.additionalData ?? {};
});
