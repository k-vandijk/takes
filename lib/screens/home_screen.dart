import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:takes/config.dart' as config;
import 'package:takes/entities/recording.dart';
import 'package:takes/helpers/notifications_helper.dart';
import 'package:takes/helpers/recording_metadata_helper.dart';
import 'package:takes/providers/recordings_provider.dart';
import 'package:takes/widgets/recorder_button_widget.dart';
import 'package:takes/widgets/recording_name_modal.dart';
import 'package:takes/widgets/recording_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final record = AudioRecorder();
  bool isRecording = false;

  Future<void> _saveRecording(String path, String name) async {
    final duration = await getAudioDuration(path);
    final size = await File(path).length();
    final recording = Recording(
      name: name,
      path: path,
      durationSeconds: duration?.inSeconds.toDouble() ?? 0.0,
      sizeBytes: size,
    );
    await Provider.of<RecordsProvider>(
      context,
      listen: false,
    ).addRecording(recording);
  }

  void _onDeleteRecording(Recording recording) {
    _deleteRecording(recording.path);
    Provider.of<RecordsProvider>(
      context,
      listen: false,
    ).removeRecording(recording);
  }

  void _deleteRecording(String path) {
    final file = File(path);
    if (file.existsSync()) {
      // ignore: invalid_return_type_for_catch_error
      file.delete().catchError((e) => print('Error deleting file: $e'));
    }
  }

  Future<void> startRecording() async {
    if (!await record.hasPermission()) {
      showErrorSnackBar(context);
      return;
    }

    setState(() => isRecording = true);
    final directory = await getApplicationDocumentsDirectory();
    final filename = DateTime.now().millisecondsSinceEpoch.toString();
    final path = p.join(directory.path, '$filename.wav');
    await record.start(config.recordConfigLow, path: path);
  }

  Future<void> stopRecording() async {
    setState(() => isRecording = false);

    final path = await record.stop();
    if (path == null) {
      showErrorSnackBar(context);
      return;
    }

    final name = await getRecordingName(context);
    if (name == null) {
      _deleteRecording(path);
      return;
    }

    _saveRecording(path, name);
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Consumer<RecordsProvider>(
            builder: (context, recordsProvider, child) {
              final recordings = recordsProvider.recordings;
              return ListView.builder(
                itemCount: recordings.length,
                itemBuilder: (context, index) {
                  final recording = recordings[index];
                  return RecordingWidget(
                    recording: recording,
                    onDelete: () => _onDeleteRecording(recording),
                    label: recording.label,
                    labelBackgroundColor: recording.labelBackgroundColor,
                    labelForegroundColor: recording.labelForegroundColor,
                  );
                },
              );
            },
          ),
          Align(
            alignment: const Alignment(0.0, 0.90),
            child: RecorderButtonWidget(
              onStartRecording: startRecording,
              onStopRecording: stopRecording,
            ),
          ),
        ],
      ),
    );
  }
}