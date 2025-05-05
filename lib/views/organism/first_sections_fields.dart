// lib/views/organism/first_sections_fields.dart
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
final firstSectionControllersProvider =
    Provider<Map<String, TextEditingController>>((ref) {
  return {
    "potassium": TextEditingController(),
    "sodium": TextEditingController(),
    "albumin": TextEditingController(),
    "chlorine": TextEditingController(),
  };
});

// Validation messages provider
final firstSectionValidationProvider =
    Provider.family<String?, String>((ref, field) {
  final inputs = ref.watch(inputStateProvider);
  if (inputs.isValid[field] != true) {
    switch (field) {
      case 'potassium':
        return 'Potassium must be between 3.5 and 5.5';
      case 'sodium':
        return 'Sodium must be between 135 and 145';
      case 'albumin':
        return 'Albumin must be between 3.5 and 4.5';
      case 'chlorine':
        return 'Chlorine must be between 98 and 108';
      default:
        return 'Invalid value';
    }
  }
  return null;
});

class FirstSection extends ConsumerWidget {
  const FirstSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(height: 8),
        _buildInputField(
          context: context,
          ref: ref,
          field: 'potassium',
          label: 'K mEq/L (3.5-5.5)',
          hint: 'K mEq/L',
          maxLength: 4,
        ),
        _buildInputField(
          context: context,
          ref: ref,
          field: 'sodium',
          label: 'Na mEq/L (135-145)',
          hint: 'Na mEq/L',
          maxLength: 5,
        ),
        _buildInputField(
          context: context,
          ref: ref,
          field: 'albumin',
          label: 'Albumin g% (3.5-4.5)',
          hint: 'Albumin g%',
          maxLength: 4,
        ),
        _buildInputField(
          context: context,
          ref: ref,
          field: 'chlorine',
          label: 'CL mEq/L (98-108)',
          hint: 'CL mEq/L',
          maxLength: 4,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required WidgetRef ref,
    required String field,
    required String label,
    required String hint,
    required int maxLength,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final inputState = ref.watch(inputStateProvider);
        final value = inputState.values[field];
        final isValid = inputState.isValid[field] ?? false;

        return AdaptiveInputDialog(
          firstInput: DefaultTextField(
            textInputAction: TextInputAction.next,
            hint: hint,
            label: label,
            controller: ref.read(firstSectionControllersProvider)[field],
            inputFormatters: [
              FilteringTextInputFormatter.allow(numberWithDecimalRegex),
              LengthLimitingTextInputFormatter(maxLength),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              final numValue = double.tryParse(value.toParsableString());
              if (numValue != null) {
                ref
                    .read(inputStateProvider.notifier)
                    .updateValue(field, numValue);
              }
            },
            errorText: ref.watch(firstSectionValidationProvider(field)),
          ),
          secondInput: ColorfulCalcTextResult(
            text: _getResultText(field, value, isValid),
            status: _getResultStatus(field, value, isValid),
          ),
        );
      },
    );
  }

  String _getResultText(String field, double? value, bool isValid) {
    if (value == null || !isValid) return 'N/A';

    switch (field) {
      case 'potassium':
        return value < 3.5
            ? 'Hypokalemia'
            : value > 5.5
                ? 'Hyperkalemia'
                : 'Normal';
      case 'sodium':
        return value < 135
            ? 'Hyponatremia'
            : value > 145
                ? 'Hypernatremia'
                : 'Normal';
      case 'albumin':
        return value < 3.5
            ? 'Hypoalbuminemia'
            : value > 4.5
                ? 'Hyperalbuminemia'
                : 'Normal';
      case 'chlorine':
        return value < 98
            ? 'Hypochloremia'
            : value > 108
                ? 'Hyperchloremia'
                : 'Normal';
      default:
        return 'N/A';
    }
  }

  int? _getResultStatus(String field, double? value, bool isValid) {
    if (value == null || !isValid) return null;

    switch (field) {
      case 'potassium':
        return value < 3.5
            ? -1
            : value > 5.5
                ? 1
                : 0;
      case 'sodium':
        return value < 135
            ? -1
            : value > 145
                ? 1
                : 0;
      case 'albumin':
        return value < 3.5
            ? -1
            : value > 4.5
                ? 1
                : 0;
      case 'chlorine':
        return value < 98
            ? -1
            : value > 108
                ? 1
                : 0;
      default:
        return null;
    }
  }
}
