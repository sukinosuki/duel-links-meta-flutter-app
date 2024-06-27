import 'package:intl/intl.dart';

class TimeUtil {
  static final _formatter = DateFormat.yMMMMd();

  static String format(DateTime? time) {
    if (time == null) return '';

    return _formatter.format(time);
  }
}

