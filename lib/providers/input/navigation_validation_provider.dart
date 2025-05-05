// lib/providers/input/navigation_validation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'input_state_provider.dart';
import 'input_validation_provider.dart';

final navigateToResultProvider = Provider<bool>((ref) {
  final input = ref.watch(inputStateProvider);
  final validation = ref.watch(inputCompleteProvider);

  final isComplete = input.isComplete;
  final allValid = validation;

  return isComplete && allValid;
});
