import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _sfxEnabled = true;
  bool _musicEnabled = true;

  bool get sfxEnabled => _sfxEnabled;
  bool get musicEnabled => _musicEnabled;

  void setSfxEnabled(bool enabled) {
    _sfxEnabled = enabled;
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
  }

  Future<void> _playSfx(String assetPath) async {
    if (!_sfxEnabled) return;
    try {
      await _sfxPlayer.play(AssetSource(assetPath));
    } catch (_) {
      // Audio files may not exist yet — fail silently for MVP
    }
  }

  Future<void> playMerge() => _playSfx('audio/merge.mp3');
  Future<void> playSpawn() => _playSfx('audio/spawn.mp3');
  Future<void> playReveal() => _playSfx('audio/reveal.mp3');
  Future<void> playTap() => _playSfx('audio/tap.mp3');
  Future<void> playInvalid() => _playSfx('audio/invalid.mp3');
  Future<void> playReward() => _playSfx('audio/reward.mp3');

  void dispose() {
    _sfxPlayer.dispose();
  }
}
