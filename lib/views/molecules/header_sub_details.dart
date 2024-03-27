import 'package:flutter/material.dart';

class HeaderSubDetails extends StatelessWidget {
  @Deprecated(
    'Use the new design element instead '
    'This feature was deprecated after using the new design.',
  )
  const HeaderSubDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          Text(
            "enter your data in the next fields, then press 'calculate'",
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
