extension DateTimeExtension on String? {
  DateTime toDateTime() {
    return DateTime.parse(this!);
  }

  String toFormattedDate() {
    if (this == null || this!.isEmpty) return '';
    DateTime dateTime = toDateTime();
    return '${padWithZero(dateTime.day)}/${padWithZero(dateTime.month)}/${dateTime.year} ${padWithZero(dateTime.hour)}:${padWithZero(dateTime.minute)}';
  }
}

String padWithZero(int number) {
  return number.toString().padLeft(2, '0');
}
