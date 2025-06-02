import 'package:audioplayers/audioplayers.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../utils/logger.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioPlayer _audioPlayer = AudioPlayer();
  static const String _soundAssetPath = 'audio/notification.mp3';

  @override
  Future<void> playNotificationSound() async {
    try {
      await _audioPlayer.play(AssetSource(_soundAssetPath));
      logger.d('Played sound: $_soundAssetPath');
    } catch (e) {
      logger.e('Error playing sound: $e');
    }
  }
}
