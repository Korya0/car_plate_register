import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:car_register/features/home/domain/entities/brochure_entity.dart';

class BrochureModel {
  const BrochureModel({
    required this.id,
    required this.number,
    required this.createdAt,
  });

  final String id;
  final String number;
  final DateTime createdAt;

  factory BrochureModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw const FormatException('Brochure snapshot has no data.');
    }

    final createdAtRaw = data['createdAt'];
    DateTime createdAt;
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else if (createdAtRaw is String) {
      createdAt = DateTime.tryParse(createdAtRaw) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return BrochureModel(
      id: snapshot.id,
      number: (data['number'] as String?)?.trim() ?? snapshot.id,
      createdAt: createdAt,
    );
  }

  factory BrochureModel.fromEntity(BrochureEntity entity) => BrochureModel(
    id: entity.id,
    number: entity.number,
    createdAt: entity.createdAt,
  );

  Map<String, dynamic> toMap() => {
    'number': number,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  BrochureEntity toEntity() => BrochureEntity(
    id: id,
    number: number,
    createdAt: createdAt,
  );
}
