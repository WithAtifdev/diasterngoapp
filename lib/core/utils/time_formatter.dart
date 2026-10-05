class TimeFormatter {
  TimeFormatter._();

  static String timeAgo(DateTime dt) {

    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) {
      return 'just now';
    }
    if (diff.inMinutes < 60) {
      final minutes = diff.inMinutes;
      return minutes == 1 ? '1 min ago' : '$minutes mins ago';
    }
    if (diff.inHours < 24) {
      final hours = diff.inHours;
      return hours == 1 ? '1 hr ago' : '$hours hrs ago';
    }
    if (diff.inDays < 7) {
      final days = diff.inDays;
      return days == 1 ? '1 day ago' : '$days days ago';
    }
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  static String formatHHMM(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}