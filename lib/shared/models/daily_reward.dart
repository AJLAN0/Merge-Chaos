import 'reward.dart';

class DailyReward {
  final int day;
  final Reward reward;
  final bool claimed;

  const DailyReward({
    required this.day,
    required this.reward,
    this.claimed = false,
  });

  DailyReward copyWith({bool? claimed}) => DailyReward(
        day: day,
        reward: reward,
        claimed: claimed ?? this.claimed,
      );
}
