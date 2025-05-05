// lib/providers/result/metabolic_result_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/abg_result.dart';
import '../../services/enum.dart';
import '../calculator/calculator_result_provider.dart';

final metabolicResultProvider = Provider<MetabolicLevel>((ref) {
  final result = ref.watch(calculatorResultProvider);
  return result.metabolicResult.findingLevel;
});

final metabolicDetailsProvider = Provider<Map<String, dynamic>>((ref) {
  final result = ref.watch(calculatorResultProvider);
  return result.metabolicResult.additionalData ?? {};
});
