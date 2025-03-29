import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:takes/entities/recording.dart';
import 'package:takes/helpers/formatting_helper.dart';

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

  Future<void> _togglePlayback() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(widget.recording.path));
    }
    setState(() => isPlaying = !isPlaying);
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() => isPlaying = false);
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: IconButton(
          icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
          iconSize: 36,
          color: Theme.of(context).primaryColor,
          onPressed: _togglePlayback,
        ),
        title: Text(filename, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${formatDate(widget.recording.dateTime.toLocal())} ${formatTime(widget.recording.dateTime.toLocal())}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: widget.onDelete,
        ),
      ),
    );
  }
}
