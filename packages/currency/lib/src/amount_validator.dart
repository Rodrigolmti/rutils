/**
 * Validates amount
 */
class AmountValidator {
  /**
   * Validates amount when it is not null and greater than 0
   */
  static bool validate(double? amount) => amount != null && amount > 0;
}
