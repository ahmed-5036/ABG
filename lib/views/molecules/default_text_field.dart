import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/helper.dart';

class DefaultTextField extends StatelessWidget {
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
    String? errorText,
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

  @override
  Widget build(BuildContext context) {
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
            label: Text(label, style: const TextStyle(color: Colors.black54)),
            border: const OutlineInputBorder()),
      ),
    );
  }
}
