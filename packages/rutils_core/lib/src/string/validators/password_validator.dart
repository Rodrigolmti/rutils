const _pattern = r'([0-9])\1+';
final _regex = RegExp(_pattern);

const _sequencePattern = r'([0-9])\1+';
final _sequenceRegex = RegExp(_sequencePattern);

/**
 * Validates password
 */
class PasswordValidator {
  /**
   * Validates password when it is not null and greater than 0
   */
  static bool validate(String? password, {int length = 6}) =>
      password != null &&
      password.length >= length &&
      !_regex.hasMatch(password);

  /**
   * Validates password when it is not null and greater than 0
   */
  static bool match(String? password, String? confirm) => password == confirm;

  /**
   * Validates password when it is not a sequence
   */
  static bool isNumberSequence(String? password) =>
      _sequenceRegex.hasMatch(password ?? '');
}
