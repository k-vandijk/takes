import 'package:flutter/material.dart';

class Recording {
  final String id;
  final DateTime date;
  String name;
  final String path;
  final double durationSeconds;
  final int sizeBytes;
  String? label;
  Color? labelBackgroundColor;
  Color? labelForegroundColor;

  Recording({
    required this.name,
    required this.path,
    required this.durationSeconds,
    required this.sizeBytes,
    this.label,
    this.labelBackgroundColor,
    this.labelForegroundColor,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString(),
       date = DateTime.now();

  Recording.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        path = json['path'] as String,
        date = DateTime.parse(json['date'] as String),
        durationSeconds = (json['durationSeconds'] as num).toDouble(),
        sizeBytes = json['sizeBytes'] as int,
        label = json['label'] as String?,
        labelBackgroundColor = json['labelBackgroundColor'] != null ? Color(json['labelBackgroundColor'] as int) : null,
        labelForegroundColor = json['labelForegroundColor'] != null ? Color(json['labelForegroundColor'] as int) : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'date': date.toIso8601String(),
      'durationSeconds': durationSeconds,
      'sizeBytes': sizeBytes,
      'name': name,
      'label': label,
      'labelBackgroundColor': labelBackgroundColor?.value,
      'labelForegroundColor': labelForegroundColor?.value,
    };
  }
}