// lib/providers/result/respiratory_result_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/abg_result.dart';
import '../../services/enum.dart';
import '../calculator/calculator_result_provider.dart';

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
