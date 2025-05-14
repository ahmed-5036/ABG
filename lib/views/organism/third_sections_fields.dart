// lib/views/organism/third_sections_fields.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/index.dart';
import '../../resources/constants/app_constants.dart';
import '../../services/extension.dart';
import '../molecules/default_text_field.dart';
import 'adaptive_input_dialog.dart';
import 'colorful_text_result.dart';

// Controller provider
final thirdSectionControllersProvider =
    Provider<Map<String, TextEditingController>>((ref) {
  return {
    "pco2": TextEditingController(),
    "fio2": TextEditingController(),
    "age": TextEditingController(),
    "pao2": TextEditingController(),
  };
});

// Validation messages provider
final thirdSectionValidationProvider =
    Provider.family<String?, String>((ref, field) {
  final inputs = ref.watch(inputStateProvider);
  if ((inputs.isValid[field] ?? false) == false) {
    switch (field) {
      case 'pco2':
        return 'PCO2 must be around 40 mmHg';
      case 'fio2':
        return 'FiO2 must be around 21%';
      case 'age':
        return 'Age must be a valid number';
      case 'pao2':
        return 'PaO2 must be a valid number';
      default:
        return 'Invalid value';
    }
  }
  return null;
});

class ThirdSection extends ConsumerWidget {
  const ThirdSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(height: 8),
        _buildPCO2Field(ref),
        _buildFIO2Field(ref),
        _buildAgeField(ref),
        _buildPAO2Field(ref),
      ],
    );
  }

  Widget _buildPCO2Field(WidgetRef ref) {
    final inputState = ref.watch(inputStateProvider);
    final value = inputState.values['pco2'];
    final isValid = inputState.isValid['pco2'] ?? false;

    return AdaptiveInputDialog(
      firstInput: DefaultTextField(
        textInputAction: TextInputAction.next,
        hint: "PCO2 mmHg",
        label: "PCO2 mmHg (40)",
        controller: ref.read(thirdSectionControllersProvider)["pco2"],
        inputFormatters: [
          FilteringTextInputFormatter.allow(numberWithDecimalRegex),
          LengthLimitingTextInputFormatter(3),
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          if (value.isEmpty) {
            ref.read(inputStateProvider.notifier).updateValue('pco2', 0);
          } else {
            final numValue = double.tryParse(value);
            if (numValue != null) {
              ref
                  .read(inputStateProvider.notifier)
                  .updateValue('pco2', numValue);
            }
          }
        },
        errorText: ref.watch(thirdSectionValidationProvider('pco2')),
      ),
      secondInput: ColorfulCalcTextResult(
        text: _getPCO2ResultText(value, isValid),
        status: _getPCO2ResultStatus(value, isValid),
      ),
    );
  }

  String _getPCO2ResultText(double? value, bool isValid) {
    if (value == null || !isValid) return 'N/A';

    if (value < 35) {
      return 'Hypocapnia';
    } else if (value > 45) {
      return 'Hypercapnia';
    } else {
      return 'Normal';
    }
  }

  int? _getPCO2ResultStatus(double? value, bool isValid) {
    if (value == null || !isValid) return null;

    if (value < 35) {
      return 1; // Hypocapnia
    } else if (value > 45) {
      return -1; // Hypercapnia
    } else {
      return 0; // Normal
    }
  }

  Widget _buildFIO2Field(WidgetRef ref) {
    final inputState = ref.watch(inputStateProvider);
    final value = inputState.values['fio2'];
    final isValid = inputState.isValid['fio2'] ?? false;

    return AdaptiveInputDialog(
      firstInput: DefaultTextField(
        textInputAction: TextInputAction.next,
        hint: "FiO2%",
        label: "FiO2% (21)",
        controller: ref.read(thirdSectionControllersProvider)["fio2"],
        inputFormatters: [
          FilteringTextInputFormatter.allow(numberWithDecimalRegex),
          LengthLimitingTextInputFormatter(3),
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          if (value.isEmpty) {
            ref.read(inputStateProvider.notifier).updateValue('fio2', 0);
          } else {
            final numValue = double.tryParse(value);
            if (numValue != null) {
              ref
                  .read(inputStateProvider.notifier)
                  .updateValue('fio2', numValue);
            }
          }
        },
        errorText: ref.watch(thirdSectionValidationProvider('fio2')),
      ),
      secondInput: ColorfulCalcTextResult(
        text: _getFIO2ResultText(value, isValid),
        status: _getFIO2ResultStatus(value, isValid),
      ),
    );
  }

  String _getFIO2ResultText(double? value, bool isValid) {
    if (value == null || !isValid) return 'N/A';
    if (value < 21) return 'Hypoxic FiO2';
    if (value > 60) return 'High Oxygen';
    return 'Normal FiO2';
  }

  int? _getFIO2ResultStatus(double? value, bool isValid) {
    if (value == null || !isValid) return null;
    if (value < 21) return -1; // Dangerously low
    if (value > 60) return 1; // High, may indicate O2 therapy
    return 0; // Normal room air
  }

  Widget _buildAgeField(WidgetRef ref) {
    final inputState = ref.watch(inputStateProvider);
    final value = inputState.values['age'];
    final isValid = inputState.isValid['age'] ?? false;

    return AdaptiveInputDialog(
      firstInput: DefaultTextField(
        textInputAction: TextInputAction.next,
        hint: "Age",
        label: "Age (years)",
        controller: ref.read(thirdSectionControllersProvider)["age"],
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(2),
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          if (value.isEmpty) {
            ref.read(inputStateProvider.notifier).updateValue('age', 0);
          } else {
            final numValue = double.tryParse(value);
            if (numValue != null) {
              ref
                  .read(inputStateProvider.notifier)
                  .updateValue('age', numValue);
            }
          }
        },
        errorText: ref.watch(thirdSectionValidationProvider('age')),
      ),
      secondInput: ColorfulCalcTextResult(
        text: _getAgeResultText(value, isValid),
        status: _getAgeResultStatus(value, isValid),
      ),
    );
  }

  String _getAgeResultText(double? value, bool isValid) {
    if (value == null || !isValid) return 'N/A';
    if (value < 0) return 'Invalid age';
    if (value < 18) return 'Pediatric';
    if (value < 65) return 'Adult';
    return 'Elderly';
  }

  int? _getAgeResultStatus(double? value, bool isValid) {
    if (value == null || !isValid) return null;
    if (value < 18) return 1; // Pediatric
    if (value >= 65) return -1; // Elderly
    return 0; // Adult
  }

  Widget _buildPAO2Field(WidgetRef ref) {
    final inputState = ref.watch(inputStateProvider);
    final value = inputState.values['pao2'];
    final isValid = inputState.isValid['pao2'] ?? false;

    return AdaptiveInputDialog(
      firstInput: DefaultTextField(
        textInputAction: TextInputAction.next,
        hint: "PaO2 mmHg",
        label: "PaO2 mmHg",
        controller: ref.read(thirdSectionControllersProvider)["pao2"],
        inputFormatters: [
          FilteringTextInputFormatter.allow(numberWithDecimalRegex),
          LengthLimitingTextInputFormatter(3),
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          if (value.isEmpty) {
            ref.read(inputStateProvider.notifier).updateValue('pao2', 0);
          } else {
            final numValue = double.tryParse(value);
            if (numValue != null) {
              ref
                  .read(inputStateProvider.notifier)
                  .updateValue('pao2', numValue);
            }
          }
        },
        errorText: ref.watch(thirdSectionValidationProvider('pao2')),
      ),
      secondInput: ColorfulCalcTextResult(
        text: _getPAO2ResultText(value, isValid),
        status: _getPAO2ResultStatus(value, isValid),
      ),
    );
  }

  String _getPAO2ResultText(double? value, bool isValid) {
    if (value == null || !isValid) return 'N/A';
    if (value < 60) return 'Severe Hypoxemia';
    if (value < 80) return 'Mild Hypoxemia';
    if (value > 100) return 'Hyperoxia';
    return 'Normal';
  }

  int? _getPAO2ResultStatus(double? value, bool isValid) {
    if (value == null || !isValid) return null;
    if (value < 60) return -2; // Critical
    if (value < 80) return -1; // Mild
    if (value > 100) return 1; // Excess O2
    return 0; // Normal
  }
}
