/**
 * Validates a zip code.
 */
class ZipCodeValidator {
  /**
   * Validates zip code when it is not null and greater than a given vale, default is 8
   */
  static bool validate(String? zipCode, {int length = 8}) =>
      zipCode != null && zipCode.length == length;
}
