class BrochureEntity {
  const BrochureEntity({
    required this.id,
    required this.number,
    required this.createdAt,
  });

  final int id;
  final String number;
  final DateTime createdAt;
}
