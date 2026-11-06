/// Central Firebase collection keys shared by every feature data source.
class FirebaseCollectionKeys {
  FirebaseCollectionKeys._();

  /// Parent collection where each client's access code is stored.
  static const String accessCodes = 'access_codes';

  /// Subcollection where the brochure plates of a client are stored.
  static const String plates = 'plates';
}
