import 'package:intl/intl.dart';

String standardDateFormat(DateTime date) {
  return DateFormat('MM/dd/yyyy h:mm a').format(date);
}

String standardTimeFormat(DateTime date) {
  return DateFormat('h:mm a').format(date);
}

String shortDateFormat(DateTime date) {
  return DateFormat('EEE, MMM d, yyyy').format(date);
}

DateTime getDateWithoutTime(DateTime date) {
  return new DateTime(date.year, date.month, date.day);
}
