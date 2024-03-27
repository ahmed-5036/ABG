



import 'package:flutter/material.dart';

import '../molecules/circular_icon.dart';

class TopHeaderSection extends StatelessWidget {
    @Deprecated(
      'Use the new design element instead '
      'This feature was deprecated after using the new design.',
    )
  const TopHeaderSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: <Widget>[
          CircularIcon(),
          SizedBox(width: 16,),
          Text("ABG"),
          Spacer(),
          Icon(Icons.info_outline)
        ],
      ),
    );
  }
}
