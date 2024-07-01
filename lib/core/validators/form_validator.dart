import 'package:email_validator/email_validator.dart';
import 'package:ez_english/resources/app_strings.dart';

class Validators {
  static String? validateEmailAddress(String? email) {
    if (email == null || email.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (!EmailValidator.validate(email)) {
      return AppStrings.enterValidEmail;
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (password.length < 6) {
      return AppStrings.passwordLength;
    }
    return null;
  }

  static String? validateStudentName(String? name) {
    if (name == null || name.isEmpty) {
      return AppStrings.nameRequired;
    }
    return null;
  }

  static String? validateParentPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return AppStrings.phoneRequired;
    }

    if (phoneNumber.length != 10) {
      return AppStrings.phoneLength;
    }

    return null;
  }
}
