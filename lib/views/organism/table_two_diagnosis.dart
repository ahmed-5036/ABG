// lib/views/organism/table_two_diagnosis.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/index.dart';
import '../../resources/constants/app_colors.dart';
import '../../services/enum.dart';

class TableTwoDiagnosis extends ConsumerWidget {
  const TableTwoDiagnosis({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final metabolicDetails = ref.watch(metabolicDetailsProvider);
    final result = ref.watch(calculatorResultProvider);

    return SizedBox(
      width: size.width * 0.95,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(3),
        },
        border: TableBorder.all(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(5),
          width: 2,
        ),
        children: [
          _buildHeaderRow(),

          // BB mEq/L Row
          _buildDataRow(
            label: 'BB mEq/L',
            value: _formatValue(metabolicDetails['bb'] as double?),
            definition: _getBBDefinition(metabolicDetails['bb'] as double?),
          ),

          // AG mEq/L Row
          _buildDataRow(
            label: 'A-G',
            value: _formatValue(metabolicDetails['ag'] as double?),
            definition: _getAGDefinition(result.agResult.findingLevel),
          ),

          // Corrected AG Row
          _buildDataRow(
            label: 'Corrected A-G Present',
            value: _formatValue(metabolicDetails['correctedAG'] as double?),
            definition: _getCorrectedAGDefinition(result.agResult.findingLevel),
          ),

          // SIG mEq/L Row
          _buildDataRow(
            label: 'SIG mEq/L',
            value: _formatValue(metabolicDetails['sig'] as double?),
            definition: _getSIGDefinition(result.sigResult.findingLevel),
          ),

          // Correlation Row
          _buildCorrelationRow(ref, metabolicDetails),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    return TableRow(
      decoration: BoxDecoration(color: AppColors.blue.withOpacity(0.3)),
      children: const [
        _HeaderCell(text: 'Items'),
        _HeaderCell(text: 'Value'),
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

  TableRow _buildCorrelationRow(WidgetRef ref, Map<String, dynamic> details) {
    final correctedHCO3 = details['correctedHCO3'];
    final measuredHCO3 = details['measuredHCO3'];
    final correlationType = details['correlationType'];

    return TableRow(
      children: [
        const _DataCell(text: 'Correlation\n(Correct-HCO3/HCO3)'),
        _DataCell(
          text: '$correctedHCO3->$measuredHCO3',
        ),
        _DataCell(
          text: '($correlationType)',
        ),
      ],
    );
  }

  String _formatValue(double? value) {
    if (value == null) return 'N/A';
    return value.toStringAsFixed(2);
  }

  String _getBBDefinition(double? bb) {
    if (bb == null) return 'N/A';
    if (bb == 40) return 'Normal';
    if (bb > 40) return 'Metabolic Alkalosis';
    return 'Metabolic Acidosis';
  }

  String _getAGDefinition(AGLevel level) {
    return level.level.$1;
  }

  String _getCorrectedAGDefinition(AGLevel level) {
    return level.level.$1;
  }

  String _getSIGDefinition(SIGLevel level) {
    return level.level.$1;
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
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

// Helper provider for table-specific calculations
final tableTwoDetailsProvider = Provider<Map<String, dynamic>>((ref) {
  final result = ref.watch(calculatorResultProvider);
  final metabolicDetails = ref.watch(metabolicDetailsProvider);

  return {
    'bb': {
      'value': metabolicDetails['bb'],
      'definition': _getBBDefinition(metabolicDetails['bb'] as double?),
    },
    'ag': {
      'value': metabolicDetails['ag'],
      'definition': result.agResult.findingLevel.level.$1,
    },
    'correctedAG': {
      'value': metabolicDetails['correctedAG'],
      'definition': result.agResult.findingLevel.level.$1,
    },
    'sig': {
      'value': metabolicDetails['sig'],
      'definition': result.sigResult.findingLevel.level.$1,
    },
    'correlation': {
      'correctedHCO3': metabolicDetails['correctedHCO3'],
      'measuredHCO3': metabolicDetails['measuredHCO3'],
      'type': metabolicDetails['correlationType'],
    },
  };
});

String _getBBDefinition(double? bb) {
  if (bb == null) return 'N/A';
  if (bb == 40) return 'Normal';
  if (bb > 40) return 'Metabolic Alkalosis';
  return 'Metabolic Acidosis';
}
