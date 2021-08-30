class DateValidator {
  static bool validate(String date) =>
      _DateHelper.isDateValid(date, 'dd/MM/yyyy');
}

class _DateHelper {
  static bool isDateValid(String? date, String format) {
    try {
      if (date == null) {
        return false;
      }

      int? day, month, year;

      final String? separator =
          RegExp('([-/.])').firstMatch(date)?.group(0)?[0];
      if (separator == null) {
        return false;
      }

      final frSplit = format.split(separator);

      final dtSplit = date.split(separator);

      for (int i = 0; i < frSplit.length; i++) {
        final frm = frSplit[i].toLowerCase();
        final vl = dtSplit[i];

        if (frm == 'dd') {
          day = int.parse(vl);
        } else if (frm == 'mm') {
          month = int.parse(vl);
        } else if (frm == 'yyyy') {
          year = int.parse(vl);
        }
      }

      if (day == null || month == null || year == null) {
        return false;
      }

      final now = DateTime.now();
      if (month > 12 ||
          month < 1 ||
          day < 1 ||
          day > daysInMonth(month, year) ||
          year < 1810 ||
          (year > now.year && day > now.day && month > now.month)) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static int daysInMonth(int month, int year) {
    final days = 28 +
        (month + (month / 8).floor()) % 2 +
        2 % month +
        2 * (1 / month).floor();
    return (isLeapYear(year) && month == 2) ? 29 : days;
  }

  static bool isLeapYear(int year) =>
      (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
}
