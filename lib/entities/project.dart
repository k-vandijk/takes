import 'package:takes/entities/recording.dart';

class Project {
  final String id;
  final DateTime createdAt;
  final String name;
  final String? description;
  final List<Recording> recordings;

  Project({
    required this.name,
    this.description,
    List<Recording>? recordings,
  }) : recordings = recordings ?? [],
      id = DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt = DateTime.now();

  Project.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        createdAt = DateTime.parse(json['createdAt'] as String),
        name = json['name'] as String,
        description = json['description'] as String?,
        recordings = (json['recordings'] as List<dynamic>? ?? [])
            .map((e) => Recording.fromJson(e as Map<String, dynamic>))
            .toList();
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'name': name,
      'description': description,
      'recordings': recordings.map((e) => e.toJson()).toList(),
    };
  }
}