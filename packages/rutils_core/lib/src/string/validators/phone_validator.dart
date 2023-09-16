class PhoneValidator {
  static String normalize(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }

    return value.replaceAll(RegExp('[^0-9]'), '');
  }

  static bool validate(String? phone, {int length = 11}) =>
      phone != null && normalize(phone).length == length;
}
