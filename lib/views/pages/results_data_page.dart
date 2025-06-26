// lib/views/pages/results_data_page.dart
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../providers/index.dart';
import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_constants.dart';
import '../../resources/constants/route_names.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/calculators/calculator_factory.dart';
import '../../services/enum.dart';
import '../../services/extension.dart';
import '../atoms/primary_button.dart';
import '../molecules/progress_bar_with_title.dart';
import '../../providers/reset/reset_providers.dart';
import '../organism/diagnosis_result_table.dart';
import '../organism/app_drawer.dart';
import '../organism/present_metabolic_change_table.dart';
import '../organism/start_metabolic_state_table.dart';
import '../organism/ventilatory_state_table.dart';
import '../organism/oxygenation_state_table.dart';

class ResultsDataPage extends ConsumerWidget {
  const ResultsDataPage({super.key});

  bool _isCopdCalculator(CalculatorType? type) {
    return type == CalculatorType.copdCalculationNormal ||
        type == CalculatorType.copdCalculationHigh;
  }

  bool _isFollowUpABGCalculator(CalculatorType? type) {
    return type == CalculatorType.followUpABGMetabolic ||
        type == CalculatorType.followUpABGRespiratory;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CalculatorType calculatorType = ref.watch(calculatorTypeProvider);
    final bool isCopdCalculator = _isCopdCalculator(calculatorType);
    final bool isFollowUpABGCalculator =
        _isFollowUpABGCalculator(calculatorType);

    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(stepStateProvider);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(StringConstants.resutls),
        ),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: kDefaultPagePadding,
            child: Column(
              children: <Widget>[
                ProgressBarWithTitle(step: ref.watch(stepStateProvider)),
                if (isCopdCalculator)
                  _buildCopdResults(context, ref, calculatorType)
                else if (isFollowUpABGCalculator)
                  _buildFollowUpABGResults(context, ref, calculatorType)
                else ...[
                  // Start Metabolic State
                  BorderedButton(
                    label: 'Start Metabolic State',
                    color: AppColors.blue,
                    verticalPadding: 8,
                    action: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ref.watch(diagnosisOneResultProvider),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const StartMetabolicStateTable(),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[900],
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Close'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Present Metabolic Change
                  BorderedButton(
                    label: 'Present Metabolic Change',
                    color: AppColors.blue,
                    verticalPadding: 8,
                    action: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ref.watch(diagnosisSecondResultProvider),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const PresentMetabolicChangeTable(),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[900],
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Close'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Ventilatory State
                  BorderedButton(
                    label: 'Ventilatory State',
                    color: AppColors.blue,
                    verticalPadding: 8,
                    action: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ref.watch(diagnosisThirdResultProvider),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const VentilatoryStateTable(),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[900],
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Close'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Oxygenation State
                  BorderedButton(
                    label: 'Oxygenation State',
                    color: AppColors.blue,
                    verticalPadding: 8,
                    action: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ref
                                      .watch(diagnosisFourthResultProvider)
                                      .level
                                      .$1,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const OxygenationStateTable(),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[900],
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Close'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24 * 2),
                  // Final Diagnosis
                  BorderedButton(
                    label: StringConstants.finalDiagnosis,
                    color: AppColors.blue,
                    verticalPadding: 24,
                    customHeight: 20,
                    width: 0.75,
                    action: () async {
                      Alert(
                        context: context,
                        type: AlertType.none,
                        title: StringConstants.finalDiagnosis,
                        desc: "",
                        content: Text(
                          ref.watch(finalDiagnosisResultProvider),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        buttons: <DialogButton>[
                          DialogButton(
                            onPressed: () => context.navigator.pop(),
                            // width: 120,
                            color: AppColors.deepRed,

                            child: const Text(
                              StringConstants.close,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ],
                      ).show();
                    },
                  ),
                  const SizedBox(height: 24),
                  // New Patient
                  BorderedButton(
                    label: StringConstants.newPatient,
                    color: AppColors.appbarBackground,
                    verticalPadding: 24,
                    customHeight: 20,
                    width: 0.75,
                    action: () async {
                      final String? choice = await showModalActionSheet<String>(
                        context: context,
                        title: StringConstants.newPatient,
                        message: StringConstants.startAnalysisForNewPatient,
                        actions: <SheetAction<String>>[
                          const SheetAction<String>(
                            label: StringConstants.newPatient,
                            key: RouteNames.patientTypeSelection,
                          ),
                          const SheetAction<String>(
                            label: StringConstants.goBack,
                            key: null,
                          ),
                        ].nonNulls.toList(),
                      );

                      if (!context.mounted) return;
                      if (choice == null) {
                        if (context.navigator.canPop()) {
                          context.navigator.pop();
                        }
                        return;
                      }

                      // Reset all used providers
                      for (final ProviderOrFamily provider
                          in <ProviderOrFamily>[
                        ...inputResetProviders,
                        ...resultResetProviders,
                      ]) {
                        ref.invalidate(provider);
                      }

                      context.navigator.pushNamedAndRemoveUntil(
                        choice,
                        (Route route) => false,
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCopdResults(
      BuildContext context, WidgetRef ref, CalculatorType calculatorType) {
    // Use the COPD calculation provider directly
    final Map<String, dynamic> copdResults =
        ref.watch(copdCalculationResultProvider);

    // Get input values for display
    final Map<String, double> inputValues =
        ref.watch(inputStateProvider).values;
    final double sodium = inputValues['sodium'] ?? 0.0;
    final double chlorine = inputValues['chlorine'] ?? 0.0;
    final double hco3 = inputValues['hco3'] ?? 0.0;
    final double albumin = inputValues['albumin'] ?? 0.0;
    final double pco2 = inputValues['pco2'] ?? 0.0;

    // Determine if we're using normal or high COPD calculation
    final bool isNormalCopd =
        calculatorType == CalculatorType.copdCalculationNormal;

    return Column(
      children: <Widget>[
        // Title for the COPD Results
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            isNormalCopd ? "COPD Normal Calculation" : "COPD High Calculation",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),

        // Display input values for reference
        Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Input Values",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInputRow(context, "Sodium (Na)",
                    "${sodium.toStringAsFixed(1)} mEq/L"),
                _buildInputRow(context, "Chlorine (Cl)",
                    "${chlorine.toStringAsFixed(1)} mEq/L"),
                _buildInputRow(context, "Bicarbonate (HCO3)",
                    "${hco3.toStringAsFixed(1)} mEq/L"),
                _buildInputRow(
                    context, "Albumin", "${albumin.toStringAsFixed(1)} g%"),
                _buildInputRow(
                    context, "PCO2", "${pco2.toStringAsFixed(1)} mmHg"),
              ],
            ),
          ),
        ),

        // Display calculated values
        const SizedBox(height: 16),
        Text(
          "Calculated Values",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),

        // Display COPD specific results
        _buildResultCard(
          context,
          label: isNormalCopd ? "Corrected AG" : "Measured SID",
          value: isNormalCopd
              ? (copdResults['correctedAG']?.toStringAsFixed(1) ?? "N/A")
                  .toString()
              : (copdResults['measuredSID']?.toStringAsFixed(1) ?? "N/A")
                  .toString(),
          units: "mEq/L",
        ),

        _buildResultCard(
          context,
          label: "Expected HCO3",
          value: (copdResults['expectedHCO3']?.toStringAsFixed(1) ?? "N/A")
              .toString(),
          units: "mEq/L",
        ),

        _buildResultCard(
          context,
          label: "Expected PCO2",
          value: (copdResults['expectedPCO2']?.toStringAsFixed(1) ?? "N/A")
              .toString(),
          units: "mmHg",
        ),

        _buildResultCard(
          context,
          label: "Expected pH",
          value: (copdResults['expectedPH']?.toStringAsFixed(2) ?? "N/A")
              .toString(),
          units: "",
        ),
      ],
    );
  }

// Helper method for input rows
  Widget _buildInputRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(
    BuildContext context, {
    required String label,
    required String value,
    required String units,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value + (units.isNotEmpty ? " $units" : ""),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMetabolicDialogTitle(
      MetabolicLevel level, Map<String, dynamic> details) {
    if (details['title'] != null) return details['title'].toString();
    switch (level) {
      case MetabolicLevel.metabolicAcidosis:
        return "Metabolic Acidosis";
      case MetabolicLevel.metabolicAlkalosis:
        return "Metabolic Alkalosis";
      default:
        return "Metabolic State";
    }
  }

  Widget _buildFollowUpABGResults(
      BuildContext context, WidgetRef ref, CalculatorType calculatorType) {
    final bool isPrimaryMetabolic =
        calculatorType == CalculatorType.followUpABGMetabolic;

    return Column(
      children: <Widget>[
        // Title for the Follow-up ABG Results
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            isPrimaryMetabolic
                ? "Follow-up ABG\nPrimary Metabolic Insult"
                : "Follow-up ABG\nPrimary Respiratory Insult",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),

        // Present Metabolic Change (First Button for Primary Metabolic)
        BorderedButton(
          label: 'Present Metabolic Change',
          color: AppColors.blue,
          verticalPadding: 8,
          action: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ref.watch(diagnosisSecondResultProvider),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const PresentMetabolicChangeTable(),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[900],
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // Ventilatory State (Second Button)
        BorderedButton(
          label: 'Ventilatory State',
          color: AppColors.blue,
          verticalPadding: 8,
          action: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ref.watch(diagnosisThirdResultProvider),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const VentilatoryStateTable(),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[900],
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // Oxygenation State (Third Button)
        BorderedButton(
          label: 'Oxygenation State',
          color: AppColors.blue,
          verticalPadding: 8,
          action: () {
            showDialog(
              context: context,
              builder: (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ref.watch(diagnosisFourthResultProvider).level.$1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const OxygenationStateTable(),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[900],
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24 * 2),

        // Final Diagnosis
        BorderedButton(
          label: StringConstants.finalDiagnosis,
          color: AppColors.blue,
          verticalPadding: 24,
          customHeight: 20,
          width: 0.75,
          action: () async {
            Alert(
              context: context,
              type: AlertType.none,
              title: StringConstants.finalDiagnosis,
              desc: "",
              content: Text(
                ref.watch(followUpABGFinalDiagnosisResultProvider),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              buttons: <DialogButton>[
                DialogButton(
                  onPressed: () => context.navigator.pop(),
                  color: AppColors.deepRed,
                  child: const Text(
                    StringConstants.close,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            ).show();
          },
        ),
        const SizedBox(height: 24),

        // New Patient
        BorderedButton(
          label: StringConstants.newPatient,
          color: AppColors.appbarBackground,
          verticalPadding: 24,
          customHeight: 20,
          width: 0.75,
          action: () async {
            final String? choice = await showModalActionSheet<String>(
              context: context,
              title: StringConstants.newPatient,
              message: StringConstants.startAnalysisForNewPatient,
              actions: <SheetAction<String>>[
                const SheetAction<String>(
                  label: StringConstants.newPatient,
                  key: RouteNames.patientTypeSelection,
                ),
                const SheetAction<String>(
                  label: StringConstants.goBack,
                  key: null,
                ),
              ].nonNulls.toList(),
            );

            if (!context.mounted) return;
            if (choice == null) {
              if (context.navigator.canPop()) {
                context.navigator.pop();
              }
              return;
            }

            // Reset all used providers
            for (final ProviderOrFamily provider in <ProviderOrFamily>[
              ...inputResetProviders,
              ...resultResetProviders,
            ]) {
              ref.invalidate(provider);
            }

            context.navigator.pushNamedAndRemoveUntil(
              choice,
              (Route route) => false,
            );
          },
        ),
      ],
    );
  }
}

class MetabolicStateDialog extends StatelessWidget {
  final List<Map<String, String>> items;

  const MetabolicStateDialog({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Low AG,\nHyperchloremic,\nMetabolic Acidosis',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 20),
            Table(
              border: TableBorder.all(
                color: Colors.blueGrey.shade400,
                width: 1.5,
                borderRadius: BorderRadius.circular(6),
              ),
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(4),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.15),
                  ),
                  children: [
                    _tableHeader('Items'),
                    _tableHeader('Value'),
                    _tableHeader('Definition'),
                  ],
                ),
                ...items.map((row) => TableRow(
                      children: [
                        _tableCell(row['label'] ?? ''),
                        _tableCell(row['value'] ?? ''),
                        _tableCell(row['definition'] ?? ''),
                      ],
                    )),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget _tableCell(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
        ),
      );
}
