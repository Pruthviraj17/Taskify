import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

Future<void> playDingNotificationSound() async {
  try {
    final audioPath = 'audio/Flick.mp3';
    final player = AudioPlayer();
    // player.stop();
    await player.play(AssetSource(audioPath));
  } catch (error) {
    debugPrint("Ding Sound Exception: ${error.toString()}");
  }
}
