class CurrencyWallet {
  final int coins;

  const CurrencyWallet({this.coins = 0});

  bool canAfford(int cost) => coins >= cost;

  CurrencyWallet add(int amount) => CurrencyWallet(coins: coins + amount);

  CurrencyWallet spend(int amount) {
    assert(coins >= amount, 'Cannot spend more than available');
    return CurrencyWallet(coins: coins - amount);
  }
}
