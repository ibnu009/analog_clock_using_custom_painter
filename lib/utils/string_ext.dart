import 'package:intl/intl.dart';

extension StringExtention on String? {
  String toDateFormat(String dateFormat){
    String date = this ?? DateTime.now().toString();

    DateTime dateTime = DateTime.parse(date);
    String result = DateFormat(dateFormat).format(dateTime);
    return result;
  }
}