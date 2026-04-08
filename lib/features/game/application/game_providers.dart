import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/audio_service.dart';
import '../../../core/services/haptics_service.dart';
import '../../../core/services/save_service.dart';
import '../domain/merge_engine.dart';
import '../domain/reward_engine.dart';
import '../domain/spawn_engine.dart';

// --- Singletons ---

final saveServiceProvider = Provider<SaveService>((_) => SaveService());
final audioServiceProvider = Provider<AudioService>((_) => AudioService());
final hapticsServiceProvider = Provider<HapticsService>((_) => HapticsService());
final mergeEngineProvider = Provider<MergeEngine>((_) => MergeEngine());
final spawnEngineProvider = Provider<SpawnEngine>((_) => SpawnEngine());
final rewardEngineProvider = Provider<RewardEngine>((_) => RewardEngine());

// --- Drag state for visual feedback ---

final draggedCreatureIdProvider = StateProvider<String?>((_) => null);
