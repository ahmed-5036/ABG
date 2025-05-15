// lib/views/organism/copd_section_fields.dart
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
final Provider<Map<String, TextEditingController>> copdSectionControllersProvider =
    Provider<Map<String, TextEditingController>>((ProviderRef<Map<String, TextEditingController>> ref) {
  return <String, TextEditingController>{
    "sodium": TextEditingController(),
    "chlorine": TextEditingController(),
    "albumin": TextEditingController(),
    "hco3": TextEditingController(),
    "pco2": TextEditingController(),
  };
});

// Validation messages provider
final ProviderFamily<String?, String> copdSectionValidationProvider =
    Provider.family<String?, String>((ProviderRef<String?> ref, String field) {
  final InputState inputs = ref.watch(inputStateProvider);
  if ((inputs.isValid[field] ?? false) == false) {
    switch (field) {
      case 'sodium':
        return 'Sodium must be between 135 and 145';
      case 'chlorine':
        return 'Chlorine must be between 98 and 108';
      case 'albumin':
        return 'Albumin must be between 3.5 and 4.5';
      case 'hco3':
        return 'HCO3 must be around 24 mEq/L';
      case 'pco2':
        return 'PCO2 must be around 40 mmHg';
      default:
        return 'Invalid value';
    }
  }
  return null;
});

class COPDSection extends ConsumerWidget {
  const COPDSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        _buildSodiumField(context, ref),
        _buildChlorineField(context, ref),
        _buildAlbuminField(context, ref),
        _buildHCO3Field(context, ref),
        _buildPCO2Field(context, ref),
      ],
    );
  }

  Widget _buildSodiumField(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final InputState inputState = ref.watch(inputStateProvider);
        final double? value = inputState.values['sodium'];
        final bool isValid = inputState.isValid['sodium'] ?? false;

        return AdaptiveInputDialog(
          firstInput: DefaultTextField(
            textInputAction: TextInputAction.next,
            label: 'Na mEq/L (135-145)',
            hint: 'Na mEq/L',
            controller: ref.read(copdSectionControllersProvider)["sodium"],
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(numberWithDecimalRegex),
              LengthLimitingTextInputFormatter(5),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (String value) {
              if (value.isEmpty) {
                ref.read(inputStateProvider.notifier).resetField('sodium');
              } else {
                final double? numValue = double.tryParse(value.toParsableString());
                if (numValue != null) {
                  ref
                      .read(inputStateProvider.notifier)
                      .updateValue('sodium', numValue);
                }
              }
            },
            errorText: ref.watch(copdSectionValidationProvider('sodium')),
          ),
          secondInput: ColorfulCalcTextResult(
            text: _getSodiumResultText(value, isValid),
            status: _getSodiumResultStatus(value, isValid),
          ),
        );
      },
    );
  }

  Widget _buildChlorineField(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final InputState inputState = ref.watch(inputStateProvider);
        final double? value = inputState.values['chlorine'];
        final bool isValid = inputState.isValid['chlorine'] ?? false;

        return AdaptiveInputDialog(
          firstInput: DefaultTextField(
            textInputAction: TextInputAction.next,
            label: 'CL mEq/L (98-108)',
            hint: 'CL mEq/L',
            controller: ref.read(copdSectionControllersProvider)["chlorine"],
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(numberWithDecimalRegex),
              LengthLimitingTextInputFormatter(4),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (String value) {
              if (value.isEmpty) {
                ref.read(inputStateProvider.notifier).resetField('chlorine');
              } else {
                final double? numValue = double.tryParse(value.toParsableString());
                if (numValue != null) {
                  ref
                      .read(inputStateProvider.notifier)
                      .updateValue('chlorine', numValue);
                }
              }
            },
            errorText: ref.watch(copdSectionValidationProvider('chlorine')),
          ),
          secondInput: ColorfulCalcTextResult(
            text: _getChlorineResultText(value, isValid),
            status: _getChlorineResultStatus(value, isValid),
          ),
        );
      },
    );
  }

  Widget _buildAlbuminField(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final InputState inputState = ref.watch(inputStateProvider);
        final double? value = inputState.values['albumin'];
        final bool isValid = inputState.isValid['albumin'] ?? false;

        return AdaptiveInputDialog(
          firstInput: DefaultTextField(
            textInputAction: TextInputAction.next,
            label: 'Albumin g% (3.5-4.5)',
            hint: 'Albumin g%',
            controller: ref.read(copdSectionControllersProvider)["albumin"],
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(numberWithDecimalRegex),
              LengthLimitingTextInputFormatter(4),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (String value) {
              if (value.isEmpty) {
                ref.read(inputStateProvider.notifier).resetField('albumin');
              } else {
                final double? numValue = double.tryParse(value.toParsableString());
                if (numValue != null) {
                  ref
                      .read(inputStateProvider.notifier)
                      .updateValue('albumin', numValue);
                }
              }
            },
            errorText: ref.watch(copdSectionValidationProvider('albumin')),
          ),
          secondInput: ColorfulCalcTextResult(
            text: _getAlbuminResultText(value, isValid),
            status: _getAlbuminResultStatus(value, isValid),
          ),
        );
      },
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
            controller: ref.read(copdSectionControllersProvider)["hco3"],
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
            errorText: ref.watch(copdSectionValidationProvider('hco3')),
          ),
          secondInput: ColorfulCalcTextResult(
            text: _getHCO3ResultText(value, isValid),
            status: _getHCO3ResultStatus(value, isValid),
          ),
        );
      },
    );
  }

  Widget _buildPCO2Field(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final InputState inputState = ref.watch(inputStateProvider);
        final double? value = inputState.values['pco2'];
        final bool isValid = inputState.isValid['pco2'] ?? false;

        return AdaptiveInputDialog(
          firstInput: DefaultTextField(
            textInputAction: TextInputAction.next,
            hint: "PCO2 mmHg",
            label: "PCO2 mmHg (40)",
            controller: ref.read(copdSectionControllersProvider)["pco2"],
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(numberWithDecimalRegex),
              LengthLimitingTextInputFormatter(3),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (String value) {
              if (value.isEmpty) {
                ref.read(inputStateProvider.notifier).resetField('pco2');
              } else {
                final double? numValue = double.tryParse(value);
                if (numValue != null) {
                  ref
                      .read(inputStateProvider.notifier)
                      .updateValue('pco2', numValue);
                }
              }
            },
            errorText: ref.watch(copdSectionValidationProvider('pco2')),
          ),
          secondInput: ColorfulCalcTextResult(
            text: _getPCO2ResultText(value, isValid),
            status: _getPCO2ResultStatus(value, isValid),
          ),
        );
      },
    );
  }

  // Result text and status helpers
  String _getSodiumResultText(double? value, bool isValid) {
    if (value == null || !isValid) return 'N/A';
    return value < 135
        ? 'Hyponatremia'
        : value > 145
            ? 'Hypernatremia'
            : 'Normal';
  }

  int? _getSodiumResultStatus(double? value, bool isValid) {
    if (value == null || !isValid) return null;
    return value < 135
        ? -1
        : value > 145
            ? 1
            : 0;
  }

  String _getChlorineResultText(double? value, bool isValid) {
    if (value == null || !isValid) return 'N/A';
    return value < 98
        ? 'Hypochloremia'
        : value > 108
            ? 'Hyperchloremia'
            : 'Normal';
  }

  int? _getChlorineResultStatus(double? value, bool isValid) {
    if (value == null || !isValid) return null;
    return value < 98
        ? -1
        : value > 108
            ? 1
            : 0;
  }

  String _getAlbuminResultText(double? value, bool isValid) {
    if (value == null || !isValid) return 'N/A';
    return value < 3.5
        ? 'Hypoalbuminemia'
        : value > 4.5
            ? 'Hyperalbuminemia'
            : 'Normal';
  }

  int? _getAlbuminResultStatus(double? value, bool isValid) {
    if (value == null || !isValid) return null;
    return value < 3.5
        ? -1
        : value > 4.5
            ? 1
            : 0;
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

  // static void resetFields(WidgetRef ref) {
  //   final controllers = ref.read(copdSectionControllersProvider);
  //
  //   // 2. Clear each controller and reset the corresponding field in input state
  //   controllers.forEach((field, controller) {
  //     // Clear the text controller
  //     controller.clear();
  //
  //     // Reset the field in inputStateProvider - this clears the result text
  //     ref.read(inputStateProvider.notifier).resetField(field);
  //   });
  // }
}
