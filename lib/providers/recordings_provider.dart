import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takes/entities/recording.dart';

class RecordsProvider extends ChangeNotifier {
  List<Recording> _recordings = [];

  List<Recording> get recordings => _recordings;

  RecordsProvider() {
    _loadRecordings();
  }

  Future<void> _loadRecordings() async {
    _recordings = await _getRecordings();
    notifyListeners();
  }

  Future<void> addRecording(Recording recording) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _recordings.add(recording);
      final List<String> recordingsJson = _recordings.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList('recordings', recordingsJson);
      notifyListeners();
    } catch (e) {
      print('Error saving recording: $e');
    }
  }

  Future<void> removeRecording(Recording recording) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _recordings.remove(recording);
      final List<String> recordingsJson = _recordings.map((r) => jsonEncode(r.toJson())).toList();
      await prefs.setStringList('recordings', recordingsJson);
      notifyListeners();
    } catch (e) {
      print('Error removing recording: $e');
    }
  }

  Future<List<Recording>> _getRecordings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> recordingsJson = prefs.getStringList('recordings') ?? [];
      return recordingsJson.map((json) {
        final Map<String, dynamic> data = jsonDecode(json);
        return Recording.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error loading recordings: $e');
      return [];
    }
  }
}
