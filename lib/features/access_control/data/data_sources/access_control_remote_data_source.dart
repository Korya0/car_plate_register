import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:car_register/features/access_control/data/models/access_code_model.dart';

abstract interface class AccessControlRemoteDataSource {
  // Retrieves an access code by its identifier.
  Future<AccessCodeModel?> getAccessCode(String code);
}

class AccessControlRemoteDataSourceImpl
    implements AccessControlRemoteDataSource {
  const AccessControlRemoteDataSourceImpl({
    required this.firestore,
  });

  final FirebaseFirestore firestore;

  static const Duration _timeout = Duration(seconds: 10);

  static const String _collection = 'access_codes';

  @override
  // Retrieves an access code by its identifier.
  Future<AccessCodeModel?> getAccessCode(String code) async {
    final doc = await firestore
        .collection(_collection)
        .doc(code)
        .get()
        .timeout(_timeout);
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return AccessCodeModel.fromFirestore(doc);
  }
}
