import '../resources/constants/calculation_constants.dart';
import '../resources/constants/string_constants.dart';

enum CurrentStep {
  measuredData(1),
  definitions(2);

  const CurrentStep(this.value);
  final int value;
}

//-----------------Input Levels--------------------------

enum PotassiumLevel {
  na(("N/A", null)),
  hypokalemia(("Hypokalemia", CalculationConstants.hypoValue)),
  hyperkalemia(("Hyperkalemia", CalculationConstants.hyperValue)),
  normokalemia(("Normokalemia", CalculationConstants.normalValue));

  const PotassiumLevel(this.level);
  final (String, int?) level;
}

enum SodiumLevel {
  na(("N/A", null)),
  hyponatremic(("Hyponatremic", CalculationConstants.hypoValue)),
  hypernatremic(("Hypernatremic", CalculationConstants.hyperValue)),
  normonatremic(("Normonatremic", CalculationConstants.normalValue));

  const SodiumLevel(this.level);
  final (String, int?) level;
}

enum AlbuminLevel {
  na(("N/A", null)),
  hypoalbuminemia(("Hypo Albuminemia", CalculationConstants.hypoValue)),
  hyperalbuminemia(("Hyper Albuminemia", CalculationConstants.hyperValue)),
  normonalbumin(("Normal Albuminemia", CalculationConstants.normalValue));

  const AlbuminLevel(this.level);
  final (String, int?) level;
}

enum ChlorineLevel {
  na(("N/A", null)),
  hypochloremic(("Hypochloremic", CalculationConstants.hypoValue)),
  hyperchloremic(("Hyperchloremic", CalculationConstants.hyperValue)),
  normochloremic(("Normochloremic", CalculationConstants.normalValue));

  const ChlorineLevel(this.level);
  final (String, int?) level;
}

enum MetabolicLevel {
  unknown(("N/A", null)),
  simpleMetabolicAcidosis(
      ("Normal Metabolic Acidosis", CalculationConstants.hypoValue)),
  mixedMetabolicAcidosis(
      ("Mixed Metabolic Acidosis", CalculationConstants.hypoValue)),
  mixedMetabolicAlkalosis(
      ("Mixed Metabolic Alkalosis", CalculationConstants.hypoValue)),
  metabolicAcidosis(("Metabolic Acidosis", CalculationConstants.hypoValue)),
  simpleMetabolicAlkalosis(
      ("Normal Metabolic Alkalosis", CalculationConstants.hyperValue)),
  metabolicAlkalosis(("Metabolic Alkalosis", CalculationConstants.hyperValue)),

  normal(("Normal Metabolic State", CalculationConstants.normalValue));

  const MetabolicLevel(this.level);
  final (String, int?) level;
}

enum PhLevel {
  na(("N/A", null)),
  acidosis(("Acidosis", CalculationConstants.hypoValue)),
  alkalosis(("Alkalosis", CalculationConstants.hyperValue)),
  normal(("Normal Metabolic State", CalculationConstants.normalValue));

  const PhLevel(this.level);
  final (String, int?) level;
}

enum PCO2Level {
  na(("N/A", null)),
  respiratoryAlkalosis(
      ("Respiratory Alkalosis", CalculationConstants.hypoValue)),
  respiratoryAcidosis(
      ("Respiratory Acidosis", CalculationConstants.hyperValue)),
  normocarpic(("Normocarpic", CalculationConstants.normalValue));

  const PCO2Level(this.level);
  final (String, int?) level;
}

//-----------------Results Levels--------------------------

enum CLNaLevel {
  na(("N/A", null)),
  hypoTwoCases(
      ("Hypochlorimic or Hypernatrimic", CalculationConstants.hypoValue)),
  hyperTwoCases(
      ("Hyper Chlorimic or Hyponatrimic", CalculationConstants.hyperValue)),
  hypo(("Hyporchloremia", CalculationConstants.hypoValue)),
  hyper(("Hyperchloremia", CalculationConstants.hyperValue)),
  normalOrHemo((
    "Normal or Hemodilution or Hemoconcentration",
    CalculationConstants.normalValue
  )),
  normal(("Normochlormic", CalculationConstants.normalValue));

  const CLNaLevel(this.level);
  final (String, int?) level;
}

enum AGLevel {
  na(("N/A", null)),
  lowAG(("Low AG", CalculationConstants.hypoValue)),
  highAG(("High AG", CalculationConstants.hyperValue)),
  normalAG(("Normal AG", CalculationConstants.normalValue));

  const AGLevel(this.level);
  final (String, int?) level;
}

enum SIGLevel {
  na(("N/A", null)),
  withNoFixedAcids(("with no Fixed Acids", CalculationConstants.hypoValue)),
  withFixedAcids(("with  Fixed Acids", CalculationConstants.hyperValue));

  const SIGLevel(this.level);
  final (String, int?) level;
}

enum RespiratoryLevel {
  unknown(("N/A", null)),
  hypoVentilatoryRespiratoryAcidosis((
    "Hypo Ventilatory Respiratory Acidosis",
    CalculationConstants.hypoValue
  )),
  hyperVentilatoryRespiratoryAlkalosis((
    "Hyper Ventilatory Respiratory Alkalosis",
    CalculationConstants.hyperValue
  )),
  compensatoryRespiratoryAcidosis(
      ("Compensatory Respiratory Acidosis", CalculationConstants.hypoValue)),

  compensatoryRespiratoryAlkalosis(
      ("Compensatory Respiratory Alkalosis", CalculationConstants.hyperValue)),
  normocarbia(("Normocarbia", CalculationConstants.normalValue));

  const RespiratoryLevel(this.level);
  final (String, int?) level;
}

enum OxygenWaterLevel {
  unknown(("NO DATA", null)),
  hypoxemia(("Hypoxemia", CalculationConstants.hypoValue)),
  normoxia(("Normoxia", CalculationConstants.normalValue));

  const OxygenWaterLevel(this.level);
  final (String, int?) level;
}

enum PatientType {
  patientTypeOne('( ${StringConstants.patientTypeOne})'),
  patientTypeTwo('( ${StringConstants.patientTypeTwo})');

  const PatientType(this.type);
  final String type;
}
