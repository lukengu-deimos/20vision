import 'package:audioplayers/audioplayers.dart';

class AssetSound {
  static Future<void> playSound(AssetSoundType sound) async {
    // Play sound
    final AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(sound.source);
  }
}

class AssetSoundType {
  final String _path;

  const AssetSoundType._(this._path);

  static get error => const AssetSoundType._('sounds/error.mp3');

  static get success => const AssetSoundType._('sounds/success.mp3');

  static get liked => const AssetSoundType._('sounds/liked.mp3');

  static get disliked => const AssetSoundType._('sounds/disliked.mp3');

  static get messageReceived =>
      const AssetSoundType._('sounds/message_received.mp3');

  static get messageSend => const AssetSoundType._('sounds/send_message.mp3');

  AssetSource get source => AssetSource(_path);
}
