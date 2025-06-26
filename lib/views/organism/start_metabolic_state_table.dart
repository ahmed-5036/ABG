import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/index.dart';
import '../../resources/constants/app_colors.dart';
import '../../services/calculators/calculator_factory.dart';

class StartMetabolicStateTable extends ConsumerWidget {
  const StartMetabolicStateTable({super.key});

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
          // Corrected CL Row (Only for High ABG calculations)
          if (ref.watch(calculatorTypeProvider) ==
              CalculatorType.admissionABGHigh)
            TableRow(children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Corrected CL",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  ref.watch(correctedCLProvider).toStringAsFixed(1),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  ref.watch(correctedCLProviderResult).level.$1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ]),
          // CL/NA Row
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "CL/NA",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.watch(clNaCalculationProvider).toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                ref.watch(clNaResultProvider).level.$1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ]),

          // SID mEq/L Row
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "SID mEq/L",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.watch(sidGeneralProvider).toStringAsFixed(1),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                ref.watch(sidResultProvider).level.$1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ]),

          // Corrected HCO3 Row
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Corrected HCO3",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.watch(correctedHCO3Provider)?.toStringAsFixed(1) ?? 'N/A',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                ref.watch(correctedHCO3ResultProvider).level.$1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ]),

          // Corrected AG Start Row
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Corrected AG Start",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.watch(correctedAGStartProvider).toStringAsFixed(1),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                ref.watch(correctedAGStartResultProvider),
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
