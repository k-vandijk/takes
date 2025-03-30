import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:takes/config.dart' as config;
import 'package:takes/entities/recording.dart';
import 'package:takes/helpers/notifications_helper.dart';
import 'package:takes/providers/recordings_provider.dart';
import 'package:takes/widgets/recorder_button_widget.dart';
import 'package:takes/widgets/recording_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final record = AudioRecorder();
  bool isRecording = false;

  Future<Duration?> _getAudioDuration(String filePath) async {
    final audioPlayer = AudioPlayer();
    try {
      await audioPlayer.setFilePath(filePath);
      return audioPlayer.duration;
    } catch (e) {
      return null;
    } finally {
      await audioPlayer.dispose();
    }
  }

  Future<void> _saveRecording(String path) async {
    final duration = await _getAudioDuration(path);
    final size = await File(path).length();
    final recording = Recording(
      path: path,
      durationSeconds: duration?.inSeconds.toDouble() ?? 0.0,
      sizeBytes: size,
    );
    await Provider.of<RecordsProvider>(context, listen: false)
        .addRecording(recording);
  }

  void _onDeleteRecording(Recording recording) {
    final file = File(recording.path);
    if (file.existsSync()) {
      // ignore: invalid_return_type_for_catch_error
      file.delete().catchError((e) => print('Error deleting file: $e'));
    }
    Provider.of<RecordsProvider>(context, listen: false)
        .removeRecording(recording);
  }

  Future<void> startRecording() async {
    if (await record.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final filename = DateTime.now().millisecondsSinceEpoch.toString();
      final path = p.join(directory.path, '$filename.wav');
      await record.start(config.recordConfigLow, path: path);
      setState(() => isRecording = true);
    } else {
      showErrorSnackBar(context);
    }
  }

  Future<void> stopRecording() async {
    setState(() => isRecording = false);
    final path = await record.stop();
    if (path == null) {
      showErrorSnackBar(context);
      return;
    }
    _saveRecording(path);
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Consumer<RecordsProvider>(
              builder: (context, recordsProvider, child) {
                final recordings = recordsProvider.recordings;
                return ListView.builder(
                  itemCount: recordings.length,
                  itemBuilder: (context, index) {
                    final recording = recordings[index];
                    return RecordingWidget(
                      recording: recording,
                      onDelete: () => _onDeleteRecording(recording),
                    );
                  },
                );
              },
            ),
          ),
          RecorderButtonWidget(
            onStartRecording: startRecording,
            onStopRecording: stopRecording,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
