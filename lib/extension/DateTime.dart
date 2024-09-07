import 'package:intl/intl.dart';

var _formatter = DateFormat.yMMMMd();

extension DateTimeEx on DateTime {
  String get format => _formatter.format(this);
}
