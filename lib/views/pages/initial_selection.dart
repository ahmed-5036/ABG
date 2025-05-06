import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/constants/route_names.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/enum.dart';
import '../../services/extension.dart';
import '../../services/calculators/calculator_factory.dart';
import '../atoms/primary_button.dart';
import '../organism/adaptive_input_dialog.dart';

// Enum for initial options
enum InitialOption { 
  abgAdmission, 
  followUpAbg, 
  copd 
}

// Provider for tracking the selected initial option
final initialOptionProvider = StateProvider<InitialOption?>((ref) => null);

class InitialSelectionView extends ConsumerWidget {
  const InitialSelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 140,
        title: SizedBox(
          height: 100,
          child: Image.asset(
            AppImages.appLogo,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModeButton(
              context, 
              ref, 
              'ABG Admission', 
              InitialOption.abgAdmission,
              RouteNames.patientTypeSelection,
              [
                CalculatorType.admissionABGNormal,
                CalculatorType.admissionABGHigh
              ]
            ),
            _buildModeButton(
              context, 
              ref, 
              'Follow Up ABG', 
              InitialOption.followUpAbg,
              RouteNames.followUpAbgOptions,
              [
                CalculatorType.followUpABGMetabolic,
                CalculatorType.followUpABGRespiratory
              ]
            ),
            _buildModeButton(
              context, 
              ref, 
              'COPD Patients', 
              InitialOption.copd,
              RouteNames.copdOptions,
              [
                CalculatorType.copdCalculationNormal,
                CalculatorType.copdCalculationHigh
              ]
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context, 
    WidgetRef ref, 
    String label, 
    InitialOption initialOption,
    String route,
    List<CalculatorType> calculatorTypes
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: BorderedButton(
        label: label,
        color: AppColors.blue,
        action: () {
          // Set the initial option
          ref.read(initialOptionProvider.notifier).state = initialOption;
          
          // Navigate to the route with calculator type options
          Navigator.of(context).pushNamed(route, arguments: calculatorTypes);
        },
      ),
    );
  }
}