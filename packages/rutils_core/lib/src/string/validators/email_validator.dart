const _patternLc =
    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
const _patternUc =
    r"[A-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Z0-9](?:[A-Z0-9-]*[A-Z0-9])?\.)+[A-Z0-9](?:[A-Z0-9-]*[A-Z0-9])?";

final _regexLc = RegExp(_patternLc);
final _regexUp = RegExp(_patternUc);

class EmailValidator {
  static bool validate(String? email) =>
      _regexLc.hasMatch(email ?? '') || _regexUp.hasMatch(email ?? '');
  static bool confirm(String? email, String? confirm) => email == confirm;
}
