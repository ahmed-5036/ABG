import 'package:flutter/material.dart';

@immutable
class FinalResult<T> {
  final T findingLevel;
  final double? findingNumber;

  const FinalResult({required this.findingLevel, required this.findingNumber});

  @override
  String toString() {
    // TODO: implement toString
    return "{findingLevel:${this.findingLevel},findingNumber:${this.findingNumber}}";
  }
}
