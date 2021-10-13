import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  String convertDate() {
    return DateFormat('d MMM yyyy').format(this);
  }
}
