const _pattern =
    // ignore: lines_longer_than_80_chars
    '([A-Za-z]{3,} )([A-Za-z]{2,} )?([A-Za-z]{2,} )?([A-Za-z]{2,} )?([A-Za-z]{2,})';
final _regex = RegExp(_pattern);

class NameValidator {
  static bool validateFullName(String? name) => _regex.hasMatch(name ?? '');

  static bool validateSocialName(String? name) =>
      name != null && name.length >= 3;
}
