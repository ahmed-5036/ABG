import 'package:aai_app/services/calculations/follow_up_calculator.dart';
import 'package:aai_app/services/enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aai_app/services/calculations/follow_up_calculator.dart';
import 'package:aai_app/models/abg_result.dart';
import 'package:aai_app/services/enum.dart';

void main() {
  group('MetabolicPrimaryCalculator', () {
    final calculator = MetabolicPrimaryCalculator();
// Happy path: Normal metabolic state
    test('returns normal metabolic state when HCO3 is 24', () {
      final result = calculator.calculateMetabolicState(
        sodium: 140,
        chlorine: 104,
        hco3: 24,
        albumin: 4,
      );
      expect(result.findingLevel, MetabolicLevel.normal);
      expect(result.findingNumber, 24);
    });

// Edge case: Simple metabolic acidosis
    test(
        'returns simple metabolic acidosis when HCO3 is less than 24 and SID2 is less than 36',
        () {
      final result = calculator.calculateMetabolicState(
        sodium: 130,
        chlorine: 100,
        hco3: 20,
        albumin: 4,
      );
      expect(result.findingLevel, MetabolicLevel.simpleMetabolicAcidosis);
    });

// Edge case: Mixed metabolic alkalosis
    test(
        'returns mixed metabolic alkalosis when HCO3 is greater than 24 and SID2 is less than 36',
        () {
      final result = calculator.calculateMetabolicState(
        sodium: 140,
        chlorine: 110,
        hco3: 28,
        albumin: 4,
      );
      expect(result.findingLevel, MetabolicLevel.mixedMetabolicAlkalosis);
    });
  });
  group('RespiratoryPrimaryCalculator', () {
    final calculator = RespiratoryPrimaryCalculator();
// Happy path: Normocarbia
    test('returns normocarbia when PCO2 is 40', () {
      final result = calculator.calculateRespiratoryState(
        pco2: 40,
        hco3: 24,
        ph: 7.4,
      );
      expect(result.findingLevel, RespiratoryLevel.normocarbia);
    });

// Edge case: Hypo ventilatory respiratory acidosis
    test(
        'returns hypo ventilatory respiratory acidosis when PCO2 is greater than 40',
        () {
      final result = calculator.calculateRespiratoryState(
        pco2: 50,
        hco3: 24,
        ph: 7.3,
      );
      expect(result.findingLevel,
          RespiratoryLevel.hypoVentilatoryRespiratoryAcidosis);
    });

// Edge case: Hyper ventilatory respiratory alkalosis
    test(
        'returns hyper ventilatory respiratory alkalosis when PCO2 is less than 40',
        () {
      final result = calculator.calculateRespiratoryState(
        pco2: 30,
        hco3: 24,
        ph: 7.5,
      );
      expect(result.findingLevel,
          RespiratoryLevel.hyperVentilatoryRespiratoryAlkalosis);
    });
  });
  group('OxygenationState', () {
    final calculator = MetabolicPrimaryCalculator();
// Happy path: Normoxia
    test('returns normoxia when A-a gradient is within normal range', () {
      final result = calculator.calculateOxygenationState(
        fio2: 21,
        pco2: 40,
        pao2: 100,
        age: 30,
      );
      expect(result.findingLevel, OxygenWaterLevel.normoxia);
    });

// Edge case: Hypoxemia
    test('returns hypoxemia when A-a gradient is elevated', () {
      final result = calculator.calculateOxygenationState(
        fio2: 21,
        pco2: 40,
        pao2: 50,
        age: 30,
      );
      expect(result.findingLevel, OxygenWaterLevel.hypoxemia);
    });
  });
}
