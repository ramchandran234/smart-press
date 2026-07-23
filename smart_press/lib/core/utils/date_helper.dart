// lib/core/utils/date_helper.dart

class DateHelper {
  /// Safely parses any dynamic input (String, DateTime, or int) into a DateTime object.
  static DateTime? parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return null;
  }
}
