import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:car_register/features/home/data/models/brochure_model.dart';

abstract interface class BrochureRemoteDataSource {
  // Retrieves all brochures under the specified access code.
  Future<List<BrochureModel>> getBrochures({required String accessCode});

  // Adds a new brochure number under the specified access code.
  Future<BrochureModel> addBrochure({
    required String accessCode,
    required String number,
  });

  // Deletes a single brochure by its ID.
  Future<void> deleteBrochure({
    required String accessCode,
    required String id,
  });

  // Deletes multiple brochures in a batch.
  Future<void> deleteManyBrochures({
    required String accessCode,
    required List<String> ids,
  });
}

class BrochureRemoteDataSourceImpl implements BrochureRemoteDataSource {
  const BrochureRemoteDataSourceImpl({
    required this.firestore,
  });

  final FirebaseFirestore firestore;

  static const Duration _timeout = Duration(seconds: 30);

  static const String _accessCodesCollection = 'access_codes';
  static const String _platesCollection = 'plates';

  CollectionReference<Map<String, dynamic>> _platesRef(String accessCode) =>
      firestore
          .collection(_accessCodesCollection)
          .doc(accessCode)
          .collection(_platesCollection);

  @override
  // Retrieves all brochures under the specified access code.
  Future<List<BrochureModel>> getBrochures({
    required String accessCode,
  }) async {
    final snapshot = await _platesRef(accessCode)
        .orderBy('createdAt', descending: true)
        .get()
        .timeout(_timeout);

    return snapshot.docs.map(BrochureModel.fromFirestore).toList();
  }

  @override
  // Adds a new brochure number under the specified access code.
  Future<BrochureModel> addBrochure({
    required String accessCode,
    required String number,
  }) async {
    final docRef = _platesRef(accessCode).doc(number);
    final now = DateTime.now();

    final model = BrochureModel(
      id: number,
      number: number,
      createdAt: now,
    );

    await docRef.set(model.toMap()).timeout(_timeout);
    return model;
  }

  @override
  // Deletes a single brochure by its ID.
  Future<void> deleteBrochure({
    required String accessCode,
    required String id,
  }) => _platesRef(accessCode).doc(id).delete().timeout(_timeout);

  @override
  // Deletes multiple brochures in a batch.
  Future<void> deleteManyBrochures({
    required String accessCode,
    required List<String> ids,
  }) async {
    final batch = firestore.batch();
    final ref = _platesRef(accessCode);

    for (final id in ids) {
      batch.delete(ref.doc(id));
    }

    await batch.commit().timeout(_timeout);
  }
}
