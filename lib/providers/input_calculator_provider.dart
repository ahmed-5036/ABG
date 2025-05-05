// // lib/providers/input_calculator_provider.dart
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../models/abg_result.dart';
// import '../services/calculators/calculator_factory.dart';
// import '../services/calculators/calculator_types.dart';
// import '../resources/constants/calculation_constants.dart';
// import '../services/enum.dart';
//
// // Calculator type provider
// final calculatorTypeProvider = StateProvider<CalculatorType>((ref) {
//   return CalculatorType.followUpABG; // default type
// });
//
// // Main ABG Result provider
// final abgResultProvider =
//     StateNotifierProvider<ABGResultNotifier, ABGResult>((ref) {
//   return ABGResultNotifier();
// });
//
// class ABGResultNotifier extends StateNotifier<ABGResult> {
//   ABGResultNotifier() : super(ABGResult.initial());
//
//   void updatePotassium(double? value) {
//     state = state.copyWith(
//       potassiumResult: _getPotassiumResult(value),
//     );
//   }
//
//   void updateSodium(double? value) {
//     state = state.copyWith(
//       sodiumResult: _getSodiumResult(value),
//     );
//   }
//
//   // Add other update methods...
//
//   FinalResult<PotassiumLevel> _getPotassiumResult(double? number) {
//     if (number == null || number == 0) {
//       return FinalResult(findingLevel: PotassiumLevel.na, findingNumber: 0);
//     }
//
//     if (number == CalculationConstants.normokalemiaThreshold) {
//       return FinalResult(
//           findingLevel: PotassiumLevel.normokalemia, findingNumber: number);
//     }
//
//     if (number > CalculationConstants.hyperkalemiaThreshold) {
//       return FinalResult(
//           findingLevel: PotassiumLevel.hyperkalemia, findingNumber: number);
//     }
//
//     if (number < CalculationConstants.normokalemiaThreshold) {
//       return FinalResult(
//           findingLevel: PotassiumLevel.hypokalemia, findingNumber: number);
//     }
//
//     return FinalResult(
//         findingLevel: PotassiumLevel.normokalemia, findingNumber: number);
//   }
//
//   FinalResult<SodiumLevel> _getSodiumResult(double? number) {
//     // Similar implementation...
//   }
// }
//
// // Navigation provider
// final navigateToResultProvider = Provider<bool>((ref) {
//   final result = ref.watch(abgResultProvider);
//   return result.isComplete;
// });
//
// // Individual value providers
// final potassiumValueProvider = Provider<double?>((ref) {
//   return ref.watch(abgResultProvider).potassiumResult.findingNumber;
// });
//
// final sodiumValueProvider = Provider<double?>((ref) {
//   return ref.watch(abgResultProvider).sodiumResult.findingNumber;
// });
//
// // Add other value providers...
//
// // Simple state providers for additional values
// final fiO2Provider = StateProvider<double?>((ref) => 0);
// final agesProvider = StateProvider<double?>((ref) => 0);
// final paInputO2Provider = StateProvider<double?>((ref) => 0);
//
// // Calculated values providers
// final correctedCLProvider = Provider<double?>((ref) {
//   final result = ref.watch(abgResultProvider);
//   final hco3Val = result.metabolicResult.findingNumber ?? 0;
//   final clVal = result.chlorineResult.findingNumber ?? 0;
//
//   // Your calculation logic here...
//   return (hco3Val - (ref.watch(correctedHCO3Provider) ?? 0)) + clVal;
// });
//
// // Helper providers for complex calculations
// final correctedHCO3Provider = Provider<double?>((ref) {
//   final result = ref.watch(abgResultProvider);
//   // Your calculation logic here...
//   return null; // Replace with actual calculation
// });
//
// // Extension methods for easier access to result values
// extension ABGResultExtension on ABGResult {
//   bool get canNavigateToResult {
//     return potassiumResult.findingLevel != PotassiumLevel.na &&
//         sodiumResult.findingLevel != SodiumLevel.na &&
//         chlorineResult.findingLevel != ChlorineLevel.na &&
//         metabolicResult.findingLevel != MetabolicLevel.na &&
//         phResult.findingLevel != PhLevel.na &&
//         pco2Result.findingLevel != PCO2Level.na;
//   }
// }
//
// // Export specific result types for UI consumption
// final metabolicStateProvider = Provider<MetabolicLevel>((ref) {
//   return ref.watch(abgResultProvider).metabolicResult.findingLevel;
// });
//
// final respiratoryStateProvider = Provider<RespiratoryLevel>((ref) {
//   return ref.watch(abgResultProvider).respiratoryResult.findingLevel;
// });
//
// // Add other state providers as needed...
