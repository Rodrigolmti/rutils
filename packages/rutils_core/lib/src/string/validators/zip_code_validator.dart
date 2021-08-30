class ZipCodeValidator {
  static bool validate(String? zipCode) =>
      zipCode != null && zipCode.length == 8;
}
