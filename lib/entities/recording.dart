class Recording {
  final String id;
  final DateTime date;
  final String name;
  final String path;
  final double durationSeconds;
  final int sizeBytes;

  Recording({
    required this.name,
    required this.path,
    required this.durationSeconds,
    required this.sizeBytes,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString(),
       date = DateTime.now();

  Recording.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
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
      'name': name,
    };
  }
}