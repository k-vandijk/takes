import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:takes/entities/recording.dart';
import 'package:takes/helpers/notifications_helper.dart';
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
  List<Recording> recordings = [];

  final RecordConfig config = const RecordConfig(
    encoder: AudioEncoder.wav,
    bitRate: 1411000,
    sampleRate: 44100,
  );

  Future<void> _startRecording () async {
    if (await record.hasPermission()) {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String filename = DateTime.now().millisecondsSinceEpoch.toString();
      final String path = p.join(dir.path, '$filename.wav');
      await record.start(config, path: path);
      setState(() => isRecording = true);
    } else {
      showErrorSnackBar(context);
    }
  }

  Future<void> _stopRecording () async {
    setState(() => isRecording = false);
    final path = await record.stop();
    if (path == null) {
      showErrorSnackBar(context);
      return;
    }
    _saveRecording(path);
  }

  void _saveRecording (String path) {
    final String dateTime = DateTime.now().toString();
    final Recording recording = Recording(path: path, dateTime: DateTime.parse(dateTime));
    setState(() {
      recordings.add(recording);
    });
  }

  void _onDeleteRecording(Recording recording) {
    final File file = File(recording.path);
    if (file.existsSync()) {
      file.deleteSync();
    }
    setState(() {
      recordings.removeWhere((r) => r.path == recording.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: recordings.length,
            itemBuilder: (context, index) {
              final recording = recordings[index];
              return RecordingWidget(recording: recording, onDelete: () => _onDeleteRecording(recording));
            },
          ),
          const Spacer(),
          RecorderButtonWidget(
            onStartRecording: () => _startRecording(), 
            onStopRecording: () => _stopRecording(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
