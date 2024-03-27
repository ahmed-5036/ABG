import 'package:flutter/material.dart';

class CircularIcon extends StatelessWidget {
  @Deprecated(
    'Use the new design element instead '
    'This feature was deprecated after using the new design.',
  )
  const CircularIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 24,
      backgroundColor: Color.fromRGBO(252, 243, 235, 1),
      child: Icon(
        Icons.vaccines,
        size: 18,
        color: Color.fromRGBO(228, 131, 55, 1),
      ),
    );
  }
}
