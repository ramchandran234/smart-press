// lib/core/services/firebase_storage_service.dart
class FirebaseStorageService {
  // Firebase Storage disabled
  // File uploads will use backend multer

  static Future<String?> uploadImage({
    required String path,
    required dynamic imageFile,
  }) async {
    // TODO: implement with backend multer
    return null;
  }

  static Future<String?> uploadFile({
    required String path,
    required dynamic file,
  }) async {
    return null;
  }

  static Future<void> deleteFile(
      String url) async {}
}