// lib/providers/input/navigation_validation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'input_state_provider.dart';

final Provider<bool> navigateToResultProvider = Provider<bool>((ProviderRef<bool> ref) {
  final InputState input = ref.watch(inputStateProvider);
  final bool validation = ref.watch(inputCompleteProvider);

  final bool isComplete = input.isComplete;
  final bool allValid = validation;

  return isComplete && allValid;
});
