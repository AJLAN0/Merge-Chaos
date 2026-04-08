import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../shared/models/board_state.dart';
import '../../shared/models/player_progress.dart';

class SaveService {
  static const _progressBoxName = 'player_progress';
  static const _boardBoxName = 'board_state';
  static const _settingsBoxName = 'settings';
  static const _progressKey = 'progress';
  static const _boardKey = 'board';

  Box get _progressBox => Hive.box(_progressBoxName);
  Box get _boardBox => Hive.box(_boardBoxName);
  Box get _settingsBox => Hive.box(_settingsBoxName);

  // --- Player Progress ---

  Future<void> saveProgress(PlayerProgress progress) async {
    await _progressBox.put(_progressKey, jsonEncode(progress.toJson()));
  }

  PlayerProgress loadProgress() {
    final raw = _progressBox.get(_progressKey);
    if (raw == null) return const PlayerProgress();
    return PlayerProgress.fromJson(
      jsonDecode(raw as String) as Map<String, dynamic>,
    );
  }

  // --- Board State ---

  Future<void> saveBoardState(BoardState boardState) async {
    await _boardBox.put(_boardKey, jsonEncode(boardState.toJson()));
  }

  BoardState loadBoardState() {
    final raw = _boardBox.get(_boardKey);
    if (raw == null) return BoardState.empty();
    return BoardState.fromJson(
      jsonDecode(raw as String) as Map<String, dynamic>,
    );
  }

  // --- Settings ---

  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  T? loadSetting<T>(String key, {T? defaultValue}) {
    return _settingsBox.get(key, defaultValue: defaultValue) as T?;
  }

  bool get musicEnabled => loadSetting<bool>('musicEnabled', defaultValue: true) ?? true;
  bool get sfxEnabled => loadSetting<bool>('sfxEnabled', defaultValue: true) ?? true;
  bool get vibrationEnabled =>
      loadSetting<bool>('vibrationEnabled', defaultValue: true) ?? true;
  String get locale => loadSetting<String>('locale', defaultValue: 'en') ?? 'en';

  // --- Clear ---

  Future<void> clearAll() async {
    await _progressBox.clear();
    await _boardBox.clear();
  }
}
