import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:car_register/features/access_control/domain/entities/access_code_entity.dart';

class AccessCodeModel {
  const AccessCodeModel({
    required this.code,
    required this.isActive,
    this.label,
    this.createdAt,
  });

  final String code;
  final bool isActive;
  final String? label;
  final DateTime? createdAt;

  factory AccessCodeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw const FormatException('Access code snapshot has no data.');
    }

    final createdAtRaw = data['createdAt'];
    DateTime? createdAt;
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is String) {
      createdAt = DateTime.tryParse(createdAtRaw);
    }

    return AccessCodeModel(
      code: (data['code'] as String?)?.trim() ?? snapshot.id,
      isActive: (data['isActive'] as bool?) ?? false,
      label: data['label'] as String?,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'code': code,
    'isActive': isActive,
    if (label != null) 'label': label,
    if (createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
  };

  AccessCodeEntity toEntity() => AccessCodeEntity(
    code: code,
    isActive: isActive,
    label: label,
    createdAt: createdAt,
  );
}
