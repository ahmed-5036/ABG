import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/index.dart';
import '../../resources/constants/app_colors.dart';

class PresentMetabolicChangeTable extends ConsumerWidget {
  const PresentMetabolicChangeTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);

    return SizedBox(
      width: size.width * 0.95,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(3),
        },
        border: TableBorder.all(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(5),
            width: 2),
        children: <TableRow>[
          TableRow(
              decoration: BoxDecoration(color: AppColors.blue.withOpacity(0.3)),
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Text(
                    "Items",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Text(
                    "Value",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Text(
                    "Definition",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ]),
          // BB mEq/L
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "BB mEq/L",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.watch(bbCalculationProvider).toStringAsFixed(1),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                ref.watch(bbResultProvider).level.$1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ]),

          // A-G
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "A-G",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.watch(aG2CalculationProvider).toStringAsFixed(1),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                ref.watch(correctedAGPresentProvider).toStringAsFixed(1),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ]),

          // Corrected A-G Present
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Corrected A-G Present",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                ref.watch(correctedAGPresentProvider).toStringAsFixed(1),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.watch(correctedAGPresentResultProvider).level.$1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ]),

          // SIG mEq/L
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "SIG mEq/L",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                ref.watch(sigProvider).toStringAsFixed(1),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.watch(sigResultProvider).level.$1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ]),

          // Correlation(Correct-HCO3/HCO3)
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Correlation\n(Correct-HCO3/HCO3)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: <Widget>[
                  Visibility(
                    visible: false,
                    child: Text(
                      ref
                          .watch(correctedHCO3TwoCorrelationProvider)
                          .toStringAsFixed(1),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Text(
                    "${ref.watch(correctedHCO3ForCorrelationProvider)!.toStringAsFixed(1)}->${ref.watch(inputStateProvider).values['hco3']?.toStringAsFixed(1) ?? '0.0'}",
                    style: const TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "(${ref.watch(correlationHCO3Provider).level.$1})",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
