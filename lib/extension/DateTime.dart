import '../util/time_util.dart';

extension DateTimeEx on DateTime {
  String get format => TimeUtil.format(this); // 扩展方法
}