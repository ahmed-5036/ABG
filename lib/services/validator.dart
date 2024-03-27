import 'logger.dart';

class Validator {
  Validator._();

  static bool validateSaudiMobileNumber(String mobileNumber) {
    final RegExp regExp = RegExp(
      r"^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$",
    );
    final bool isValid = regExp.hasMatch(mobileNumber);
    return isValid;
  }

  static bool validateEgyptianMobileNumber(String? value) {
    Pattern pattern = r'^01[0-2,5]{1}[0-9]{8}$';
    RegExp regex = RegExp(pattern as String);
    return (!regex.hasMatch(value!)) ? false : true;
  }

  static bool validateSaudiIBAN(String iban) {
    iban = iban.replaceAll(" ", "");
    final RegExp regExp = RegExp(
        r"[a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{4}[0-9]{7}([a-zA-Z0-9]?){0,16}"
        // r"^(?:(?:IT|SM)\d{2}[A-Z]\d{22}|CY\d{2}[A-Z]\d{23}|NL\d{2}[A-Z]{4}\d{10}|LV\d{2}[A-Z]{4}\d{13}|(?:BG|BH|GB|IE)\d{2}[A-Z]{4}\d{14}|GI\d{2}[A-Z]{4}\d{15}|RO\d{2}[A-Z]{4}\d{16}|KW\d{2}[A-Z]{4}\d{22}|MT\d{2}[A-Z]{4}\d{23}|NO\d{13}|(?:DK|FI|GL|FO)\d{16}|MK\d{17}|(?:AT|EE|KZ|LU|XK)\d{18}|(?:BA|HR|LI|CH|CR)\d{19}|(?:GE|DE|LT|ME|RS)\d{20}|IL\d{21}|(?:AD|CZ|ES|MD|SA)\d{22}|PT\d{23}|(?:BE|IS)\d{24}|(?:FR|MR|MC)\d{25}|(?:AL|DO|LB|PL)\d{26}|(?:AZ|HU)\d{27}|(?:GR|MU)\d{28})$"
        // r"^[A-Z]\d{4}[A-Z0-9]{18}$",
        // r"^[A-Z]{2}(?:[ ]?[0-9]){18,20}$"
        );
    final bool isValid = regExp.hasMatch(iban);
    return isValid;
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern as String);
    return (!regex.hasMatch(value)) ? false : true;
  }

  static bool isShortPassword(String? password, {int maxLength = 6}) {
    return password?.isEmpty == true || (password?.length ?? 0) < maxLength;
  }

  static bool isResetPasswordCode(String password, {int maxLength = 5}) {
    if (password.isEmpty) {
      return false;
    }
    if (password.length != maxLength) {
      return false;
    }
    return true;
  }

  static String? matchesOriginalPassowrd(
      String? newPassword, String? rePassword,
      [String? oldPassword]) {
    if (newPassword == null || rePassword == null) return "";

    if (rePassword.trim().isEmpty == true) {
      return "Empty password";
    } else if (rePassword.length < 6) {
      return "Short password";
    } else if (newPassword != rePassword) {
      LogManager.logToConsole(
          "password:$newPassword,and confirm password:$rePassword");
      return "Confirm password doesn't match password";
    }
    if (oldPassword != null && oldPassword.isNotEmpty) {
      if (oldPassword.trim() == newPassword.trim()) {
        return "New password should be different than old password";
      }
    }
    return null;
  }

  static String? validateText(String? text,
      {String? errorMsg = "Invalid Text", int maxLength = 3}) {
    if (text == null) return "";
    return text.isEmpty || text.length < maxLength ? errorMsg : null;
  }

  static String? isPasswordMatchingConfirm(
    String? password,
    String? confirmPassword,
  ) {
    if (password == null || confirmPassword == null) return null;

    if (confirmPassword.trim().isEmpty == true) {
      return "Empty password";
    } else if (confirmPassword.length < 6) {
      return "Short password";
    } else if (password != confirmPassword) {
      LogManager.logToConsole(
          "password:$password,and confirm password:$confirmPassword");
      return "Confirm password doesn't match password";
    }

    return null;
  }
}
