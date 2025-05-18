import 'dart:ui';

/** 
 * Get the value of a enum as string, example:
 * TransactionType.Buy -> "Buy"
*/
String enumToString(Object enumValue) => enumValue.toString().split('.').last;

/**
 * Parse string to a given enum type.
 */
T enumFromString<T>({
  required Iterable<T> values,
  required String? string,
  required T defaultValue,
}) =>
    string == null || string.isEmpty
        ? defaultValue
        : values.firstWhere((type) => type.toString().split('.').last == string,
            orElse: () => defaultValue);

/**
 * Call parse function if the given json is not null and not empty.
 * Or else, throws [FormatException]
 */
T doParseJsonOrThrow<T>({
  required Map<String, dynamic>? json,
  required T Function(Map<String, dynamic>) parse,
}) =>
    json != null && json.isNotEmpty
        ? parse(json)
        : throw const FormatException('The given json is empty');

/// Call parse function if the given json is not null and not empty
/// or call exit function.
T? doParseOrExit<T>({
  String? string,
  T Function(String)? parse,
  T Function()? exit,
}) =>
    string != null && string.isNotEmpty ? parse?.call(string) : exit?.call();

/// Try to parse the argument to a given T type. Throw [FormatException] if it
/// fails.
T getArgsOrThrow<T>(Object? arguments) {
  if (arguments == null) {
    throw const FormatException('The given argument is null');
  }

  return arguments as T;
}

/// Try to parse the argument to a given T type. Return null if it fails.
T? tryToGetArgsOrIgnore<T>(Object? arguments) {
  if (arguments != null) {
    return arguments as T;
  }

  return null;
}

/// Return the given [value] if it is not null. Otherwise, return the given
/// [fallback] value.
String getSafeText({
  required String fallback,
  String? value,
}) =>
    (value != null && value.isNotEmpty) ? value : fallback;

/// Return true if the given [value] is null. Otherwise, return false.
bool isNull(Object? value) => value == null;

/// Return true if the given [value] is not null. Otherwise, return false.
bool isNotNull(Object? value) => value != null;

/// Return the given [value] with the first letter capitalized.
String capitalize(String value) =>
    '${value[0].toUpperCase()}${value.substring(1)}';

/// Return the given [value] with the first letter of each word capitalized.
String capitalizeFirstLeetOfEachWord(String value) => !value.isNotEmpty
    ? ''
    : value.toLowerCase().split(' ').map((word) {
        final leftWord =
            (word.length > 1) ? word.substring(1, word.length) : '';
        return word[0].toUpperCase() + leftWord;
      }).join(' ');

/// Return a color from a hex code string, of the format #RRGGBB.
Color hexToColor(String code) =>
    Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
