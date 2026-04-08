class BoardUnit {
  final String instanceId;
  final String creatureId;
  final int row;
  final int col;

  const BoardUnit({
    required this.instanceId,
    required this.creatureId,
    required this.row,
    required this.col,
  });

  BoardUnit copyWith({
    String? instanceId,
    String? creatureId,
    int? row,
    int? col,
  }) {
    return BoardUnit(
      instanceId: instanceId ?? this.instanceId,
      creatureId: creatureId ?? this.creatureId,
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardUnit &&
          runtimeType == other.runtimeType &&
          instanceId == other.instanceId;

  @override
  int get hashCode => instanceId.hashCode;

  @override
  String toString() => 'BoardUnit($creatureId @ [$row,$col])';

  Map<String, dynamic> toJson() => {
        'instanceId': instanceId,
        'creatureId': creatureId,
        'row': row,
        'col': col,
      };

  factory BoardUnit.fromJson(Map<String, dynamic> json) => BoardUnit(
        instanceId: json['instanceId'] as String,
        creatureId: json['creatureId'] as String,
        row: json['row'] as int,
        col: json['col'] as int,
      );
}
