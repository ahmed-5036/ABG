import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/index.dart';
import '../../resources/constants/app_colors.dart';

class OxygenationStateTable extends ConsumerWidget {
  const OxygenationStateTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final Map<String, double> values = ref.watch(inputStateProvider).values;
    final double fio2 = values['fio2'] ?? 0;
    final double pco2 = values['pco2'] ?? 0;
    final double pao2 = values['pao2'] ?? 0;
    final double age = values['age'] ?? 0;

    // PAO2 calculation
    final double pAO2 = (fio2 * 7) - (pco2 / 0.8);
    final String pAO2Str = pAO2.toStringAsFixed(1);

    // Measured A-a calculation
    final double measuredAa = pAO2 - pao2;
    final String measuredAaStr = measuredAa.toStringAsFixed(1);

    // Expected A-a calculation
    final double expectedAa = (fio2 / 100) * age + 2.5;
    final String expectedAaStr = expectedAa.toStringAsFixed(1);

    return SingleChildScrollView(
      child: SizedBox(
        width: size.width * 0.95,
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(4),
            1: FlexColumnWidth(6),
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
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Text(
                      "Item",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLines: null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Text(
                      "Value",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLines: null,
                    ),
                  ),
                ]),
            ...<List<String>>[
              <String>[
                "PAO2",
                pAO2Str,
              ],
              <String>[
                "Measured A-a",
                measuredAaStr,
              ],
              <String>[
                "Expected A-a",
                expectedAaStr,
              ],
            ].map((List<String> row) => TableRow(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  row[0],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  row[1],
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 11),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: null,
                ),
              ),
            ])),
          ],
        ),
      ),
    );
  }
}
