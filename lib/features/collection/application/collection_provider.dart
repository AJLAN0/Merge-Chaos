import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/creature_definition.dart';
import '../../game/application/player_provider.dart';
import '../../game/data/creature_families.dart';

class CollectionEntry {
  final CreatureDefinition creature;
  final bool isUnlocked;

  const CollectionEntry({
    required this.creature,
    required this.isUnlocked,
  });
}

final collectionProvider = Provider<List<CollectionEntry>>((ref) {
  final progress = ref.watch(playerProvider);
  return chaosCatsFamily.map((creature) {
    return CollectionEntry(
      creature: creature,
      isUnlocked: progress.unlockedCreatureIds.contains(creature.id),
    );
  }).toList();
});

final discoveredCountProvider = Provider<int>((ref) {
  final collection = ref.watch(collectionProvider);
  return collection.where((e) => e.isUnlocked).length;
});

final totalCreatureCountProvider = Provider<int>((ref) {
  return chaosCatsFamily.length;
});
