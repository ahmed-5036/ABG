import 'package:flutter/material.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({super.key, this.text = "", this.customWidgetLabel});
  final String text;
  final Widget? customWidgetLabel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: customWidgetLabel ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                text,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ],
          ),
    );
  }
}
