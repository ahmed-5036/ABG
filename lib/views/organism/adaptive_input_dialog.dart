import 'package:flutter/material.dart';

class AdaptiveInputDialog extends StatelessWidget {
  const AdaptiveInputDialog(
      {required this.firstInput,
      required this.secondInput,
      super.key,
      this.flexFirst = 2,
      this.flexSecond = 1});
  final Widget firstInput;
  final Widget secondInput;
  final int flexFirst;
  final int flexSecond;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => constraints
                  .maxWidth >
              650
          ? Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(flex: flexFirst, child: firstInput),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(flex: flexSecond, child: Center(child: secondInput))
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[firstInput, secondInput]),
    );
  }
}
