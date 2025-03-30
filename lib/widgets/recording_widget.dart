import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:takes/entities/recording.dart';
import 'package:takes/helpers/formatting_helper.dart';
import 'package:takes/widgets/recording_details_modal.dart';

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
  bool _isPlaying = false;

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(DeviceFileSource(widget.recording.path));
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return RecordingDetailsModal(onDelete: widget.onDelete);
          },
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: ListTile(
          leading: IconButton(
            icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
            iconSize: 36,
            color: Theme.of(context).colorScheme.primary,
            onPressed: _togglePlayback,
          ),
          title: Text(widget.recording.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${formatBytesToMegaBytes(widget.recording.sizeBytes)} ${formatSecondsToMmSs(widget.recording.durationSeconds)}'),
        ),
      ),
    );
  }
}