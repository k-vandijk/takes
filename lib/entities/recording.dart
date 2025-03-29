class Recording {
  final String path;
  final DateTime dateTime;

  Recording({required this.path, required this.dateTime});

  Map<String, dynamic> toJson() => {
    'path': path,
    'dateTime': dateTime.toIso8601String(),
  };

  factory Recording.fromJson(Map<String, dynamic> json) => Recording(
    path: json['path'] as String,
    dateTime: DateTime.parse(json['dateTime'] as String),
  );
}
