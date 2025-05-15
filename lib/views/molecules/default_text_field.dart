// lib/views/molecules/default_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../resources/constants/app_colors.dart';
import '../../providers/input/input_state_provider.dart';
import '../../services/helper.dart';

class DefaultTextField extends ConsumerWidget {
  const DefaultTextField({
    this.keyboardType,
    super.key,
    this.autovalidateMode,
    this.controller,
    this.enabled,
    this.inputFormatters,
    this.readOnly = false,
    this.validator,
    this.textInputAction,
    this.bottomPadding = 0,
    this.label = "",
    this.maxLength,
    this.maxLines,
    this.onEditingComplete,
    this.onChanged,
    this.hint,
    this.errorText,
  });
  final TextInputType? keyboardType;
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final double bottomPadding;
  final String label;
  final String? hint;
  final int? maxLength;
  final int? maxLines;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showValidation = ref.watch(showValidationProvider);
    final isEmpty = controller?.text.isEmpty ?? true;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: TextFormField(
        keyboardType: keyboardType,
        autovalidateMode: autovalidateMode,
        controller: controller,
        enabled: enabled,
        inputFormatters: inputFormatters,
        onEditingComplete: onEditingComplete,
        onTapOutside: (_) => dismissKeyboard(context),
        onChanged: onChanged,
        readOnly: readOnly,
        validator: validator,
        maxLength: maxLength,
        textInputAction: textInputAction,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26),
          labelText: showValidation && isEmpty ? '$label *' : label,
          labelStyle: showValidation && isEmpty
              ? const TextStyle(color: AppColors.deepRed)
              : const TextStyle(color: Colors.black54),
          errorText: null,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: showValidation && isEmpty ? AppColors.deepRed : Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: showValidation && isEmpty ? AppColors.deepRed : Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: showValidation && isEmpty ? AppColors.deepRed : Colors.blue,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: showValidation && isEmpty ? AppColors.deepRed : Colors.grey,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: showValidation && isEmpty ? AppColors.deepRed : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
