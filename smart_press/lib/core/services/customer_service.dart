// lib/core/services/customer_service.dart
import 'http_helper.dart';

class CustomerService {
  // ── Get all customers ─────────────────────────────
  static Future<Map<String, dynamic>> getCustomers({
    String? search,
    int page = 1,
  }) async {
    String q = '/customers?page=$page';
    if (search != null && search.isNotEmpty) {
      q += '&search=$search';
    }
    return HttpHelper.get(q);
  }

  // ── Get customer by ID ────────────────────────────
  static Future<Map<String, dynamic>> getCustomerById(
      String id) async {
    return HttpHelper.get('/customers/$id');
  }

  // ── Create customer ───────────────────────────────
  static Future<Map<String, dynamic>> createCustomer(
      Map<String, dynamic> data) async {
    return HttpHelper.post('/customers', data, withAuth: true);
  }

  // ── Update customer ───────────────────────────────
  static Future<Map<String, dynamic>> updateCustomer(
    String id,
    Map<String, dynamic> data,
  ) async {
    return HttpHelper.put('/customers/$id', data);
  }

  // ── Get customer orders ───────────────────────────
  static Future<Map<String, dynamic>>
      getCustomerOrders(String id) async {
    return HttpHelper.get('/customers/$id/orders');
  }
}