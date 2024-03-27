import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/input_calculator_provider.dart';
import '../../providers/result_calculator_providers.dart';
import '../../resources/constants/app_colors.dart';

class TableTwoDiagnosis extends ConsumerWidget {
  const TableTwoDiagnosis({super.key});

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
          //TODO: BB mEq/L
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
                "${ref.watch(bbCalculationProvider)}",
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

          //TODO: AG mEq/L
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
                "${ref.watch(aG2CalculationProvider)}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                // "--"
                "${ref.watch(correctedAGPresentProvider)}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ]),

          //TODO: Second Corrected A -G
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
                "${ref.watch(correctedAGPresentProvider)}",
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
//TODO: Third SIG mEq/L
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
                "${ref.watch(sigProvider)}",
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

          //TODO: Correlation(Correct-HCO3/HCO3)
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
                      "${ref.watch(correctedHCO3TwoCorrelationProvider)}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  Text(
                    "${ref.watch(correctedHCO3Provider)}->${ref.watch(hco3NotifierProvider).findingNumber}",
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
