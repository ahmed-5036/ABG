import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/index.dart';
import '../../resources/constants/app_colors.dart';
import '../../services/calculators/calculator_factory.dart';

class VentilatoryStateTable extends ConsumerWidget {
  const VentilatoryStateTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final Map<String, double> values = ref.watch(inputStateProvider).values;
    final double pco2 = values['pco2'] ?? 0;
    final double hco3 = values['hco3'] ?? 0;
    final CalculatorType calculatorType = ref.watch(calculatorTypeProvider);
    final bool isPrimaryMetabolic =
        calculatorType == CalculatorType.followUpABGMetabolic;

    if (isPrimaryMetabolic) {
      // Primary Metabolic Insult Logic
      // 1. Measured PCO2
      final String measuredPCO2 = pco2.toStringAsFixed(1);

      // 2. Expected PCO2
      double expectedPCO2;
      String expectedPCO2Formula;
      if (hco3 < 24) {
        expectedPCO2 = 40 - ((24 - hco3) * 1.2);
        expectedPCO2Formula = 'Expected PCO2 = 40 - [(24 - HCO3) x 1.2]';
      } else {
        expectedPCO2 = 40 - ((24 - hco3) * 0.6);
        expectedPCO2Formula = 'Expected PCO2 = 40 - [(24 - HCO3) x 0.6]';
      }
      final String expectedPCO2Str = expectedPCO2.toStringAsFixed(1);

      // 3. Expected PCO2 to measured PCO2 (compensation logic)
      String compensationResult = 'No compensation';
      if (expectedPCO2 < pco2) {
        compensationResult = 'non-compensatory hypo ventilatory respiratory acidosis';
      } else if (expectedPCO2 > pco2) {
        compensationResult = 'non-compensatory hyper ventilatory respiratory alkalosis';
      } else if (expectedPCO2 == pco2) {
        if (pco2 < 40) {
          compensationResult = ' <40 = compensatory respiratory alkalosis';
        } else if (pco2 > 40) {
          compensationResult = 'compensatory respiratory acidosis';
        } else {
          compensationResult = 'respiratory compensation';
        }
      } else if ((expectedPCO2 - pco2).abs() <= 3) {
        compensationResult = 'respiratory compensation';
      }

      return SingleChildScrollView(
        child: SizedBox(
          width: size.width * 0.99,
          child: Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(3.5),
              1: FlexColumnWidth(2.5),
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
                        "Result",
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
                  "Measured PCO2",
                  measuredPCO2,
                  "-",
                ],
                <String>[
                  "Expected PCO2",
                  expectedPCO2Str,
                  "-",
                ],
                <String>[
                  "Expected PCO2 to measured PCO2",
                  "${expectedPCO2.toStringAsFixed(1)}/${pco2.toStringAsFixed(1)}",
                  compensationResult,
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
              ])),
            ],
          ),
        ),
      );
    } else {
      // Primary Respiratory Insult Logic
      // Measured PCO2
      final String measuredPCO2 = pco2.toStringAsFixed(1);

      // PCO2 Status - Only basic 3 states for primary respiratory insult
      String pco2Status = '';
      if (pco2 > 40) {
        pco2Status = 'Respiratory Acidosis';
      } else if (pco2 < 40) {
        pco2Status = 'Respiratory Alkalosis';
      } else {
        pco2Status = 'Normocarbia';
      }

      // Diagnosis 2 (ventilatory)
      final String diagnosis = isPrimaryMetabolic 
          ? ref.watch(metabolicVentilatoryStateDiagnosisProvider)
          : ref.watch(ventilatoryStateDiagnosisProvider);

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
                  decoration:
                      BoxDecoration(color: AppColors.blue.withOpacity(0.3)),
                  children: const <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
              ...<List<String>>[
                <String>[
                  "Measured PCO2",
                  measuredPCO2,
                  pco2Status,
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
              ])),
            ],
          ),
        ),
      );
    }
  }
}
