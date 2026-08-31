class Validator {
  bool checkEmptyString(String value) {
    return value.isEmpty;
  }

  bool idValidMobile(String value) {
    return value.length != 10;
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Test the email against the regular expression
    return emailRegex.hasMatch(email);
  }

}
