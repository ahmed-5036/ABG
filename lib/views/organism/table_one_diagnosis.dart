// lib/views/organism/table_one_diagnosis.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/index.dart';
import '../../resources/constants/app_colors.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/enum.dart';
import '../pages/patient_type_selection.dart';

class TableOneDiagnosis extends ConsumerWidget {
  const TableOneDiagnosis({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final result = ref.watch(calculatorResultProvider);
    final metabolicDetails = ref.watch(metabolicDetailsProvider);
    final patientType = ref.watch(patientTypeProvider);

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

          // Corrected CL Row (Only for Type 2 patients)
          if (patientType == PatientType.patientTypeTwo)
            _buildDataRow(
              label: StringConstants.correctedCl,
              value: result.chlorineResult.findingNumber?.toString() ?? 'N/A',
              definition: result.chlorineResult.findingLevel.level.$1,
            ),

          // CL/NA Row
          _buildDataRow(
            label: StringConstants.clNa,
            value: metabolicDetails['clNa']?.toString() ?? 'N/A',
            definition: _getClNaDefinition(result.clNaResult.findingLevel),
          ),

          // SID Row
          _buildDataRow(
            label: StringConstants.sid,
            value: metabolicDetails['sid']?.toString() ?? 'N/A',
            definition: _getSIDDefinition(result.metabolicResult.findingLevel),
          ),

          // Corrected HCO3 Row
          _buildDataRow(
            label: StringConstants.correctedHCO3,
            value: metabolicDetails['correctedHCO3']?.toString() ?? 'N/A',
            definition: result.metabolicResult.findingLevel.level.$1,
          ),

          // Corrected AG Row
          _buildDataRow(
            label: StringConstants.correctedAgStart,
            value: metabolicDetails['correctedAG']?.toString() ?? 'N/A',
            definition: result.agResult.findingLevel.level.$1,
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
      children: [
        _DataCell(text: label),
        _DataCell(text: value),
        _DataCell(text: definition),
      ],
    );
  }

  String _getClNaDefinition(CLNaLevel level) {
    switch (level) {
      case CLNaLevel.normalOrHemo:
        return 'Normal or Hemodilution';
      case CLNaLevel.hyperTwoCases:
        return 'Hyperchloremic or Hyponatremic';
      case CLNaLevel.hypoTwoCases:
        return 'Hypochloremic or Hypernatremic';
      case CLNaLevel.na:
        return 'N/A';
      default:
        return level.level.$1;
    }
  }

  String _getSIDDefinition(MetabolicLevel level) {
    switch (level) {
      case MetabolicLevel.normal:
        return 'Normal metabolic state';
      case MetabolicLevel.metabolicAcidosis:
        return 'Metabolic acidosis';
      case MetabolicLevel.metabolicAlkalosis:
        return 'Metabolic alkalosis';
      case MetabolicLevel.unknown:
        return 'N/A';
      default:
        return level.level.$1;
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
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

// Helper providers for table-specific calculations
final tableOneDetailsProvider = Provider<Map<String, dynamic>>((ref) {
  final result = ref.watch(calculatorResultProvider);
  final metabolicDetails = ref.watch(metabolicDetailsProvider);

  return {
    'clNa': metabolicDetails['clNa'],
    'sid': metabolicDetails['sid'],
    'correctedHCO3': metabolicDetails['correctedHCO3'],
    'correctedAG': metabolicDetails['correctedAG'],
    'chlorineResult': result.chlorineResult,
    'metabolicResult': result.metabolicResult,
    'agResult': result.agResult,
  };
});
