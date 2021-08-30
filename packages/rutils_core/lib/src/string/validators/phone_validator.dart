class PhoneValidator {
  static String normalize(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }

    return value.replaceAll(RegExp('[^0-9]'), '');
  }

  static bool validate(String? phone) =>
      phone != null && normalize(phone).length == 11;
}
