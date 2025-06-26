import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/index.dart';
import '../../resources/constants/app_colors.dart';
import '../../resources/constants/string_constants.dart';

class VentilatoryStateTable extends ConsumerWidget {
  const VentilatoryStateTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);

    return SizedBox(
      width: size.width * 0.95,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(4),
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
                    StringConstants.items,
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
                    StringConstants.value,
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
                    StringConstants.definition,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ]),

          // Expected PCO2 Row
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Expected\nPCO2",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                "${ref.watch(expectedPCo2CalculationProvider).toStringAsFixed(1)}->${ref.watch(inputStateProvider).values['pco2']?.toStringAsFixed(1) ?? '0.0'}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.watch(expectedPCo2ResultProvider).level.$1,
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