import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../resources/constants/app_colors.dart';
import '../../resources/constants/app_images.dart';
import '../../resources/constants/route_names.dart';
import '../../resources/constants/string_constants.dart';
import '../../services/enum.dart';
import '../../services/extension.dart';
import '../atoms/primary_button.dart';
import '../organism/adaptive_input_dialog.dart';

// Enum for initial options
enum InitialOption { abgAdmission, followUpAbg, copd }

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
            _buildOptionButton(context, ref, 'ABG Admission',
                InitialOption.abgAdmission, RouteNames.patientTypeSelection),
            _buildOptionButton(context, ref, 'Follow Up ABG',
                InitialOption.followUpAbg, RouteNames.followUpAbgOptions),
            _buildOptionButton(context, ref, 'COPD', InitialOption.copd,
                RouteNames.copdOptions),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, WidgetRef ref, String label,
      InitialOption option, String routeName) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BorderedButton(
        customWidgetLabel: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.deepRed2,
            fontSize: 18,
          ),
        ),
        color: AppColors.blue,
        verticalPadding: 8,
        customHeight: 100,
        action: () {
          // Update the selected option
          ref.read(initialOptionProvider.notifier).state = option;

          // Navigate to the selected route
          context.navigator.pushNamed(routeName);
        },
      ),
    );
  }
}
