import 'package:intl/intl.dart';

extension DateExtention on DateTime {
  String formatDate(String dateFormat){
    String formattedDate = DateFormat(dateFormat).format(this);
    return formattedDate;
  }
}