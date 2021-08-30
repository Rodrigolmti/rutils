const _pattern = r'([0-9])\1+';
final _regex = RegExp(_pattern);

const _sequence1 = '123456';
const _sequence2 = '012345';
const _sequence3 = '654321';
const _sequence4 = '543210';

class PasswordValidator {
  static bool validate(String? password) =>
      password != null && password.length >= 6 && !_regex.hasMatch(password);

  static bool match(String? password, String? confirm) => password == confirm;

  static bool isNumberSequence(String? password) =>
      password == _sequence1 ||
      password == _sequence2 ||
      password == _sequence3 ||
      password == _sequence4;
}
