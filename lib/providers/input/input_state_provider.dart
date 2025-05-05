// lib/providers/input/input_state_provider.dart
// lib/providers/input/input_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../resources/constants/calculation_constants.dart';
import '../../services/validator.dart';

class InputState {
  final Map<String, double> values;
  final Map<String, bool> isValid;
  final Map<String, String?> errors;

  const InputState({
    required this.values,
    required this.isValid,
    required this.errors,
  });

  bool get isComplete {
    final hasRequiredFields = _hasRequiredFields();
    final isValidFields = isValid.values.every((v) => v);
    print("isComplete: $hasRequiredFields && $isValidFields");
    return values.isNotEmpty && isValidFields && hasRequiredFields;
  }

  bool _hasRequiredFields() {
    return InputStateNotifier.requiredFields
        .every((field) => values.containsKey(field));
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

  InputStateNotifier()
      : super(const InputState(
          values: {},
          isValid: {},
          errors: {},
        ));

  void updateValue(String field, double value) {
    final validationResult = _validateField(field, value);
    print(
        "Updating field: $field with value: $value, valid: ${validationResult.isValid}");
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

  // Modify the _validateRange method to accept values but still flag them
  ValidationResult _validateRange(
    double value,
    double min,
    double max,
    String fieldName,
  ) {
    if (value < min || value > max) {
      // The value is out of range, but still accepted
      return ValidationResult(
        isValid:
            true, // This will accept the input even though it's out of range
        error: '$fieldName is out of the valid range ($min - $max)',
      );
    }
    return ValidationResult(isValid: true); // Value is within the valid range
  }

  void resetField(String field) {
    final newValues = Map<String, double>.from(state.values)..remove(field);
    final newValid = Map<String, bool>.from(state.isValid)..remove(field);
    final newErrors = Map<String, String?>.from(state.errors)..remove(field);

    state = state.copyWith(
      values: newValues,
      isValid: newValid,
      errors: newErrors,
    );
  }

  void resetAll() {
    state = const InputState(
      values: {},
      isValid: {},
      errors: {},
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
