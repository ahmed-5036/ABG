import 'package:flutter/material.dart';

import '../../resources/constants/app_colors.dart';

class BorderedButton extends StatelessWidget {
  const BorderedButton(
      {super.key,
      this.action,
      this.label = "",
      this.enabled = true,
      this.onHover,
      this.color,
      this.verticalPadding,
      this.customWidgetLabel,
      this.customHeight = 50});

  final VoidCallback? action;
  final String label;
  final Widget? customWidgetLabel;
  final bool enabled;
  final Function(bool)? onHover;
  final Color? color;
  final double? verticalPadding;
  final double customHeight;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return FilledButton(
      onPressed: enabled ? action : null,
      onHover: onHover,
      style: FilledButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          fixedSize:
              Size(size.width * 0.8, customHeight + (verticalPadding ?? 0) * 2),
          backgroundColor: color ?? AppColors.deepRed),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 0),
        child: customWidgetLabel ??
            Text(
              label,
              textAlign: TextAlign.center,
            ),
      ),
    );
  }
}
