import 'package:email_validator/email_validator.dart';

class Validators {
// TODO localize the messages
  static String? validateEmailAddress(String? email) {
    if (email == null || email.isEmpty) {
      return "Field is required";
    }

    if (!EmailValidator.validate(email)) {
      return "Enter a vaild email";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Field is required";
    }

    if (password.length < 6) {
      return "Enter min. 6 characters";
    }
    return null;
  }

  static String? validateStudentName(String? name) {
    if (name == null || name.isEmpty) {
      return "Name is required";
    }
    return null;
  }

  static String? validateParentPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return "Phone number is required";
    }

    if (phoneNumber.length != 10) {
      return "Enter a valid 10-digit phone number";
    }

    return null;
  }
}
