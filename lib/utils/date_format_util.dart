import 'package:intl/intl.dart';

String standardLongDateFormat(DateTime dateTime) {
  return DateFormat('EEE, MMM yyyy h:mm:ss a').format(dateTime);
}
