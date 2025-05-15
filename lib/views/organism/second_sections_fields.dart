// lib/views/organism/second_sections_fields.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/index.dart';
import '../../resources/constants/app_constants.dart';
import '../molecules/default_text_field.dart';
import 'adaptive_input_dialog.dart';
import 'colorful_text_result.dart';

// Controller provider
final Provider<Map<String, TextEditingController>> secondSectionControllersProvider =
    Provider<Map<String, TextEditingController>>((ProviderRef<Map<String, TextEditingController>> ref) {
  return <String, TextEditingController>{
    "hco3": TextEditingController(),
    "ph": TextEditingController(),
  };
});

// Validation messages provider
final ProviderFamily<String?, String> secondSectionValidationProvider =
    Provider.family<String?, String>((ProviderRef<String?> ref, String field) {
  final InputState inputs = ref.watch(inputStateProvider);
  if ((inputs.isValid[field] ?? false) == false) {
    switch (field) {
      case 'hco3':
        return 'HCO3 must be around 24 mEq/L';
      case 'ph':
        return 'pH must be around 7.4';
      default:
        return 'Invalid value';
    }
  }
  return null;
});

class SecondSection extends ConsumerWidget {
  const SecondSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        _buildHCO3Field(context, ref),
        _buildPHField(context, ref),
      ],
    );
  }

  Widget _buildHCO3Field(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final InputState inputState = ref.watch(inputStateProvider);
        final double? value = inputState.values['hco3'];
        final bool isValid = inputState.isValid['hco3'] ?? false;

        return AdaptiveInputDialog(
          firstInput: DefaultTextField(
            textInputAction: TextInputAction.next,
            label: "HCO3 mEq/L (24)",
            hint: "HCO3 mEq/L",
            controller: ref.read(secondSectionControllersProvider)["hco3"],
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(numberWithDecimalRegex),
              LengthLimitingTextInputFormatter(3),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (String value) {
              if (value.isEmpty) {
                ref.read(inputStateProvider.notifier).resetField('hco3');
              } else {
                final double? numValue = double.tryParse(value);
                if (numValue != null) {
                  ref
                      .read(inputStateProvider.notifier)
                      .updateValue('hco3', numValue);
                }
              }
            },
            errorText: ref.watch(secondSectionValidationProvider('hco3')),
          ),
          secondInput: ColorfulCalcTextResult(
            text: _getHCO3ResultText(value, isValid),
            status: _getHCO3ResultStatus(value, isValid),
          ),
        );
      },
    );
  }

  Widget _buildPHField(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final InputState inputState = ref.watch(inputStateProvider);
        final double? value = inputState.values['ph'];
        final bool isValid = inputState.isValid['ph'] ?? false;

        return AdaptiveInputDialog(
          firstInput: DefaultTextField(
            textInputAction: TextInputAction.next,
            hint: "PH",
            label: "PH (7.4)",
            controller: ref.read(secondSectionControllersProvider)["ph"],
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(numberWithDecimalRegex),
              LengthLimitingTextInputFormatter(6),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (String value) {
              if (value.isEmpty) {
                ref.read(inputStateProvider.notifier).resetField('ph');
              } else {
                final double? numValue = double.tryParse(value);
                if (numValue != null) {
                  ref
                      .read(inputStateProvider.notifier)
                      .updateValue('ph', numValue);
                }
              }
            },
            errorText: ref.watch(secondSectionValidationProvider('ph')),
          ),
          secondInput: ColorfulCalcTextResult(
            text: _getPHResultText(value, isValid),
            status: _getPHResultStatus(value, isValid),
          ),
        );
      },
    );
  }

  String _getHCO3ResultText(double? value, bool isValid) {
    if (value == null || !isValid) return 'N/A';

    if (value == 24) {
      return 'Normal metabolic state';
    } else if (value < 24) {
      return 'Metabolic acidosis';
    } else {
      return 'Metabolic alkalosis';
    }
  }

  int? _getHCO3ResultStatus(double? value, bool isValid) {
    if (value == null || !isValid) return null;

    if (value == 24) {
      return 0; // normal
    } else if (value < 24) {
      return -1; // acidosis
    } else {
      return 1; // alkalosis
    }
  }

  String _getPHResultText(double? value, bool isValid) {
    if (value == null || !isValid) return 'N/A';

    if (value == 7.4) {
      return 'Normal';
    } else if (value < 7.4) {
      return 'Acidosis';
    } else {
      return 'Alkalosis';
    }
  }

  int? _getPHResultStatus(double? value, bool isValid) {
    if (value == null || !isValid) return null;

    if (value == 7.4) {
      return 0; // normal
    } else if (value < 7.4) {
      return -1; // acidosis
    } else {
      return 1; // alkalosis
    }
  }
}
