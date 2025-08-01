import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/index.dart';
import '../../resources/constants/app_colors.dart';
import '../../services/calculators/calculator_factory.dart';
import '../../services/enum.dart';

class PresentMetabolicChangeTable extends ConsumerWidget {
  const PresentMetabolicChangeTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final values = ref.watch(inputStateProvider).values;
    final double hco3 = values['hco3'] ?? 0;
    final double pco2 = values['pco2'] ?? 0;
    final double sodium = values['sodium'] ?? 0;
    final double chlorine = values['chlorine'] ?? 0;
    final double albumin = values['albumin'] ?? 0;
    final CalculatorType calculatorType = ref.watch(calculatorTypeProvider);
    final bool isPrimaryMetabolic =
        calculatorType == CalculatorType.followUpABGMetabolic;

    if (isPrimaryMetabolic) {
      // Primary Metabolic Insult Logic
      // 1. Measured HCO3
      final String measuredHCO3 = hco3.toStringAsFixed(2);
      String hco3Status = '';
      if (hco3 == 24) {
        hco3Status = 'Normal Metabolic (=24)';
      } else if (hco3 < 24) {
        hco3Status = 'Metabolic Acidosis (<24)';
      } else {
        hco3Status = 'Metabolic Alkalosis (>24)';
      }

      // 2. CL
      String clStatus = '';
      if (chlorine > 107) {
        clStatus = 'Hyperchloremic (>107)';
      } else if (chlorine < 97) {
        clStatus = 'Hypochloremic (<97)';
      } else {
        clStatus = 'Normo-chloremic (97-107)';
      }

      // 3. Corrected AG
      double correctedAG = (sodium - chlorine - hco3) + ((4 - albumin) * 2.5);
      String agStatus = '';
      if (correctedAG > 12) {
        agStatus = 'High AG (>12)';
      } else if (correctedAG < 12) {
        agStatus = 'Low AG (<12)';
      } else {
        agStatus = 'Normal AG (=12)';
      }

      return SingleChildScrollView(
        child: SizedBox(
          width: size.width * 0.99,
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
              ...[
                [
                  "Measured HCO3",
                  measuredHCO3,
                  hco3Status,
                ],
                [
                  "CL",
                  chlorine.toStringAsFixed(2),
                  clStatus,
                ],
                [
                  "Corrected AG",
                  correctedAG.toStringAsFixed(2),
                  agStatus,
                ],
              ]
                  .map((row) => TableRow(children: [
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
                      ]))
                  .toList(),
            ],
          ),
        ),
      );
    } else {
      // Primary Respiratory Insult Logic (existing code)
      // 1. Measured HCO3
      final String measuredHCO3 = hco3.toStringAsFixed(2);

      // 2. Expected HCO3
      double expectedHCO3 =
          pco2 < 40 ? 24 - ((40 - pco2) * 0.1) : 24 - ((40 - pco2) * 0.2);
      final String expectedHCO3Str = expectedHCO3.toStringAsFixed(2);
      final String expectedHCO3Formula = pco2 < 40
          ? 'Expected HCO3 = 24 - [(40 - PCO2) x 0.1]'
          : 'Expected HCO3 = 24 - [(40 - PCO2) x 0.2]';

      // 3. Expected to Measured HCO3 (compensation logic)
      String compensation = '';
      if (expectedHCO3 == hco3) {
        if (hco3 == 24) {
          compensation = 'Expected = Measured = 24: Normal compensation';
        } else if (hco3 > 24) {
          compensation =
              'Expected = Measured > 24: Compensatory metabolic alkalosis';
        } else {
          compensation =
              'Expected = Measured < 24: Compensatory metabolic acidosis';
        }
      } else if (expectedHCO3 > hco3) {
        compensation =
            'Expected > Measured: Non-compensatory metabolic acidosis';
      } else {
        compensation =
            'Expected < Measured: Non-compensatory metabolic alkalosis';
      }

      // 4. Measured Chloride
      String clStatus = '';
      if (chlorine > 107) {
        clStatus = 'Hyperchloremia (>107)';
      } else if (chlorine < 97) {
        clStatus = 'Hypochloremia (<97)';
      } else {
        clStatus = 'Normochloremia (97-107)';
      }

      // 5. Corrected AG
      double correctedAG = (sodium - chlorine - hco3) + ((4 - albumin) * 2.5);
      String agStatus = '';
      if (correctedAG > 12) {
        agStatus = 'High AG (>12)';
      } else if (correctedAG < 12) {
        agStatus = 'Low AG (<12)';
      } else {
        agStatus = 'Normal AG (=12)';
      }
      final String agFormula =
          '(Na - Cl - measured HCO3) + [(4 - albumin) x 2.5]';

      // Diagnosis 1 (present metabolic change)
      final String diagnosis = ref.watch(diagnosisSecondResultProvider);

      return SingleChildScrollView(
        child: SizedBox(
          width: size.width * 0.99,
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
              ...[
                [
                  "Measured HCO3",
                  measuredHCO3,
                  "-",
                ],
                [
                  "Expected HCO3",
                  expectedHCO3Str,
                  "-",
                ],
                [
                  "Expected vs Measured HCO3",
                  "${expectedHCO3.toStringAsFixed(1)}/${hco3.toStringAsFixed(1)}",
                  compensation,
                ],
                [
                  "Measured Chloride",
                  chlorine.toStringAsFixed(2),
                  clStatus,
                ],
                [
                  "Corrected AG",
                  correctedAG.toStringAsFixed(2),
                  agStatus,
                ],
              ]
                  .map((row) => TableRow(children: [
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
                      ]))
                  .toList(),
            ],
          ),
        ),
      );
    }
  }
}
