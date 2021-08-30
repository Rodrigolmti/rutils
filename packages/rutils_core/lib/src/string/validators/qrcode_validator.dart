class QrcodeValidator {
  static bool validate(String? code) => code != null && code.length == 138;
}
