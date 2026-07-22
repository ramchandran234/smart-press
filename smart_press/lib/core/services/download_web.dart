// lib/core/services/download_web.dart
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

void downloadFileWeb(String content, String fileName, String mimeType) {
  try {
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes], mimeType);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..download = fileName;
    html.document.body?.children.add(anchor);
    anchor.click();
    anchor.remove();
    html.Url.revokeObjectUrl(url);
  } catch (e) {
    debugPrint('Web download error: $e');
  }
}
