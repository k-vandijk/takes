import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:takes/helpers/notifications_helper.dart';

class Recording {
  final String path;
  final DateTime dateTime;

  Recording({required this.path, required this.dateTime});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final record = AudioRecorder();
  bool isRecording = false;
  List<Recording> recordings = [];

  Future<void> _startRecording () async {
    if (await record.hasPermission()) {
      final Directory dir = await getApplicationDocumentsDirectory();
      final String rndFilename = DateTime.now().millisecondsSinceEpoch.toString();
      final String path = p.join(dir.path, '$rndFilename.wav');
      await record.start(const RecordConfig(), path: path);
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
    final String filename = p.basename(path);
    final String dateTime = DateTime.now().toString();
    final Recording recording = Recording(path: path, dateTime: DateTime.parse(dateTime));
    setState(() {
      recordings.add(recording);
    });
    showSnackbar(context, 'Recording saved: $filename');
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
              return ListTile(
                title: Text(recording.path),
                subtitle: Text(recording.dateTime.toString()),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      recordings.removeAt(index);
                    });
                    showSnackbar(context, 'Recording deleted');
                  },
                ),
              );
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(isRecording ? Icons.stop : Icons.mic), 
            iconSize: 32,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () async {
              if (isRecording) {
                await _stopRecording();
              } else {
                await _startRecording();
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
