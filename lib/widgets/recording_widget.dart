import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:takes/entities/recording.dart';
import 'package:takes/helpers/formatting_helper.dart';
import 'package:just_audio/just_audio.dart' as ja;

class RecordingWidget extends StatefulWidget {
  final Recording recording;
  final VoidCallback onDelete;

  const RecordingWidget({
    super.key,
    required this.recording,
    required this.onDelete,
  });

  @override
  State<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  File? recordingFile;
  int? recordingSizeBytes;
  double? recordingLengthSeconds;

  Future<void> _togglePlayback() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(widget.recording.path));
    }
    setState(() => isPlaying = !isPlaying);
  }

  Future<Duration?> _getAudioDuration(String filePath) async {
  final audioPlayer = ja.AudioPlayer();
  try {
    await audioPlayer.setFilePath(filePath);
    return audioPlayer.duration;
  } catch (e) {
    return null;
  } finally {
    await audioPlayer.dispose();
  }
}

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() => isPlaying = false);
    });
    _getAudioDuration(widget.recording.path).then((duration) {
      setState(() {
        recordingLengthSeconds = duration?.inSeconds.toDouble();
        recordingFile = File(widget.recording.path);
        recordingSizeBytes = recordingFile?.lengthSync() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filename = widget.recording.path.split(Platform.pathSeparator).last;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: IconButton(
          icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
          iconSize: 36,
          color: Theme.of(context).primaryColor,
          onPressed: _togglePlayback,
        ),
        title: Text(filename, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${formatBytesToMegaBytes(recordingSizeBytes ?? 0)} ${formatSecondsToMmSs(recordingLengthSeconds ?? 0)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: widget.onDelete,
        ),
      ),
    );
  }
}
