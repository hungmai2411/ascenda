import 'package:intl/intl.dart';

DateTime convertDate(String date) {
  return DateFormat('yyyy-MM-dd').parse(date);
}
