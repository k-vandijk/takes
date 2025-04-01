import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:takes/entities/recording.dart';
import 'package:takes/widgets/recording_details_modal.dart';

class RecordingWidget extends StatefulWidget {
  final Recording recording;
  final VoidCallback onDelete;
  final String? label;
  final Color? labelBackgroundColor;
  final Color? labelForegroundColor;

  const RecordingWidget({
    super.key,
    required this.recording,
    required this.onDelete,
    this.label,
    this.labelBackgroundColor,
    this.labelForegroundColor,
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
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        showModalBottomSheet(
          context: context,
          builder: (context) => RecordingDetailsModal(
            recording: widget.recording,
            onDelete: widget.onDelete,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Stack(
          children: [
            ListTile(
              leading: IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                ),
                iconSize: 36,
                color: Theme.of(context).colorScheme.tertiary,
                onPressed: _togglePlayback,
              ),
              title: Text(widget.recording.name, style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(
                '${(widget.recording.sizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB • ${(widget.recording.durationSeconds / 60).toStringAsFixed(2)} min',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            if (widget.label != null)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.labelBackgroundColor ?? Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.label!,
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.labelForegroundColor ?? Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}