// lib/core/services/order_service.dart
import 'http_helper.dart';

class OrderService {
  // ── Get all orders ────────────────────────────────
  static Future<Map<String, dynamic>> getOrders({
    String? status,
    String? type,
    int page = 1,
  }) async {
    String q = '/orders?page=$page';
    if (status != null && status.isNotEmpty) {
      q += '&status=$status';
    }
    if (type != null && type.isNotEmpty) {
      q += '&type=$type';
    }
    return HttpHelper.get(q);
  }

  // ── Get order by ID ───────────────────────────────
  static Future<Map<String, dynamic>> getOrderById(
      String id) async {
    return HttpHelper.get('/orders/$id');
  }

  // ── Create order ──────────────────────────────────
  static Future<Map<String, dynamic>> createOrder(
      Map<String, dynamic> data) async {
    return HttpHelper.post('/orders', data, withAuth: true);
  }

  // ── Update status ─────────────────────────────────
  static Future<Map<String, dynamic>> updateStatus(
    String id,
    String status, {
    String note = '',
  }) async {
    return HttpHelper.put(
      '/orders/$id/status',
      {'status': status, 'note': note},
    );
  }

  // ── Collect payment ───────────────────────────────
  static Future<Map<String, dynamic>> collectPayment(
    String id, {
    required double amount,
    required String paymentMode,
  }) async {
    return HttpHelper.post(
      '/orders/$id/payment',
      {'amount': amount, 'paymentMode': paymentMode},
      withAuth: true,
    );
  }

  // ── Get history ───────────────────────────────────
  static Future<Map<String, dynamic>> getHistory({
    String? from,
    String? to,
    int page = 1,
  }) async {
    String q = '/orders/history?page=$page';
    if (from != null) q += '&from=$from';
    if (to != null)   q += '&to=$to';
    return HttpHelper.get(q);
  }

  static Future<Map<String, dynamic>> getCustomerAppOrders() async {
    return HttpHelper.get('/orders/customer-app');
  }
}