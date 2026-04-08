import 'dart:ui';

abstract final class AppColors {
  // Primary palette
  static const Color primary = Color(0xFF7C4DFF);
  static const Color primaryLight = Color(0xFFB388FF);
  static const Color primaryDark = Color(0xFF651FFF);

  // Accent
  static const Color accent = Color(0xFFFF6D00);
  static const Color accentLight = Color(0xFFFFAB40);

  // Background
  static const Color background = Color(0xFFF5F0FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFEDE7F6);

  // Board
  static const Color boardBackground = Color(0xFFE8DEF8);
  static const Color cellEmpty = Color(0xFFD1C4E9);
  static const Color cellHoverMerge = Color(0xFF69F0AE);
  static const Color cellHoverPlace = Color(0xFF82B1FF);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B6B8D);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Coins / Currency
  static const Color coins = Color(0xFFFFD600);
  static const Color coinsStroke = Color(0xFFFFA000);

  // Rarity colors
  static const Color rarityCommon = Color(0xFF9E9E9E);
  static const Color rarityUncommon = Color(0xFF42A5F5);
  static const Color rarityRare = Color(0xFFAB47BC);
  static const Color rarityEpic = Color(0xFFFF7043);
  static const Color rarityLegendary = Color(0xFFFFD600);

  // Status
  static const Color success = Color(0xFF66BB6A);
  static const Color error = Color(0xFFEF5350);

  // Creature tier base colors
  static const Color tier1 = Color(0xFF81C784);
  static const Color tier2 = Color(0xFF4DB6AC);
  static const Color tier3 = Color(0xFF42A5F5);
  static const Color tier4 = Color(0xFFFFCA28);
  static const Color tier5 = Color(0xFFFF7043);
  static const Color tier6 = Color(0xFF7E57C2);
  static const Color tier7 = Color(0xFF5C6BC0);
  static const Color tier8 = Color(0xFFEC407A);
  static const Color tier9 = Color(0xFFFFFFFF);
  static const Color tier10 = Color(0xFFFF6D00);
}
