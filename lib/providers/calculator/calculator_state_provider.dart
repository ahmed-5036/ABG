// lib/providers/calculator/calculator_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/calculations/base_calculator.dart';
import '../../services/calculators/calculator_factory.dart';

import '../../services/enum.dart';
import '../patient_type_provider.dart';

final Provider<ABGCalculator> calculatorProvider = Provider<ABGCalculator>((ProviderRef<ABGCalculator> ref) {
  final CalculatorType type = ref.watch(calculatorTypeProvider);
  final PatientType? patientType = ref.watch(patientTypeProvider);
  return ABGCalculatorFactory.getCalculator(type, patientType);
});
