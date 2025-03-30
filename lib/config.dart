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
