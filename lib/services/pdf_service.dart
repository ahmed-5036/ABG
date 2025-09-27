// lib/services/pdf_service.dart
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/abg_result.dart';
import '../services/calculators/calculator_factory.dart';
import '../resources/constants/string_constants.dart';
import '../services/enum.dart';
import '../providers/index.dart';

class PDFService {
  static Future<void> generateAndSavePDF({
    required Map<String, double> inputValues,
    required ABGResult results,
    required CalculatorType calculatorType,
    required Map<String, dynamic>? additionalData,
    required String finalDiagnosis,
    required WidgetRef ref,
  }) async {
    final pdf = pw.Document();

    // No logo needed

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          // Different structure for COPD vs other ABG analyses
          if (_isCopdCalculator(calculatorType)) {
            return [
              _buildHeader(calculatorType),
              pw.SizedBox(height: 20),
              _buildInputValuesSection(inputValues),
              pw.SizedBox(height: 20),
              _buildCopdCalculatedValuesSection(calculatorType, additionalData),
            ];
          } else {
            return [
              _buildHeader(calculatorType),
              pw.SizedBox(height: 20),
              _buildInputValuesSection(inputValues),
              pw.SizedBox(height: 20),
              _buildStartMetabolicStateSection(ref, calculatorType),
              pw.SizedBox(height: 20),
              _buildPresentMetabolicChangeSection(ref, calculatorType),
              pw.SizedBox(height: 20),
              _buildVentilatoryStateSection(ref, calculatorType),
              pw.SizedBox(height: 20),
              _buildOxygenationStateSection(ref, calculatorType),
              pw.SizedBox(height: 20),
              _buildComprehensiveFinalDiagnosisSection(
                  finalDiagnosis, ref, calculatorType),
            ];
          }
        },
      ),
    );

    // Save PDF
    await _savePDF(pdf);
  }

  static pw.Widget _buildHeader(CalculatorType calculatorType) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue900, width: 2),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            StringConstants.patientReport,
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            _getCalculatorTypeName(calculatorType),
            style: pw.TextStyle(
              fontSize: 16,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            '${StringConstants.generatedOn}: ${DateTime.now().toString().substring(0, 19)}',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInputValuesSection(Map<String, double> inputValues) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          StringConstants.inputValues,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: const {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(1),
            2: pw.FlexColumnWidth(1),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('Parameter', isHeader: true),
                _buildTableCell('Value', isHeader: true),
                _buildTableCell('Unit', isHeader: true),
              ],
            ),
            ...inputValues.entries.map((entry) => pw.TableRow(
                  children: [
                    _buildTableCell(_formatParameterName(entry.key)),
                    _buildTableCell(entry.value.toStringAsFixed(2)),
                    _buildTableCell(_getParameterUnit(entry.key)),
                  ],
                )),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildCalculatedValuesSection(ABGResult results,
      CalculatorType calculatorType, Map<String, dynamic>? additionalData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          StringConstants.calculatedValues,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        _buildCalculatedValuesTable(results, calculatorType, additionalData),
      ],
    );
  }

  static pw.Widget _buildCalculatedValuesTable(ABGResult results,
      CalculatorType calculatorType, Map<String, dynamic>? additionalData) {
    List<pw.TableRow> rows = [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.grey200),
        children: [
          _buildTableCell('Calculated Parameter', isHeader: true),
          _buildTableCell('Value', isHeader: true),
          _buildTableCell('Unit', isHeader: true),
        ],
      ),
    ];

    // Add calculated values based on calculator type
    if (_isCopdCalculator(calculatorType)) {
      if (additionalData != null) {
        if (additionalData.containsKey('correctedAG')) {
          rows.add(pw.TableRow(children: [
            _buildTableCell('Corrected AG'),
            _buildTableCell((additionalData['correctedAG'] as double?)
                    ?.toStringAsFixed(1) ??
                'N/A'),
            _buildTableCell('mEq/L'),
          ]));
        }
        if (additionalData.containsKey('measuredSID')) {
          rows.add(pw.TableRow(children: [
            _buildTableCell('Measured SID'),
            _buildTableCell((additionalData['measuredSID'] as double?)
                    ?.toStringAsFixed(1) ??
                'N/A'),
            _buildTableCell('mEq/L'),
          ]));
        }
        if (additionalData.containsKey('expectedHCO3')) {
          rows.add(pw.TableRow(children: [
            _buildTableCell('Expected HCO3'),
            _buildTableCell((additionalData['expectedHCO3'] as double?)
                    ?.toStringAsFixed(1) ??
                'N/A'),
            _buildTableCell('mEq/L'),
          ]));
        }
        if (additionalData.containsKey('expectedPCO2')) {
          rows.add(pw.TableRow(children: [
            _buildTableCell('Expected PCO2'),
            _buildTableCell((additionalData['expectedPCO2'] as double?)
                    ?.toStringAsFixed(1) ??
                'N/A'),
            _buildTableCell('mmHg'),
          ]));
        }
        if (additionalData.containsKey('expectedPH')) {
          rows.add(pw.TableRow(children: [
            _buildTableCell('Expected pH'),
            _buildTableCell(
                (additionalData['expectedPH'] as double?)?.toStringAsFixed(2) ??
                    'N/A'),
            _buildTableCell(''),
          ]));
        }
      }
    } else {
      // Standard ABG calculations
      final metabolicData = results.metabolicResult.additionalData;
      if (metabolicData != null) {
        if (metabolicData.containsKey('correctedAGStart')) {
          rows.add(pw.TableRow(children: [
            _buildTableCell('Corrected AG'),
            _buildTableCell((metabolicData['correctedAGStart'] as double?)
                    ?.toStringAsFixed(1) ??
                'N/A'),
            _buildTableCell('mEq/L'),
          ]));
        }
        if (metabolicData.containsKey('sid')) {
          rows.add(pw.TableRow(children: [
            _buildTableCell('SID'),
            _buildTableCell(
                (metabolicData['sid'] as double?)?.toStringAsFixed(1) ?? 'N/A'),
            _buildTableCell('mEq/L'),
          ]));
        }
        if (metabolicData.containsKey('clNa')) {
          rows.add(pw.TableRow(children: [
            _buildTableCell('Cl/Na Ratio'),
            _buildTableCell(
                (metabolicData['clNa'] as double?)?.toStringAsFixed(3) ??
                    'N/A'),
            _buildTableCell(''),
          ]));
        }
      }

      final respiratoryData = results.respiratoryResult.additionalData;
      if (respiratoryData != null) {
        if (respiratoryData.containsKey('expectedPCO2')) {
          rows.add(pw.TableRow(children: [
            _buildTableCell('Expected PCO2'),
            _buildTableCell((respiratoryData['expectedPCO2'] as double?)
                    ?.toStringAsFixed(1) ??
                'N/A'),
            _buildTableCell('mmHg'),
          ]));
        }
      }

      final oxygenData = results.oxygenResult.additionalData;
      if (oxygenData != null) {
        if (oxygenData.containsKey('pAO2')) {
          rows.add(pw.TableRow(children: [
            _buildTableCell('PAO2'),
            _buildTableCell(
                (oxygenData['pAO2'] as double?)?.toStringAsFixed(1) ?? 'N/A'),
            _buildTableCell('mmHg'),
          ]));
        }
        if (oxygenData.containsKey('expectedAa')) {
          rows.add(pw.TableRow(children: [
            _buildTableCell('Expected A-a Gradient'),
            _buildTableCell(
                (oxygenData['expectedAa'] as double?)?.toStringAsFixed(1) ??
                    'N/A'),
            _buildTableCell('mmHg'),
          ]));
        }
      }
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: const {
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(1),
      },
      children: rows,
    );
  }

  static pw.Widget _buildAnalysisResultsSection(ABGResult results) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          StringConstants.analysisResults,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: const {
            0: pw.FlexColumnWidth(1),
            1: pw.FlexColumnWidth(2),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('Analysis Type', isHeader: true),
                _buildTableCell('Result', isHeader: true),
              ],
            ),
            pw.TableRow(children: [
              _buildTableCell(StringConstants.metabolicState),
              _buildTableCell(results.metabolicResult.findingLevel.level.$1),
            ]),
            pw.TableRow(children: [
              _buildTableCell(StringConstants.respiratoryState),
              _buildTableCell(results.respiratoryResult.findingLevel.level.$1),
            ]),
            pw.TableRow(children: [
              _buildTableCell(StringConstants.oxygenationState),
              _buildTableCell(results.oxygenResult.findingLevel.level.$1),
            ]),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildFinalDiagnosisSection(String finalDiagnosis) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue200),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            StringConstants.finalDiagnosis,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            finalDiagnosis,
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 11,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.black : PdfColors.grey800,
        ),
      ),
    );
  }

  static String _formatParameterName(String key) {
    switch (key) {
      case 'ph':
        return 'pH';
      case 'pco2':
        return 'PCO2';
      case 'hco3':
        return 'HCO3';
      case 'sodium':
        return 'Sodium';
      case 'chlorine':
        return 'Chloride';
      case 'albumin':
        return 'Albumin';
      case 'fio2':
        return 'FiO2';
      case 'pao2':
        return 'PaO2';
      case 'age':
        return 'Age';
      case 'potassium':
        return 'Potassium';
      default:
        return key.toUpperCase();
    }
  }

  static String _getParameterUnit(String key) {
    switch (key) {
      case 'ph':
        return '';
      case 'pco2':
        return 'mmHg';
      case 'hco3':
        return 'mEq/L';
      case 'sodium':
        return 'mEq/L';
      case 'chlorine':
        return 'mEq/L';
      case 'albumin':
        return 'g/dL';
      case 'fio2':
        return '%';
      case 'pao2':
        return 'mmHg';
      case 'age':
        return 'years';
      case 'potassium':
        return 'mEq/L';
      default:
        return '';
    }
  }

  static String _getCalculatorTypeName(CalculatorType type) {
    switch (type) {
      case CalculatorType.admissionABGNormal:
        return 'Admission ABG - Normal Altitude';
      case CalculatorType.admissionABGHigh:
        return 'Admission ABG - High Altitude';
      case CalculatorType.followUpABGMetabolic:
        return 'Follow-up ABG - Primary Metabolic';
      case CalculatorType.followUpABGRespiratory:
        return 'Follow-up ABG - Primary Respiratory';
      case CalculatorType.copdCalculationNormal:
        return 'COPD Module 1 - Normal AG to High AG';
      case CalculatorType.copdCalculationHigh:
        return 'COPD Module 2 - High AG to Normal AG';
      default:
        return 'ABG Analysis';
    }
  }

  static bool _isCopdCalculator(CalculatorType type) {
    return type == CalculatorType.copdCalculationNormal ||
        type == CalculatorType.copdCalculationHigh;
  }

  static bool _isAdmissionABGCalculator(CalculatorType type) {
    return type == CalculatorType.admissionABGNormal ||
        type == CalculatorType.admissionABGHigh;
  }

  static bool _isFollowUpABGCalculator(CalculatorType type) {
    return type == CalculatorType.followUpABGMetabolic ||
        type == CalculatorType.followUpABGRespiratory;
  }

  static pw.Widget _buildStartMetabolicStateSection(
      WidgetRef ref, CalculatorType calculatorType) {
    // Only show for Admission ABG cases
    if (!_isAdmissionABGCalculator(calculatorType)) {
      return pw.SizedBox.shrink();
    }
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Start Metabolic State',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        _buildStartMetabolicStateTable(ref, calculatorType),
        pw.SizedBox(height: 10),
        _buildStartMetabolicStateDiagnosis(ref),
      ],
    );
  }

  static pw.Widget _buildStartMetabolicStateTable(
      WidgetRef ref, CalculatorType calculatorType) {
    List<pw.TableRow> rows = [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.blue100),
        children: [
          _buildMedicalTableCell('Items', isHeader: true),
          _buildMedicalTableCell('Value', isHeader: true),
          _buildMedicalTableCell('Definition', isHeader: true),
        ],
      ),
    ];

    // Add Corrected CL row (only for High ABG calculations)
    if (calculatorType == CalculatorType.admissionABGHigh) {
      final correctedCL = ref.read(correctedCLProvider);
      final correctedCLResult = ref.read(correctedCLProviderResult);
      rows.add(pw.TableRow(children: [
        _buildMedicalTableCell('Corrected CL'),
        _buildMedicalTableCell(correctedCL.toStringAsFixed(1)),
        _buildMedicalTableCell(correctedCLResult.level.$1),
      ]));
    }

    // CL/NA ratio
    final clNaRatio = ref.read(clNaCalculationProvider);
    final clNaResult = ref.read(clNaResultProvider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('CL/NA'),
      _buildMedicalTableCell(clNaRatio.toString()),
      _buildMedicalTableCell(clNaResult.level.$1),
    ]));

    // SID (Strong Ion Difference)
    final sid = ref.read(sidGeneralProvider);
    final sidResult = ref.read(sidResultProvider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('SID mEq/L'),
      _buildMedicalTableCell(sid.toStringAsFixed(1)),
      _buildMedicalTableCell(sidResult.level.$1),
    ]));

    // Corrected HCO3
    final correctedHCO3 = ref.read(correctedHCO3Provider);
    final correctedHCO3Result = ref.read(correctedHCO3ResultProvider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('Corrected HCO3'),
      _buildMedicalTableCell(correctedHCO3?.toStringAsFixed(1) ?? 'N/A'),
      _buildMedicalTableCell(correctedHCO3Result.level.$1),
    ]));

    // Corrected AG Start
    final correctedAG = ref.read(correctedAGStartProvider);
    final correctedAGResult = ref.read(correctedAGStartResultProvider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('Corrected AG Start'),
      _buildMedicalTableCell(correctedAG.toStringAsFixed(1)),
      _buildMedicalTableCell(correctedAGResult),
    ]));

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.blue600, width: 1),
      columnWidths: const {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(3),
      },
      children: rows,
    );
  }

  static pw.Widget _buildPresentMetabolicChangeSection(
      WidgetRef ref, CalculatorType calculatorType) {
    String sectionTitle = 'Present Metabolic Change';
    
    // Customize title based on calculator type
    if (_isFollowUpABGCalculator(calculatorType)) {
      if (calculatorType == CalculatorType.followUpABGMetabolic) {
        sectionTitle = 'Metabolic State Analysis';
      } else {
        sectionTitle = 'Metabolic Response to Respiratory Changes';
      }
    } else if (_isCopdCalculator(calculatorType)) {
      sectionTitle = 'COPD Metabolic Analysis';
    }
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          sectionTitle,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        _buildPresentMetabolicChangeTable(ref, calculatorType),
        pw.SizedBox(height: 10),
        _buildPresentMetabolicChangeDiagnosis(ref),
      ],
    );
  }

  static pw.Widget _buildPresentMetabolicChangeTable(
      WidgetRef ref, CalculatorType calculatorType) {
    List<pw.TableRow> rows = [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.blue100),
        children: [
          _buildMedicalTableCell('Items', isHeader: true),
          _buildMedicalTableCell('Value', isHeader: true),
          _buildMedicalTableCell('Definition', isHeader: true),
        ],
      ),
    ];

    // Buffer Base (BB)
    final bb = ref.read(bbCalculationProvider);
    final bbResult = ref.read(bbResultProvider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('BB'),
      _buildMedicalTableCell(bb.toStringAsFixed(1)),
      _buildMedicalTableCell(bbResult.level.$1),
    ]));

    // Corrected AG Present
    final correctedAGPresent = ref.read(correctedAGPresentProvider);
    final correctedAGPresentResult = ref.read(correctedAGPresentResultProvider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('Corrected AG Present'),
      _buildMedicalTableCell(correctedAGPresent.toStringAsFixed(1)),
      _buildMedicalTableCell(correctedAGPresentResult.level.$1),
    ]));

    // SIG (Strong Ion Gap)
    final sig = ref.read(sigProvider);
    final sigResult = ref.read(sigResultProvider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('SIG'),
      _buildMedicalTableCell(sig.toStringAsFixed(1)),
      _buildMedicalTableCell(sigResult.level.$1),
    ]));

    // Corrected HCO3 for Correlation
    final correctedHCO3Corr = ref.read(correctedHCO3ForCorrelationProvider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('Corrected HCO3 for Correlation'),
      _buildMedicalTableCell(correctedHCO3Corr.toStringAsFixed(1)),
      _buildMedicalTableCell('Expected HCO3 based on AG correction'),
    ]));

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.blue600, width: 1),
      columnWidths: const {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(3),
      },
      children: rows,
    );
  }

  static pw.Widget _buildVentilatoryStateSection(
      WidgetRef ref, CalculatorType calculatorType) {
    String sectionTitle = 'Ventilatory State';
    
    // Customize title based on calculator type
    if (_isFollowUpABGCalculator(calculatorType)) {
      if (calculatorType == CalculatorType.followUpABGRespiratory) {
        sectionTitle = 'Primary Respiratory Analysis';
      } else {
        sectionTitle = 'Respiratory Compensation';
      }
    } else if (_isCopdCalculator(calculatorType)) {
      sectionTitle = 'COPD Respiratory Status';
    }
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          sectionTitle,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        _buildVentilatoryStateTable(ref, calculatorType),
        pw.SizedBox(height: 10),
        _buildVentilatoryStateDiagnosis(ref),
      ],
    );
  }

  static pw.Widget _buildVentilatoryStateTable(
      WidgetRef ref, CalculatorType calculatorType) {
    List<pw.TableRow> rows = [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.blue100),
        children: [
          _buildMedicalTableCell('Items', isHeader: true),
          _buildMedicalTableCell('Value', isHeader: true),
          _buildMedicalTableCell('Definition', isHeader: true),
        ],
      ),
    ];

    // Expected PCO2
    final expectedPCO2 = ref.read(expectedPCo2CalculationProvider);
    final expectedPCO2Result = ref.read(expectedPCo2ResultProvider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('Expected PCO2'),
      _buildMedicalTableCell(expectedPCO2.toStringAsFixed(1)),
      _buildMedicalTableCell(expectedPCO2Result.level.$1),
    ]));

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.blue600, width: 1),
      columnWidths: const {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(3),
      },
      children: rows,
    );
  }

  static pw.Widget _buildOxygenationStateSection(
      WidgetRef ref, CalculatorType calculatorType) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Oxygenation State',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        _buildOxygenationStateTable(ref, calculatorType),
        pw.SizedBox(height: 10),
        _buildOxygenationStateDiagnosis(ref),
      ],
    );
  }

  static pw.Widget _buildOxygenationStateTable(
      WidgetRef ref, CalculatorType calculatorType) {
    List<pw.TableRow> rows = [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.blue100),
        children: [
          _buildMedicalTableCell('Items', isHeader: true),
          _buildMedicalTableCell('Value', isHeader: true),
          _buildMedicalTableCell('Definition', isHeader: true),
        ],
      ),
    ];

    // PAO2 Output
    final pAO2 = ref.read(pAOutputO2Provider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('PAO2'),
      _buildMedicalTableCell(pAO2.toStringAsFixed(1)),
      _buildMedicalTableCell('Alveolar oxygen partial pressure'),
    ]));

    // A-a gradient
    final aA = ref.read(aAProvider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('A-a gradient'),
      _buildMedicalTableCell(aA.toStringAsFixed(1)),
      _buildMedicalTableCell('Alveolar-arterial oxygen gradient'),
    ]));

    // Expected A-a gradient
    final expectedAa = ref.read(expectedAaProvider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('Expected A-a gradient'),
      _buildMedicalTableCell(expectedAa.toStringAsFixed(1)),
      _buildMedicalTableCell('Age-adjusted expected A-a gradient'),
    ]));

    // Oxygenation diagnosis
    final oxygenationDiagnosis = ref.read(diagnosisFourthResultProvider);
    rows.add(pw.TableRow(children: [
      _buildMedicalTableCell('Oxygenation Status'),
      _buildMedicalTableCell(oxygenationDiagnosis.level.$1),
      _buildMedicalTableCell('Final oxygenation assessment'),
    ]));

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.blue600, width: 1),
      columnWidths: const {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(3),
      },
      children: rows,
    );
  }

  static pw.Widget _buildCopdSpecificSection(
      WidgetRef ref, CalculatorType calculatorType, Map<String, dynamic>? additionalData) {
    // Only show for COPD cases
    if (!_isCopdCalculator(calculatorType)) {
      return pw.SizedBox.shrink();
    }
    
    String sectionTitle = calculatorType == CalculatorType.copdCalculationNormal
        ? 'COPD Module 1: Normal AG to High AG Progression'
        : 'COPD Module 2: High AG to Normal AG Progression';
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          sectionTitle,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.red900,
          ),
        ),
        pw.SizedBox(height: 10),
        _buildCopdSpecificTable(ref, calculatorType, additionalData),
        pw.SizedBox(height: 10),
        _buildCopdSpecificDiagnosis(ref, calculatorType),
      ],
    );
  }

  static pw.Widget _buildCopdSpecificTable(
      WidgetRef ref, CalculatorType calculatorType, Map<String, dynamic>? additionalData) {
    List<pw.TableRow> rows = [
      pw.TableRow(
        decoration: const pw.BoxDecoration(color: PdfColors.red100),
        children: [
          _buildMedicalTableCell('COPD Parameter', isHeader: true),
          _buildMedicalTableCell('Value', isHeader: true),
          _buildMedicalTableCell('Clinical Significance', isHeader: true),
        ],
      ),
    ];

    if (additionalData != null) {
      // Add COPD-specific calculations
      if (additionalData.containsKey('correctedAG')) {
        rows.add(pw.TableRow(children: [
          _buildMedicalTableCell('Corrected AG'),
          _buildMedicalTableCell((additionalData['correctedAG'] as double?)?.toStringAsFixed(1) ?? 'N/A'),
          _buildMedicalTableCell('Anion gap progression tracking'),
        ]));
      }
      
      if (additionalData.containsKey('measuredSID')) {
        rows.add(pw.TableRow(children: [
          _buildMedicalTableCell('Measured SID'),
          _buildMedicalTableCell((additionalData['measuredSID'] as double?)?.toStringAsFixed(1) ?? 'N/A'),
          _buildMedicalTableCell('Strong ion difference in COPD'),
        ]));
      }
      
      if (additionalData.containsKey('expectedHCO3')) {
        rows.add(pw.TableRow(children: [
          _buildMedicalTableCell('Expected HCO3'),
          _buildMedicalTableCell((additionalData['expectedHCO3'] as double?)?.toStringAsFixed(1) ?? 'N/A'),
          _buildMedicalTableCell('Expected bicarbonate for COPD compensation'),
        ]));
      }
      
      if (additionalData.containsKey('expectedPCO2')) {
        rows.add(pw.TableRow(children: [
          _buildMedicalTableCell('Expected PCO2'),
          _buildMedicalTableCell((additionalData['expectedPCO2'] as double?)?.toStringAsFixed(1) ?? 'N/A'),
          _buildMedicalTableCell('Expected CO2 retention in COPD'),
        ]));
      }
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.red600, width: 1),
      columnWidths: const {
        0: pw.FlexColumnWidth(3),
        1: pw.FlexColumnWidth(2),
        2: pw.FlexColumnWidth(3),
      },
      children: rows,
    );
  }

  static pw.Widget _buildCopdSpecificDiagnosis(WidgetRef ref, CalculatorType calculatorType) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.red50,
        border: pw.Border.all(color: PdfColors.red200),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'COPD Analysis Diagnosis:',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red900,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            calculatorType == CalculatorType.copdCalculationNormal
                ? 'COPD patient with progression from normal AG to high AG metabolic changes'
                : 'COPD patient with progression from high AG to normal AG metabolic changes',
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildComprehensiveFinalDiagnosisSection(
      String finalDiagnosis, WidgetRef ref, CalculatorType calculatorType) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        border: pw.Border.all(color: PdfColors.blue200),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Final Diagnosis',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            finalDiagnosis,
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildMedicalTableCell(String text,
      {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 11,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.blue900 : PdfColors.black,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildStartMetabolicStateDiagnosis(WidgetRef ref) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        border: pw.Border.all(color: PdfColors.green200),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Start Metabolic State Diagnosis:',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green900,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            ref.read(diagnosisOneResultProvider),
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildPresentMetabolicChangeDiagnosis(WidgetRef ref) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.orange50,
        border: pw.Border.all(color: PdfColors.orange200),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Present Metabolic Change Diagnosis:',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.orange900,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            ref.read(diagnosisSecondResultProvider),
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildVentilatoryStateDiagnosis(WidgetRef ref) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.purple50,
        border: pw.Border.all(color: PdfColors.purple200),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Ventilatory State Diagnosis:',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.purple900,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            ref.read(diagnosisThirdResultProvider),
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildOxygenationStateDiagnosis(WidgetRef ref) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.cyan50,
        border: pw.Border.all(color: PdfColors.cyan200),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Oxygenation State Diagnosis:',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.cyan900,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            ref.read(diagnosisFourthResultProvider).level.$1,
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCopdCalculatedValuesSection(
      CalculatorType calculatorType, Map<String, dynamic>? additionalData) {
    
    String sectionTitle = calculatorType == CalculatorType.copdCalculationNormal
        ? 'COPD Module 1 - Calculated Values'
        : 'COPD Module 2 - Calculated Values';
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue100,
            border: pw.Border.all(color: PdfColors.blue800),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Text(
            sectionTitle,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
        ),
        pw.SizedBox(height: 12),
        _buildCopdValuesTable(calculatorType, additionalData),
      ],
    );
  }

  static pw.Widget _buildCopdValuesTable(
      CalculatorType calculatorType, Map<String, dynamic>? additionalData) {
    
    final bool isNormalCopd = calculatorType == CalculatorType.copdCalculationNormal;
    
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue800),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Table(
        border: pw.TableBorder.all(color: PdfColors.blue800),
        columnWidths: const {
          0: pw.FlexColumnWidth(3),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(2),
        },
        children: [
          // Header row
          pw.TableRow(
            decoration: const pw.BoxDecoration(
              color: PdfColors.blue100,
            ),
            children: [
              _buildMedicalTableCell('Parameter', isHeader: true),
              _buildMedicalTableCell('Value', isHeader: true),
              _buildMedicalTableCell('Units', isHeader: true),
            ],
          ),
          // Data rows - only the values shown on screen
          pw.TableRow(
            children: [
              _buildMedicalTableCell(isNormalCopd ? 'Corrected AG' : 'Measured SID'),
              _buildMedicalTableCell(
                isNormalCopd 
                  ? ((additionalData?['correctedAG'] as double?)?.toStringAsFixed(1) ?? 'N/A')
                  : ((additionalData?['measuredSID'] as double?)?.toStringAsFixed(1) ?? 'N/A')
              ),
              _buildMedicalTableCell('mEq/L'),
            ],
          ),
          pw.TableRow(
            children: [
              _buildMedicalTableCell('Expected HCO3'),
              _buildMedicalTableCell(
                (additionalData?['expectedHCO3'] as double?)?.toStringAsFixed(1) ?? 'N/A'
              ),
              _buildMedicalTableCell('mEq/L'),
            ],
          ),
          pw.TableRow(
            children: [
              _buildMedicalTableCell('Expected PCO2'),
              _buildMedicalTableCell(
                (additionalData?['expectedPCO2'] as double?)?.toStringAsFixed(1) ?? 'N/A'
              ),
              _buildMedicalTableCell('mmHg'),
            ],
          ),
          pw.TableRow(
            children: [
              _buildMedicalTableCell('Expected pH'),
              _buildMedicalTableCell(
                (additionalData?['expectedPH'] as double?)?.toStringAsFixed(2) ?? 'N/A'
              ),
              _buildMedicalTableCell(''),
            ],
          ),
        ],
      ),
    );
  }

  static Future<void> _savePDF(pw.Document pdf) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/ABG_Report_$timestamp.pdf');

      await file.writeAsBytes(await pdf.save());

      // Also try to share/print the PDF
      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'ABG_Report_$timestamp.pdf',
      );
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }
}
