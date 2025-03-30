import 'package:just_audio/just_audio.dart';

Future<Duration?> getAudioDuration(String filePath) async {
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