import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:car_register/core/constants/firebase_constants.dart';
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

    final createdAtRaw = data[FirebaseDocumentFieldKeys.accessCodeCreatedAt];
    DateTime? createdAt;
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is String) {
      createdAt = DateTime.tryParse(createdAtRaw);
    }

    return AccessCodeModel(
      code: (data[FirebaseDocumentFieldKeys.accessCodeCode] as String?)
              ?.trim() ??
          snapshot.id,
      isActive: (data[FirebaseDocumentFieldKeys.accessCodeIsActive] as bool?) ?? false,
      label: data[FirebaseDocumentFieldKeys.accessCodeLabel] as String?,
      createdAt: createdAt,
    );
  }

  AccessCodeEntity toEntity() => AccessCodeEntity(
    code: code,
    isActive: isActive,
    label: label,
    createdAt: createdAt,
  );
}
