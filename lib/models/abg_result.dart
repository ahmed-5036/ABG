// lib/models/abg_result.dart
import 'package:flutter/material.dart';
import '../services/enum.dart';

@immutable
class FinalResult<T> {
  final T findingLevel;
  final double? findingNumber;

  const FinalResult({required this.findingLevel, required this.findingNumber});

  @override
  String toString() =>
      'FinalResult{findingLevel: $findingLevel, findingNumber: $findingNumber}';

  // Add copyWith method for immutability
  FinalResult<T> copyWith({
    T? findingLevel,
    double? findingNumber,
  }) {
    return FinalResult<T>(
      findingLevel: findingLevel ?? this.findingLevel,
      findingNumber: findingNumber ?? this.findingNumber,
    );
  }

  // Add equality operators
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FinalResult<T> &&
        other.findingLevel == findingLevel &&
        other.findingNumber == findingNumber;
  }

  @override
  int get hashCode => findingLevel.hashCode ^ findingNumber.hashCode;
}

@immutable
class ABGResult {
  final FinalResult<PotassiumLevel> potassiumResult;
  final FinalResult<SodiumLevel> sodiumResult;
  final FinalResult<AlbuminLevel> albuminResult;
  final FinalResult<ChlorineLevel> chlorineResult;
  final FinalResult<MetabolicLevel> metabolicResult;
  final FinalResult<PhLevel> phResult;
  final FinalResult<PCO2Level> pco2Result;
  final FinalResult<CLNaLevel> clNaResult;
  final FinalResult<AGLevel> agResult;
  final FinalResult<SIGLevel> sigResult;
  final FinalResult<RespiratoryLevel> respiratoryResult;
  final FinalResult<OxygenWaterLevel> oxygenResult;

  const ABGResult({
    required this.potassiumResult,
    required this.sodiumResult,
    required this.albuminResult,
    required this.chlorineResult,
    required this.metabolicResult,
    required this.phResult,
    required this.pco2Result,
    required this.clNaResult,
    required this.agResult,
    required this.sigResult,
    required this.respiratoryResult,
    required this.oxygenResult,
  });

  // Add factory constructor for creating empty/initial state
  factory ABGResult.initial() => ABGResult(
        potassiumResult:
            FinalResult(findingLevel: PotassiumLevel.na, findingNumber: 0),
        sodiumResult:
            FinalResult(findingLevel: SodiumLevel.na, findingNumber: 0),
        albuminResult:
            FinalResult(findingLevel: AlbuminLevel.na, findingNumber: 0),
        chlorineResult:
            FinalResult(findingLevel: ChlorineLevel.na, findingNumber: 0),
        metabolicResult:
            FinalResult(findingLevel: MetabolicLevel.na, findingNumber: 0),
        phResult: FinalResult(findingLevel: PhLevel.na, findingNumber: 0),
        pco2Result: FinalResult(findingLevel: PCO2Level.na, findingNumber: 0),
        clNaResult: FinalResult(findingLevel: CLNaLevel.na, findingNumber: 0),
        agResult: FinalResult(findingLevel: AGLevel.na, findingNumber: 0),
        sigResult: FinalResult(findingLevel: SIGLevel.na, findingNumber: 0),
        respiratoryResult:
            FinalResult(findingLevel: RespiratoryLevel.na, findingNumber: 0),
        oxygenResult:
            FinalResult(findingLevel: OxygenWaterLevel.na, findingNumber: 0),
      );

  // Add copyWith method for immutability
  ABGResult copyWith({
    FinalResult<PotassiumLevel>? potassiumResult,
    FinalResult<SodiumLevel>? sodiumResult,
    FinalResult<AlbuminLevel>? albuminResult,
    FinalResult<ChlorineLevel>? chlorineResult,
    FinalResult<MetabolicLevel>? metabolicResult,
    FinalResult<PhLevel>? phResult,
    FinalResult<PCO2Level>? pco2Result,
    FinalResult<CLNaLevel>? clNaResult,
    FinalResult<AGLevel>? agResult,
    FinalResult<SIGLevel>? sigResult,
    FinalResult<RespiratoryLevel>? respiratoryResult,
    FinalResult<OxygenWaterLevel>? oxygenResult,
  }) {
    return ABGResult(
      potassiumResult: potassiumResult ?? this.potassiumResult,
      sodiumResult: sodiumResult ?? this.sodiumResult,
      albuminResult: albuminResult ?? this.albuminResult,
      chlorineResult: chlorineResult ?? this.chlorineResult,
      metabolicResult: metabolicResult ?? this.metabolicResult,
      phResult: phResult ?? this.phResult,
      pco2Result: pco2Result ?? this.pco2Result,
      clNaResult: clNaResult ?? this.clNaResult,
      agResult: agResult ?? this.agResult,
      sigResult: sigResult ?? this.sigResult,
      respiratoryResult: respiratoryResult ?? this.respiratoryResult,
      oxygenResult: oxygenResult ?? this.oxygenResult,
    );
  }

  // Add method to check if result is complete
  bool get isComplete {
    return potassiumResult.findingNumber != 0 &&
        sodiumResult.findingNumber != 0 &&
        albuminResult.findingNumber != 0 &&
        chlorineResult.findingNumber != 0 &&
        metabolicResult.findingNumber != 0 &&
        phResult.findingNumber != 0 &&
        pco2Result.findingNumber != 0;
  }

  // Add method to get final diagnosis
  String getFinalDiagnosis() {
    if (!isComplete) {
      return "INCOMPLETE MEASURED ITEMS, PLEASE FILL THE INPUT FIELDS IN ANALYSIS PAGE";
    }

    return """
    This Patient had:
    - ${metabolicResult.findingLevel.level.$1}
    - ${respiratoryResult.findingLevel.level.$1}
    - ${oxygenResult.findingLevel.level.$1}
    """;
  }

  // Add equality operators
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ABGResult &&
        other.potassiumResult == potassiumResult &&
        other.sodiumResult == sodiumResult &&
        other.albuminResult == albuminResult &&
        other.chlorineResult == chlorineResult &&
        other.metabolicResult == metabolicResult &&
        other.phResult == phResult &&
        other.pco2Result == pco2Result &&
        other.clNaResult == clNaResult &&
        other.agResult == agResult &&
        other.sigResult == sigResult &&
        other.respiratoryResult == respiratoryResult &&
        other.oxygenResult == oxygenResult;
  }

  @override
  int get hashCode {
    return Object.hash(
      potassiumResult,
      sodiumResult,
      albuminResult,
      chlorineResult,
      metabolicResult,
      phResult,
      pco2Result,
      clNaResult,
      agResult,
      sigResult,
      respiratoryResult,
      oxygenResult,
    );
  }

  @override
  String toString() {
    return 'ABGResult{'
        'potassiumResult: $potassiumResult, '
        'sodiumResult: $sodiumResult, '
        'albuminResult: $albuminResult, '
        'chlorineResult: $chlorineResult, '
        'metabolicResult: $metabolicResult, '
        'phResult: $phResult, '
        'pco2Result: $pco2Result, '
        'clNaResult: $clNaResult, '
        'agResult: $agResult, '
        'sigResult: $sigResult, '
        'respiratoryResult: $respiratoryResult, '
        'oxygenResult: $oxygenResult}';
  }
}
