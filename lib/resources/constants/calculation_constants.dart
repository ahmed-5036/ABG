class CalculationConstants {
  CalculationConstants._();
  static const int hypoValue = -1;
  static const int normalValue = 0;
  static const int hyperValue = 1;
  //K meq/L
  static const double normokalemiaThreshold = 3.5;
  static const double hyperkalemiaThreshold = 5.5;

  //Na meq/L
  static const double normonatremicThreshold = 135;
  static const double hypernatremicThreshold = 145;

  //Albumin g%
  static const double normalAlbuminThreshold = 3.5;
  static const double hyperalbuminemiaThreshold = 4.5;

  //Chlorine me /L
  static const double normochloremicThreshold = 98;
  static const double hyperchloremicThreshold = 108;
  static const double hyperCorrectedchloremicThreshold = 107;
  static const double hypoCorrectedchloremicThreshold = 97;

//HCO3
  static const double normalHCO3Threshold = 24;

  //PH
  static const double normalPhThreshold = 7.4;

  //PCO2 mmHg
  static const double pCo2Threshold = 40;

  //ClNa mmHg
  static const double normalClNaThreshold = 74;

  //SID mEq
  static const double sidNormalThreshold = 40;
  //SID Type 2 mEq
  static const double sidNormalTypeTwoThreshold = 36;

  //corrected A G mEq
  static const double agNormalThreshold = 12;

  static const String noData = "NO DATA";
}
