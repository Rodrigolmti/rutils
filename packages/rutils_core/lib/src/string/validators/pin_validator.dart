const _pattern = '([0-9]){6}';
final _regex = RegExp(_pattern);

class PinValidator {
  static bool validate(String? code) => code != null && code.length == 6;

  static bool isPossibleCode(String? value) =>
      value != null && _regex.hasMatch(value);
}
