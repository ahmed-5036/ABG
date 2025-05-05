import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../views/molecules/progress_bar_with_title.dart';
import '../index.dart';

/// Input-related providers to reset
final List<ProviderOrFamily> inputResetProviders = [
  inputStateProvider,
  inputCompleteProvider,
  stepStateProvider,
];

/// Result-related providers to reset
final List<ProviderOrFamily> resultResetProviders = [
  calculatorResultProvider,
  metabolicResultProvider,
  respiratoryResultProvider,
  oxygenationResultProvider,
  finalDiagnosisProvider,
];
