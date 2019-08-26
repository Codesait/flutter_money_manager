import 'package:intl/intl.dart';

String standardLongDateFormat(DateTime date) {
  return DateFormat('EEE, MMM yyyy h:mm:ss a').format(date);
}

String standardHourAndMinuteFormat(DateTime date) {
  return DateFormat('h:mm a').format(date);
}
