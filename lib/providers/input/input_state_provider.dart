// lib/providers/input/input_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../resources/constants/calculation_constants.dart';
import '../../services/validator.dart';

class InputState {
  final Map<String, double> values;
  final Map<String, bool> isValid;
  final Map<String, String?> errors;

  const InputState({
    this.values = const {},
    this.isValid = const {},
    this.errors = const {},
  });

  bool get isComplete {
    final hasRequiredFields = _hasRequiredFields();
    final isValidFields = isValid.values.every((v) => v);
    final hasValues = values.values.every((v) => v != null && v > 0);
    final allFieldsValid = values.keys.every((field) => 
      isValid[field] == true && values[field] != null && values[field]! > 0);
    return values.isNotEmpty && hasValues && isValidFields && hasRequiredFields && allFieldsValid;
  }

  bool _hasRequiredFields() {
    return InputStateNotifier.requiredFields
        .every((field) => 
          values.containsKey(field) && 
          values[field] != null && 
          values[field]! > 0 && 
          isValid[field] == true);
  }

  InputState copyWith({
    Map<String, double>? values,
    Map<String, bool>? isValid,
    Map<String, String?>? errors,
  }) {
    return InputState(
      values: values ?? this.values,
      isValid: isValid ?? this.isValid,
      errors: errors ?? this.errors,
    );
  }
}

class Range {
  final double min;
  final double max;
  final String label;

  const Range(this.min, this.max, this.label);
}

class InputStateNotifier extends StateNotifier<InputState> {
  static const requiredFields = [
    'potassium',
    'sodium',
    'albumin',
    'chlorine',
    'hco3',
    'ph',
    'pco2',
    'pao2',
    'fio2',
    'age',
  ];

  static const Map<String, Range> fieldRanges = {
    'potassium': Range(3.5, 5.5, 'Potassium'),
    'sodium': Range(135, 145, 'Sodium'),
    'albumin': Range(3.5, 4.5, 'Albumin'),
    'chlorine': Range(98, 108, 'Chlorine'),
    'hco3': Range(22, 26, 'HCO3'),
    'ph': Range(7.35, 7.45, 'pH'),
    'pco2': Range(35, 45, 'PCO2'),
    'pao2': Range(80, 100, 'PaO2'),
    'fio2': Range(21, 100, 'FiO2'),
    'age': Range(0, 120, 'Age'),
  };

  InputStateNotifier() : super(const InputState());

  void updateValue(String field, double value) {
    final validationResult = _validateField(field, value);
    state = state.copyWith(
      values: {...state.values, field: value},
      isValid: {...state.isValid, field: validationResult.isValid},
      errors: {...state.errors, field: validationResult.error},
    );
  }

  ValidationResult _validateField(String field, double value) {
    final range = fieldRanges[field];
    if (range == null) {
      return ValidationResult(isValid: false, error: 'Invalid field');
    }
    return _validateRange(value, range.min, range.max, range.label);
  }

  ValidationResult _validateRange(
    double value,
    double min,
    double max,
    String fieldName,
  ) {
    if (value < min || value > max) {
      return ValidationResult(
        isValid: true,
        error: '$fieldName is out of the valid range ($min - $max)',
      );
    }
    return ValidationResult(isValid: true);
  }

  void resetField(String field) {
    final newValues = Map<String, double>.from(state.values)..remove(field);
    final newValid = Map<String, bool>.from(state.isValid)..remove(field);
    final newErrors = Map<String, String?>.from(state.errors)..remove(field);

    // Update validation state for all fields
    final updatedValid = <String, bool>{};
    final updatedErrors = <String, String?>{};
    
    for (final entry in newValues.entries) {
      final validationResult = _validateField(entry.key, entry.value);
      updatedValid[entry.key] = validationResult.isValid;
      updatedErrors[entry.key] = validationResult.error;
    }

    state = state.copyWith(
      values: newValues,
      isValid: updatedValid,
      errors: updatedErrors,
    );
  }

  void resetAll() {
    state = InputState(
      values: {}, // Clear all input values
      isValid: {}, // Reset validity states
      errors: {}, // Clear any error messages
    );
  }
}

class ValidationResult {
  final bool isValid;
  final String? error;

  ValidationResult({
    required this.isValid,
    this.error,
  });
}

// Main provider
final inputStateProvider =
    StateNotifierProvider<InputStateNotifier, InputState>((ref) {
  return InputStateNotifier();
});

// Helper providers
final inputValueProvider = Provider.family<double?, String>((ref, field) {
  return ref.watch(inputStateProvider).values[field];
});

final inputValidityProvider = Provider.family<bool, String>((ref, field) {
  return ref.watch(inputStateProvider).isValid[field] ?? false;
});

final inputErrorProvider = Provider.family<String?, String>((ref, field) {
  return ref.watch(inputStateProvider).errors[field];
});

final inputCompleteProvider = Provider<bool>((ref) {
  return ref.watch(inputStateProvider).isComplete;
});

// Provider to track if validation should be shown
final showValidationProvider = StateProvider<bool>((ref) => false);
