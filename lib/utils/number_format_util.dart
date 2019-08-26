import 'package:intl/intl.dart';

String standardNumberFormat(double value) {
  return new NumberFormat('#,###.##').format(value);
}
