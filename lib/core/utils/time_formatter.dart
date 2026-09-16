class TimeFormatter {
  TimeFormatter._();

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60)  return 'just now';
    if (diff.inMinutes < 60)  return '${diff.inMinutes} min ago';
    if (diff.inHours < 24)    return '${diff.inHours} hr ago';
    if (diff.inDays < 7)      return '${diff.inDays} day(s) ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  static String formatHHMM(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}