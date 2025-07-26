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
    final values = ref.watch(inputStateProvider).values;
    final double pco2 = values['pco2'] ?? 0;

    // Measured PCO2
    final String measuredPCO2 = pco2.toStringAsFixed(1);

    // PCO2 Status
    String pco2Status = '';
    if (pco2 > 40) {
      pco2Status = 'Respiratory Acidosis';
    } else if (pco2 < 40) {
      pco2Status = 'Respiratory Alkalosis';
    } else {
      pco2Status = 'Normocarbia';
    }

    // Diagnosis 2 (ventilatory)
    final String diagnosis = ref.watch(diagnosisThirdResultProvider);

    return SingleChildScrollView(
      child: SizedBox(
        width: size.width * 0.95,
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(3),
            2: FlexColumnWidth(6),
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Text(
                      "Definition",
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
            ...[
              [
                "Measured PCO2",
                measuredPCO2,
                pco2Status,
              ],
            ].map((row) => TableRow(children: [
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  row[2],
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 11),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: null,
                ),
              ),
            ])).toList(),
          ],
        ),
      ),
    );
  }
} 