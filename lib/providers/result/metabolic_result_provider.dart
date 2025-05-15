// lib/providers/result/metabolic_result_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/abg_result.dart';
import '../../services/enum.dart';
import '../calculator/calculator_result_provider.dart';

final Provider<MetabolicLevel> metabolicResultProvider = Provider<MetabolicLevel>((ProviderRef<MetabolicLevel> ref) {
  final ABGResult result = ref.watch(calculatorResultProvider);
  return result.metabolicResult.findingLevel;
});

final Provider<Map<String, dynamic>> metabolicDetailsProvider = Provider<Map<String, dynamic>>((ProviderRef<Map<String, dynamic>> ref) {
  final ABGResult result = ref.watch(calculatorResultProvider);
  return result.metabolicResult.additionalData ?? <String, dynamic>{};
});
