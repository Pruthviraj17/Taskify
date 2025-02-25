import 'package:audioplayers/audioplayers.dart';

Future<void> playDingNotificationSound() async {
  try {
    final audioPath = 'audio/Flick.mp3';
    final player = AudioPlayer();
    // player.stop();
    await player.play(AssetSource(audioPath));
  } catch (error) {
    print("Ding Sound Exception: ${error.toString()}");
  }
}
