import 'package:audioplayers/audioplayers.dart';
import '../../domain/repositories/audio_repository.dart';

class AudioService implements AudioRepository {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Future<void> playNotificationSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/notification.mp3'));
    } catch (e) {
      print('Error playing notification sound: $e');
    }
  }
}
