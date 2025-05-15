// lib/providers/input/input_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InputState {
  final Map<String, double> values;
  final Map<String, bool> isValid;
  final Map<String, String?> errors;

  const InputState({
    this.values = const <String, double>{},
    this.isValid = const <String, bool>{},
    this.errors = const <String, String?>{},
  });

  bool get isComplete {
    final bool hasRequiredFields = _hasRequiredFields();
    final bool isValidFields = isValid.values.every((bool v) => v);
    final bool hasValues = values.values.every((double v) => v > 0);
    final bool allFieldsValid = values.keys.every((String field) => 
      isValid[field] == true && values[field] != null && values[field]! > 0);
    return values.isNotEmpty && hasValues && isValidFields && hasRequiredFields && allFieldsValid;
  }

  bool _hasRequiredFields() {
    return InputStateNotifier.requiredFields
        .every((String field) => 
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
  static const List<String> requiredFields = <String>[
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

  static const Map<String, Range> fieldRanges = <String, Range>{
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
    final ValidationResult validationResult = _validateField(field, value);
    state = state.copyWith(
      values: <String, double>{...state.values, field: value},
      isValid: <String, bool>{...state.isValid, field: validationResult.isValid},
      errors: <String, String?>{...state.errors, field: validationResult.error},
    );
  }

  ValidationResult _validateField(String field, double value) {
    final Range? range = fieldRanges[field];
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
    final Map<String, double> newValues = Map<String, double>.from(state.values)..remove(field);
    final Map<String, bool> newValid = Map<String, bool>.from(state.isValid)..remove(field);
    final Map<String, String?> newErrors = Map<String, String?>.from(state.errors)..remove(field);

    // Update validation state for all fields
    final Map<String, bool> updatedValid = <String, bool>{};
    final Map<String, String?> updatedErrors = <String, String?>{};
    
    for (final MapEntry<String, double> entry in newValues.entries) {
      final ValidationResult validationResult = _validateField(entry.key, entry.value);
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
    state = const InputState(
      values: <String, double>{}, // Clear all input values
      isValid: <String, bool>{}, // Reset validity states
      errors: <String, String?>{}, // Clear any error messages
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
final StateNotifierProvider<InputStateNotifier, InputState> inputStateProvider =
    StateNotifierProvider<InputStateNotifier, InputState>((StateNotifierProviderRef<InputStateNotifier, InputState> ref) {
  return InputStateNotifier();
});

// Helper providers
final ProviderFamily<double?, String> inputValueProvider = Provider.family<double?, String>((ProviderRef<double?> ref, String field) {
  return ref.watch(inputStateProvider).values[field];
});

final ProviderFamily<bool, String> inputValidityProvider = Provider.family<bool, String>((ProviderRef<bool> ref, String field) {
  return ref.watch(inputStateProvider).isValid[field] ?? false;
});

final ProviderFamily<String?, String> inputErrorProvider = Provider.family<String?, String>((ProviderRef<String?> ref, String field) {
  return ref.watch(inputStateProvider).errors[field];
});

final Provider<bool> inputCompleteProvider = Provider<bool>((ProviderRef<bool> ref) {
  return ref.watch(inputStateProvider).isComplete;
});

// Provider to track if validation should be shown
final StateProvider<bool> showValidationProvider = StateProvider<bool>((StateProviderRef<bool> ref) => false);
