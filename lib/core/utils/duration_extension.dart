extension DurationExtensions on Duration {
  String toHumanReadable() {
    int hours = inHours;
    int minutes = inMinutes.remainder(60);
    int seconds = inSeconds.remainder(60);

    List<String> parts = [];

    if (hours > 0) parts.add('$hours hr${hours > 1 ? 's' : ''}');
    if (minutes > 0) parts.add('$minutes min${minutes > 1 ? 's' : ''}');
    if (seconds > 0) parts.add('$seconds sec${seconds > 1 ? 's' : ''}');

    return parts.isNotEmpty ? parts.join(' ') : '0 sec';
  }
}
