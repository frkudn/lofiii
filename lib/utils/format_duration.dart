


class FormatDuration {
  static String format(Duration? duration) {
    if (duration == null) return "00:00"; // Handle null case
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    // Extract hours, minutes, and seconds from duration
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      // If duration is greater than one hour, format with hours
      return "$hours:${twoDigits(minutes)}:${twoDigits(seconds)}";
    } else {
      // If duration is less than one hour, format without hours
      return "${twoDigits(minutes)}:${twoDigits(seconds)}";
    }
  }
}
