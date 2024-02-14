import '../consts/consts.dart';

class Time {
  static String getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'jan';
      case 2:
        return 'feb';
      case 3:
        return 'mar';
      case 4:
        return 'apr';
      case 5:
        return 'may';
      case 6:
        return 'jun';
      case 7:
        return 'jul';
      case 8:
        return 'aug';
      case 9:
        return 'sep';
      case 10:
        return 'oct';
      case 11:
        return 'nov';
      case 12:
        return 'dec';
    }
    return 'NA';
  }

  static String getActiveLastTime(BuildContext context, String lastTime) {
    final int i = int.tryParse(lastTime) ?? -1;
    if (i == -1) {
      return "last seen not available";
    }
    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (now.day == time.day &&
        now.month == time.month &&
        now.year == time.year) {
      return TimeOfDay.fromDateTime(time).format(context);
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return "Last seen today \nat $formattedTime";
    }
    String month = getMonth(time);
    return "Last seen on\n${time.day} $month on $formattedTime";
  }

 static String getCreatedTime(BuildContext context, String time) {
    final DateTime sendTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sendTime.day &&
        now.month == sendTime.month &&
        now.year == sendTime.year) {
      return TimeOfDay.fromDateTime(sendTime).format(context);
    }
    return '${sendTime.day} ${getMonth(sendTime)} ${sendTime.year}';
  }

  static String getTime(context, String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
  static getReadTime(context, String time){
    final DateTime sendTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sendTime.day &&
        now.month == sendTime.month &&
        now.year == sendTime.year) {
      return TimeOfDay.fromDateTime(sendTime).format(context);
    }
    return '${sendTime.day} ${getMonth(sendTime)} ${sendTime.year}';
  }
}
