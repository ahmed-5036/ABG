// lib/providers/result/respiratory_result_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/abg_result.dart';
import '../../services/enum.dart';
import '../calculator/calculator_result_provider.dart';

final respiratoryResultProvider = Provider<RespiratoryLevel>((ref) {
  final result = ref.watch(calculatorResultProvider);
  return result.respiratoryResult.findingLevel;
});

final respiratoryDetailsProvider = Provider<Map<String, dynamic>>((ref) {
  final result = ref.watch(calculatorResultProvider);
  return result.respiratoryResult.additionalData ?? {};
});
