import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../resources/constants/calculation_constants.dart';

class ColorfulCalcTextResult extends ConsumerWidget {
  const ColorfulCalcTextResult(
      {required this.text, super.key, this.status = 0});
  final int? status;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 500),
      padding: EdgeInsets.symmetric(vertical: status != null ? 16 : 0),
      child: Container(
          constraints: const BoxConstraints(maxWidth: 250, minWidth: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: status == null || status == CalculationConstants.normalValue
                ? Colors.transparent
                : status == CalculationConstants.hyperValue
                    ? Colors.blueGrey[700]?.withOpacity(0.7)
                    : status == CalculationConstants.hypoValue
                        ? Colors.red.withOpacity(0.3)
                        : null,
          ),
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate,
            padding: EdgeInsets.symmetric(
                horizontal: status != null ? 42 : 32,
                vertical: status != null ? 16 : 8),
            child: Center(
                child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: status == 1 ? Colors.white : null,
                  decorationStyle: TextDecorationStyle.dashed,
                  decoration: status != null ? TextDecoration.underline : null,
                  fontWeight:
                      status != null ? FontWeight.w900 : FontWeight.normal),
            )),
          )),
    );
  }
}
