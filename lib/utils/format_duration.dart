import 'package:intl/intl.dart';

String formatDuration(int milliseconds) {
  final duration = Duration(milliseconds: milliseconds);
  final formatter = DateFormat('HH:mm:ss');

  return formatter
      .format(DateTime(0, 0, 0, 0, 0, 0, 0, 0).add(duration).toLocal());
}
