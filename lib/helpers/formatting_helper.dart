String formatBytesToMegaBytes(int bytes) {
  if (bytes <= 0) return '0 MB';
  final double megabytes = bytes / (1024 * 1024);
  return '${megabytes.toStringAsFixed(2)} MB';
}

String formatSecondsToMmSs(double seconds) {
  int totalSeconds = seconds.round();
  final int minutes = totalSeconds ~/ 60;
  final int remainingSeconds = totalSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
}
