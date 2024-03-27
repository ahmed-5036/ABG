import '../../resources/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/result_calculator_providers.dart';
import '../../resources/constants/app_colors.dart';

class TableFourDiagnosis extends ConsumerWidget {
  const TableFourDiagnosis({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width * 0.95,
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
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
                    "Definition",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ]),
          //TODO:PAO2 mmHg
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "PAO2 mmHg",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${ref.watch(pAOutputO2Provider).round()}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "---",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ]),

          //TODO: Second A-a
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "A-a",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${ref.watch(aAProvider).round()}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "---",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ]),
//TODO: Expected A-a
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Expected A-a",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.watch(expectedAaProvider).toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "---",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
