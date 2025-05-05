// lib/services/calculations/base_calculator.dart
import '../../models/abg_result.dart';
import '../enum.dart';

abstract class ABGCalculator {
  FinalResult<MetabolicLevel> calculateMetabolicState({
    required double sodium,
    required double chlorine,
    required double hco3,
    required double albumin,
  });

  FinalResult<RespiratoryLevel> calculateRespiratoryState({
    required double pco2,
    required double hco3,
    required double ph,
  });

  FinalResult<OxygenWaterLevel> calculateOxygenationState({
    required double fio2,
    required double pco2,
    required double pao2,
    required double age,
  });

  String getFinalDiagnosis({
    required String metabolicDiagnosis,
    required String respiratoryDiagnosis,
    required String oxygenationDiagnosis,
  });
}
