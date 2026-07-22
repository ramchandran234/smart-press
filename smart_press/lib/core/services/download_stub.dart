// lib/core/services/download_stub.dart
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

void downloadFileWeb(String content, String fileName, String mimeType) {
  debugPrint('Non-web download triggered for file: $fileName');
  Share.share(content, subject: fileName);
}
