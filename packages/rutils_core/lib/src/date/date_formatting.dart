import 'package:intl/intl.dart';

/// Format a dateTime with the given dateFormat
String formatDateTime(DateTime date, DateFormat dateFormat) =>
    dateFormat.format(date);
