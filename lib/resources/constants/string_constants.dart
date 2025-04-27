class StringConstants {
  StringConstants._();
  //[old naming changed on => 17/1/2024 draglan request]
  // static const String patientTypeOne = "Started with normal AG ";
  static const String patientTypeOne = "Started with normal AG ";
  static const String patientTypeOneDetails =
      "(vomiting, diarrhea, RTA, normal metabolic state) then developed high AG changes (shock, DKA, uremia)";
  static const String patientTypeOneDetailsPartOneOfThree =
      "(vomiting, diarrhea, RTA, normal metabolic state)";
  static const String patientTypeOneDetailsPartTwoOfThree =
      " then developed high AG changes ";
  static const String patientTypeOneDetailsPartThreeOfThree =
      "(shock, DKA, uremia)";
  static const String patientTypeTwo = "Started with high AG ";
  // static const String patientTypeTwoDetails =
  //     "(shock, DKA, uremia) then or normal metabolic state then developed normal AG changes (vomiting, diarrhea)";
  static const String patientTypeTwoDetails =
      "(shock, DKA, uremia) then developed Normal AG changes (vomiting, diarrhea,NGT drainage)";
  static const String patientTypeTwoDetailsPartOneOfThree =
      "(shock, DKA, uremia)";
  static const String patientTypeTwoDetailsPartTwoOfThree =
      " then developed Normal AG changes ";
  static const String patientTypeTwoDetailsPartThreeOfThree =
      "(vomiting, diarrhea,NGT drainage)";
  // Follow Up ABG Option Constants
  static const String followUpAbgTitle = "Follow Up ABG Options";
  static const String followUpAbgSubtitle = "Select the Primary Insult Type";

  static const String primaryMetabolicInsultTitle = "Primary Metabolic Insult";
  static const String primaryMetabolicInsultDescription =
      "Metabolic changes that primarily originate from metabolic processes";

  static const List<String> primaryMetabolicInsultExamples = [
    'Metabolic Acidosis',
    'Metabolic Alkalosis',
    'Normocarbia',
    'Hypochloremia',
  ];

  static const String primaryRespiratoryInsultTitle =
      "Primary Respiratory Insult";
  static const String primaryRespiratoryInsultDescription =
      "Respiratory changes that primarily affect acid-base balance through ventilation";

  static const List<String> primaryRespiratoryInsultExamples = [
    'Respiratory Acidosis',
    'Respiratory Alkalosis',
    'Hypoventilation',
    'Hyperventilation'
  ];

  // New COPD Option Constants
  static const String copdOptionOneTitle = "Normal AG to High AG";
  static const String copdOptionOneDescription =
      "Patient started with normal AG (vomiting, diarrhea, RTA, normal metabolic state) "
      "then developed high AG changes (shock, DKA, uremia) with COPD";

  static const List<String> copdNormalAgExamples = [
    'Vomiting',
    'Diarrhea',
    'RTA (Renal Tubular Acidosis)',
    'Normal Metabolic State'
  ];

  static const List<String> copdHighAgExamples = [
    'Shock',
    'Diabetic Ketoacidosis (DKA)',
    'Uremia'
  ];

  static const String copdOptionTwoTitle = "High AG to Normal AG";
  static const String copdOptionTwoDescription =
      "Patient started with high AG (shock, DKA, uremia) or normal metabolic state "
      "then developed normal AG changes (vomiting, diarrhea) with COPD";
  static const String selectPatient = "Select patient type";
  // static const String fromHistory = "(From History)";
  static const String fromHistory = "From History";
  static const String selectModule =
      "Select the module of the sequential metabolic changes";
  static const String resetAllInputs = "Reset All Inputs Form";
  static const String resetAnalysis = "Reset Analysis for new patient";
  static const String newPatient = "New Patient";
  static const String back = "Back";
  static const String contactUs = "Contact Us";
  static const String website = "Website";
  static const String measurement = "Measurement";
  static const String youtubeChannel = "Youtube Channel";
  static const String goBack = "Go Back to Analysis page";
  static const String analysis = "Analysis";
  static const String calculate = "Calculate";
  static const String aboutUs = "About Us";
  static const String items = "Items";
  static const String value = "Value";
  static const String measuredData = "Measured Data";
  static const String definitions = "Definitions";
  static const String definition = "Definition";
  static const String resetNow = "Reset Now!";
  static const String resutls = "Results";
  static const String finalDiagnosis = "Final Diagnosis";
  static const String drAglanTitleDesc =
      "Dr Ahmed Aglan Professor Emeritus in critical care department Faculty of Medicine Alexandria university";
  static const String startCollectingNewData =
      "You will start collecting new data for analysis and the current data will be lost!";
  static const String startAnalysisForNewPatient =
      "Start Analysis for new patient";
  static const String close = "Close";
  static const String clNa = "CL/NA";
  static const String correctedCl = "Corrected CL";
  static const String sid = "SID mEq/L";
  static const String correctedAgStart = "Corrected AG Start";
  static const String correctedHCO3 = "Corrected HCO3";
}
