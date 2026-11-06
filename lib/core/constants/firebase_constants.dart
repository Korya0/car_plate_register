/// Central Firebase collection keys shared by every feature data source.
class FirebaseCollectionKeys {
  FirebaseCollectionKeys._();

  /// Parent collection where each client's access code is stored.
  static const String accessCodes = 'access_codes';

  /// Subcollection where the brochure plates of a client are stored.
  static const String plates = 'plates';
}

/// Central Firestore document field keys shared by every feature data source.
class FirebaseDocumentFieldKeys {
  FirebaseDocumentFieldKeys._();

  // Access code documents.
  static const String accessCodeCode = 'code';
  static const String accessCodeIsActive = 'isActive';
  static const String accessCodeLabel = 'label';
  static const String accessCodeCreatedAt = 'createdAt';

  // Brochure documents.
  static const String brochureNumber = 'number';
  static const String brochureCreatedAt = 'createdAt';
}

/// Central Firestore error codes shared by every feature data source.
class FirebaseErrorCodes {
  FirebaseErrorCodes._();

  /// The access code may exist but is not allowed to be read right now.
  static const String permissionDenied = 'permission-denied';

  /// The requested document does not exist.
  static const String notFound = 'not-found';
}
