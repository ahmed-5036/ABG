import 'package:flutter_test/flutter_test.dart';
import 'package:aai_app/services/calculations/copd_calculator.dart';
import 'package:aai_app/services/enum.dart';
import 'package:aai_app/models/abg_result.dart';

void main() {
  group('COPDNormalCalculator', () {
    final COPDNormalCalculator calculator = COPDNormalCalculator();

    test('Metabolic state: normal AG scenario', () {
      final FinalResult<MetabolicLevel> result = calculator.calculateMetabolicState(
        sodium: 140,
        chlorine: 104,
        hco3: 24,
        albumin: 4,
      );
      expect(result.findingLevel, MetabolicLevel.normal);
      expect(result.findingNumber, 24);
      expect(result.additionalData, isNotNull);
      expect(result.additionalData!['correctedAG'], closeTo(12, 0.01));
      expect(result.additionalData!['expectedHCO3'], closeTo(24, 0.01));
      expect(result.additionalData!['expectedPCO2'], closeTo(40, 0.01));
      expect(result.additionalData!['expectedPH'], closeTo(7.4, 0.01));
    });

    test('Respiratory state: normocarbia', () {
      final FinalResult<RespiratoryLevel> result = calculator.calculateRespiratoryState(
        pco2: 40,
        hco3: 24,
        ph: 7.4,
      );
      expect(result.findingLevel, RespiratoryLevel.normocarbia);
      expect(result.findingNumber, 40);
      expect(result.additionalData!['expectedPCO2'], closeTo(40, 0.01));
    });

    test('Oxygenation state: normoxia', () {
      final FinalResult<OxygenWaterLevel> result = calculator.calculateOxygenationState(
        fio2: 21,
        pco2: 40,
        pao2: 100,
        age: 30,
      );
      expect(result.findingLevel, OxygenWaterLevel.normoxia);
      expect(result.additionalData!['pAO2'], isA<double>());
      expect(result.additionalData!['expectedAa'], isA<double>());
    });
  });

  group('COPDHighCalculator', () {
    final COPDHighCalculator calculator = COPDHighCalculator();

    test('Metabolic state: high AG scenario', () {
      final FinalResult<MetabolicLevel> result = calculator.calculateMetabolicState(
        sodium: 140,
        chlorine: 100,
        hco3: 20,
        albumin: 4,
      );
      expect(result.findingLevel, MetabolicLevel.metabolicAcidosis);
      expect(result.findingNumber, 20);
      expect(result.additionalData, isNotNull);
      expect(result.additionalData!['measuredSID'], closeTo(40, 0.01));
      expect(result.additionalData!['expectedHCO3'], closeTo(16, 0.01));
      expect(result.additionalData!['expectedPCO2'], closeTo(28.57, 0.01));
      expect(result.additionalData!['expectedPH'], isA<double>());
    });

    test('Respiratory state: normocarbia', () {
      final FinalResult<RespiratoryLevel> result = calculator.calculateRespiratoryState(
        pco2: 40,
        hco3: 24,
        ph: 7.4,
      );
      expect(result.findingLevel, RespiratoryLevel.normocarbia);
      expect(result.findingNumber, 40);
      expect(result.additionalData!['expectedPCO2'], closeTo(40, 0.01));
    });

    test('Oxygenation state: hypoxemia', () {
      final FinalResult<OxygenWaterLevel> result = calculator.calculateOxygenationState(
        fio2: 21,
        pco2: 40,
        pao2: 50,
        age: 30,
      );
      expect(result.findingLevel, OxygenWaterLevel.hypoxemia);
      expect(result.additionalData!['pAO2'], isA<double>());
      expect(result.additionalData!['expectedAa'], isA<double>());
    });
  });
} 