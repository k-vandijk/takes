import 'package:flutter/material.dart';
import 'package:record/record.dart';

final RecordConfig recordConfigHigh = const RecordConfig(
  encoder: AudioEncoder.wav,
  bitRate: 1411000,
  sampleRate: 44100,
);

final RecordConfig recordConfigMedium = const RecordConfig(
  encoder: AudioEncoder.wav,
  bitRate: 96000,
  sampleRate: 44100,
);

final RecordConfig recordConfigLow = const RecordConfig(
  encoder: AudioEncoder.wav,
  bitRate: 96000,
  sampleRate: 16000,
);

List<Color> labelColors = [
  Colors.teal,
  Colors.indigo,
  Colors.amber,
  Colors.cyan,
  Colors.deepOrange,
  Colors.pinkAccent,
];
