class Recording {
  final String id;
  final String path;
  final DateTime date;
  final double durationSeconds;
  final int sizeBytes;

  Recording({
    required this.path,
    required this.durationSeconds,
    required this.sizeBytes,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString(),
       date = DateTime.now();

  Recording.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        path = json['path'] as String,
        date = DateTime.parse(json['date'] as String),
        durationSeconds = (json['durationSeconds'] as num).toDouble(),
        sizeBytes = json['sizeBytes'] as int;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'date': date.toIso8601String(),
      'durationSeconds': durationSeconds,
      'sizeBytes': sizeBytes,
    };
  }
}