import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:car_register/core/constants/app_constants.dart';
import 'package:car_register/core/constants/firebase_constants.dart';
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

  static const String _collection = FirebaseCollectionKeys.accessCodes;

  @override
  // Retrieves an access code by its identifier.
  Future<AccessCodeModel?> getAccessCode(String code) async {
    final doc = await firestore
        .collection(_collection)
        .doc(code)
        .get()
        .timeout(AppConstants.networkRequestTimeout);
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return AccessCodeModel.fromFirestore(doc);
  }
}
