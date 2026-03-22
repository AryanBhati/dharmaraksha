class AppFormatters {
  static String inr(num value) => '\u20B9${value.toStringAsFixed(0)}';

  static String rating(double rating, int reviews) {
    return '${rating.toStringAsFixed(1)} ($reviews)';
  }

  static String shortDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year  $hour:$minute';
  }
}
