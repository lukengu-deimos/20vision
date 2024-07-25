import 'package:intl/intl.dart';

String formatTimestamp(int timestamp) {
  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  final DateFormat formatter = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ");
  return formatter.format(dateTime);
}

String formatTimestampForAlert(int timestamp) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  // Format the DateTime to the desired format
  String formattedDate = DateFormat('dd MMM yyyy HH:mm').format(dateTime);
  return formattedDate;

}

