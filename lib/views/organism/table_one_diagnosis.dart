import '../../resources/constants/string_constants.dart';
import '../../services/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/input_calculator_provider.dart';
import '../../providers/result_calculator_providers.dart';
import '../../resources/constants/app_colors.dart';
import '../pages/patient_type_selection.dart';

class TableOneDiagnosis extends ConsumerWidget {
  const TableOneDiagnosis({super.key});

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

          ///[Type 2 patient]
          //Corrected CL
          TableRow(
              children:
                  //if patient is type one => hide corrected CL
                  ref.watch(patientTypeProvider) == PatientType.patientTypeOne
                      ? <Widget>[
                          //if patient is type one => hide corrected CL(by showing 3 empty sized boxes)
                          const SizedBox.shrink(),
                          const SizedBox.shrink(),
                          const SizedBox.shrink()
                        ]
                      : <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              StringConstants.correctedCl,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "${ref.watch(correctedCLProvider)}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              ref.read(correctedCLProviderResult).level.$1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ]),

          //TODO: First CL/NA
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                StringConstants.clNa,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${ref.watch(clNaCalculationProvider)}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.read(clNaResultProvider).level.$1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ]),

          //TODO: Second CL/NA
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                StringConstants.sid,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${ref.watch(sidGeneralProvider)}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.read(sidResultProvider).level.$1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ]),
//TODO: Third Corrected HCO3
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                StringConstants.correctedHCO3,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${ref.watch(correctedHCO3Provider)}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                ref.watch(correctedHCO3ResultProvider).level.$1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ]),
          //TODO: Fourth Corrected AG start
          TableRow(children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                StringConstants.correctedAgStart,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${ref.watch(correctedAGStartProvider)}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
