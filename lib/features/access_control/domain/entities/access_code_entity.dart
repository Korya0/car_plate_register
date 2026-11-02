class AccessCodeEntity {
  const AccessCodeEntity({
    required this.code,
    required this.isActive,
    this.label,
    this.createdAt,
  });

  final String code;
  final bool isActive;
  final String? label;
  final DateTime? createdAt;
}
