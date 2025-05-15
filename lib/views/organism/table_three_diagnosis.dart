// lib/views/organism/table_three_diagnosis.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/abg_result.dart';
import '../../providers/index.dart';
import '../../resources/constants/app_colors.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/enum.dart';

class TableThreeDiagnosis extends ConsumerWidget {
  const TableThreeDiagnosis({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.sizeOf(context);
    final ABGResult result = ref.watch(calculatorResultProvider);
    final double expectedPCO2 = ref.watch(expectedPCO2Provider);
    final FinalResult<PCO2Level> currentPCO2 =
        ref.watch(calculatorResultProvider).pco2Result;

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
          width: 2,
        ),
        children: <TableRow>[
          _buildHeaderRow(),

          // Expected PCO2 Row
          _buildDataRow(
            label: "Expected\nPCO2",
            value: "$expectedPCO2->${currentPCO2.findingNumber}",
            definition: result.respiratoryResult.findingLevel.level.$1,
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(color: AppColors.blue.withOpacity(0.3)),
      children: const <Widget>[
        _HeaderCell(text: StringConstants.items),
        _HeaderCell(text: StringConstants.value),
        _HeaderCell(text: StringConstants.definition),
      ],
    );
  }

  TableRow _buildDataRow({
    required String label,
    required String value,
    required String definition,
  }) {
    return TableRow(
      children: <Widget>[
        _DataCell(text: label),
        _DataCell(text: value),
        _DataCell(text: definition),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String text;

  const _DataCell({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

// Helper provider for table-specific calculations
final Provider<Map<String, dynamic>> tableThreeDetailsProvider =
    Provider<Map<String, dynamic>>((ProviderRef<Map<String, dynamic>> ref) {
  final ABGResult result = ref.watch(calculatorResultProvider);
  final double expectedPCO2 = ref.watch(expectedPCO2Provider);
  final FinalResult<PCO2Level> currentPCO2 =
      ref.watch(calculatorResultProvider).pco2Result;

  return <String, dynamic>{
    'expectedPCO2': expectedPCO2,
    'currentPCO2': currentPCO2.findingNumber,
    'respiratoryResult': result.respiratoryResult,
  };
});
