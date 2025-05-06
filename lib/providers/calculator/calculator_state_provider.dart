// lib/providers/calculator/calculator_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aai_app/services/calculations/base_calculator.dart';
import 'package:aai_app/services/calculators/calculator_factory.dart';
import 'package:aai_app/views/pages/abg_admission.dart';

final calculatorProvider = Provider<ABGCalculator>((ref) {
  final type = ref.watch(calculatorTypeProvider);
  final patientType = ref.watch(patientTypeProvider);
  return ABGCalculatorFactory.getCalculator(type, patientType);
});
