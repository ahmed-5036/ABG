// lib/views/organism/table_four_diagnosis.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/index.dart';
import '../../resources/constants/app_colors.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/enum.dart';

class TableFourDiagnosis extends ConsumerWidget {
  const TableFourDiagnosis({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final oxygenationDetails = ref.watch(oxygenationDetailsProvider);
    final result = ref.watch(calculatorResultProvider);

    return SizedBox(
      width: size.width * 0.95,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        border: TableBorder.all(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(5),
          width: 2,
        ),
        children: [
          _buildHeaderRow(),

          // PAO2 Row
          _buildDataRow(
            label: 'PAO2 mmHg',
            value: _formatValue(oxygenationDetails['pAO2'] as double?),
            definition:
                _getPAO2Definition(oxygenationDetails['pAO2'] as double?),
          ),

          // A-a Row
          _buildDataRow(
            label: 'A-a',
            value: _formatValue(oxygenationDetails['aA'] as double?),
            definition: _getAADefinition(
              oxygenationDetails['aA'] as double?,
              oxygenationDetails['expectedAa'] as double?,
            ),
          ),

          // Expected A-a Row
          _buildDataRow(
            label: 'Expected A-a',
            value: _formatValue(oxygenationDetails['expectedAa'] as double?,
                precision: 2),
            definition:
                _getExpectedAADefinition(result.oxygenResult.findingLevel),
          ),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(color: AppColors.blue.withOpacity(0.3)),
      children: const [
        _HeaderCell(text: StringConstants.items),
        _HeaderCell(text: StringConstants.value),
        _HeaderCell(text: 'Definition'),
      ],
    );
  }

  TableRow _buildDataRow({
    required String label,
    required String value,
    required String definition,
  }) {
    return TableRow(
      children: [
        _DataCell(text: label),
        _DataCell(text: value),
        _DataCell(text: definition),
      ],
    );
  }

  String _formatValue(double? value, {int precision = 0}) {
    if (value == null) return 'N/A';
    if (precision == 0) return value.round().toString();
    return value.toStringAsFixed(precision);
  }

  String _getPAO2Definition(double? pao2) {
    if (pao2 == null) return '---';
    if (pao2 > 100) return 'High';
    if (pao2 < 60) return 'Low';
    return 'Normal';
  }

  String _getAADefinition(double? aa, double? expectedAa) {
    if (aa == null || expectedAa == null) return '---';
    if (aa > (expectedAa + 5)) return 'Elevated';
    if (aa < expectedAa) return 'Normal';
    return 'Borderline';
  }

  String _getExpectedAADefinition(OxygenWaterLevel level) {
    switch (level) {
      case OxygenWaterLevel.normoxia:
        return 'Normal oxygenation';
      case OxygenWaterLevel.hypoxemia:
        return 'Hypoxemia present';
      case OxygenWaterLevel.unknown:
        return '---';
      default:
        return '---';
    }
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
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

// Helper provider for oxygenation-specific calculations
final tableFourDetailsProvider = Provider<Map<String, dynamic>>((ref) {
  final details = ref.watch(oxygenationDetailsProvider);
  final result = ref.watch(calculatorResultProvider);

  return {
    'pao2Details': {
      'value': details['pAO2'],
      'definition': _getPAO2Definition(details['pAO2'] as double?),
    },
    'aaDetails': {
      'value': details['aA'],
      'definition': _getAADefinition(
          details['aA'] as double?, details['expectedAa'] as double?),
    },
    'expectedAaDetails': {
      'value': details['expectedAa'],
      'definition': _getExpectedAADefinition(result.oxygenResult.findingLevel),
    },
  };
});

// Helper functions for the provider
String _getPAO2Definition(double? pao2) {
  if (pao2 == null) return '---';
  if (pao2 > 100) return 'High';
  if (pao2 < 60) return 'Low';
  return 'Normal';
}

String _getAADefinition(double? aa, double? expectedAa) {
  if (aa == null || expectedAa == null) return '---';
  if (aa > (expectedAa + 5)) return 'Elevated';
  if (aa < expectedAa) return 'Normal';
  return 'Borderline';
}

String _getExpectedAADefinition(OxygenWaterLevel level) {
  switch (level) {
    case OxygenWaterLevel.normoxia:
      return 'Normal oxygenation';
    case OxygenWaterLevel.hypoxemia:
      return 'Hypoxemia present';
    case OxygenWaterLevel.unknown:
    default:
      return '---';
  }
}
