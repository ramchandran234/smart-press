// lib/core/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
// Auth
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/owner_register_screen.dart';
import '../../features/auth/screens/owner_verify_screen.dart';
import '../../features/auth/screens/customer_register_screen.dart';
// Owner Dashboard
import '../../features/dashboard/screens/home_dashboard_screen.dart';
import '../../features/dashboard/screens/daily_schedule_screen.dart';
// Orders (Owner)
import '../../features/orders/screens/order_list_screen.dart';
import '../../features/orders/screens/create_order_screen.dart';
import '../../features/orders/screens/order_detail_screen.dart';
import '../../features/orders/screens/qr_scanner_screen.dart';
import '../../features/orders/screens/update_status_screen.dart';
import '../../features/orders/screens/order_history_screen.dart';
import '../../features/orders/screens/rate_card_screen.dart';
// Logistics
import '../../features/logistics/screens/pickup_list_screen.dart';
import '../../features/logistics/screens/delivery_list_screen.dart';
import '../../features/logistics/screens/schedule_screen.dart';
// Customers (Owner side)
import '../../features/customers/screens/customer_list_screen.dart';
import '../../features/customers/screens/add_customer_screen.dart';
import '../../features/customers/screens/customer_profile_screen.dart';
import '../../features/customers/screens/customer_orders_screen.dart';
// Payments
import '../../features/payments/screens/collect_payment_screen.dart';
import '../../features/payments/screens/owner_qr_screen.dart';
// Invoices
import '../../features/invoices/screens/invoice_view_screen.dart';
import '../../features/invoices/screens/invoice_list_screen.dart';
import '../../features/invoices/screens/share_invoice_screen.dart';
// Suppliers
import '../../features/suppliers/screens/supplier_list_screen.dart';
import '../../features/suppliers/screens/add_supplier_screen.dart';
import '../../features/suppliers/screens/supplier_profile_screen.dart';
import '../../features/suppliers/screens/supplier_qr_screen.dart';
import '../../features/suppliers/screens/record_payment_screen.dart';
// Expenses
import '../../features/expenses/screens/expense_list_screen.dart';
import '../../features/expenses/screens/add_expense_screen.dart';
import '../../features/expenses/screens/attach_receipt_screen.dart';
// Reports
import '../../features/reports/screens/revenue_dashboard_screen.dart';
import '../../features/reports/screens/profit_summary_screen.dart';
import '../../features/reports/screens/receivables_screen.dart';
import '../../features/reports/screens/revenue_report_screen.dart';
import '../../features/reports/screens/export_screen.dart';
// Settings
import '../../features/settings/screens/app_settings_screen.dart';
import '../../features/settings/screens/upload_qr_screen.dart';
// Customer Side
import '../../features/customer/screens/customer_dashboard_screen.dart';
import '../../features/customer/screens/my_orders_screen.dart';
import '../../features/customer/screens/order_progress_screen.dart';
import '../../features/customer/screens/delivery_mode_screen.dart';
import '../../features/customer/screens/customer_order_detail_screen.dart';
import '../../features/customer/screens/nearby_vendors_screen.dart';
import '../../features/customer/screens/create_vendor_order_screen.dart';
import '../../features/customer/screens/vendor_progress_screen.dart';
import '../../features/customer/screens/vendor_payment_screen.dart';
import '../../features/customer/screens/payment_options_screen.dart';
import '../../features/customer/screens/payment_history_screen.dart';
import '../../features/customer/screens/customer_settings_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  // ✅ Error handler — no more blank "route not found"
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppColors.darkBg,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline,
              color: Colors.red, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Page not found',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            state.uri.toString(),
            style: const TextStyle(
                color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home, color: Colors.white),
            label: const Text('Go to Home',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  ),

  routes: [
    // ── AUTH ──────────────────────────────────────────
    GoRoute(
      path: '/',
      builder: (c, s) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/customer-register',
      builder: (c, s) => const CustomerRegisterScreen(),
    ),
    GoRoute(
      name: 'otp',
      path: '/otp',
      builder: (c, s) => OtpScreen(
          role: s.uri.queryParameters['role'] ?? 'owner'),
    ),
    GoRoute(
      name: 'forgot-password',
      path: '/forgot-password',
      builder: (c, s) => ForgotPasswordScreen(
          role: s.uri.queryParameters['role'] ?? 'owner'),
    ),
    GoRoute(
      path: '/register',
      builder: (c, s) => const OwnerRegisterScreen(),
    ),
    GoRoute(
      path: '/verify',
      builder: (c, s) => const OwnerVerifyScreen(),
    ),

    // ── OWNER DASHBOARD ───────────────────────────────
    GoRoute(
      path: '/home',
      builder: (c, s) => const HomeDashboardScreen(),
    ),
    GoRoute(
      path: '/schedule',
      builder: (c, s) => const DailyScheduleScreen(),
    ),

    // ── ORDERS ────────────────────────────────────────
    GoRoute(
      path: '/orders',
      builder: (c, s) => const OrderListScreen(),
    ),
    GoRoute(
      path: '/orders/new',
      builder: (c, s) => const CreateOrderScreen(),
    ),
    GoRoute(
      path: '/orders/history',
      builder: (c, s) => const OrderHistoryScreen(),
    ),
    GoRoute(
      path: '/orders/:id',
      builder: (c, s) => OrderDetailScreen(
          orderId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/orders/:id/status',
      builder: (c, s) => UpdateStatusScreen(
          orderId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/qr-scanner',
      builder: (c, s) => const QrScannerScreen(),
    ),
    GoRoute(
      path: '/rate-card',
      builder: (c, s) => const RateCardScreen(),
    ),

    // ── LOGISTICS ─────────────────────────────────────
    GoRoute(
      path: '/pickups',
      builder: (c, s) => const PickupListScreen(),
    ),
    GoRoute(
      path: '/deliveries',
      builder: (c, s) => const DeliveryListScreen(),
    ),
    GoRoute(
      path: '/schedule-slot',
      builder: (c, s) => const ScheduleScreen(),
    ),

    // ── CUSTOMERS (Owner) ─────────────────────────────
    GoRoute(
      path: '/customers',
      builder: (c, s) => const CustomerListScreen(),
    ),
    GoRoute(
      path: '/customers/new',
      builder: (c, s) => const AddCustomerScreen(),
    ),
    GoRoute(
      path: '/customers/:id',
      builder: (c, s) => CustomerProfileScreen(
          customerId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/customers/:id/orders',
      builder: (c, s) => CustomerOrdersScreen(
          customerId: s.pathParameters['id']!),
    ),

    // ── PAYMENTS ──────────────────────────────────────
    GoRoute(
      path: '/collect-payment',
      builder: (c, s) => const CollectPaymentScreen(),
    ),
    GoRoute(
      path: '/owner-qr',
      builder: (c, s) => const OwnerQrScreen(),
    ),

    // ── INVOICES ──────────────────────────────────────
    GoRoute(
      path: '/invoices',
      builder: (c, s) => const InvoiceListScreen(),
    ),
    GoRoute(
      path: '/invoices/:id/share',
      builder: (c, s) => ShareInvoiceScreen(
          invoiceId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/invoices/:id',
      builder: (c, s) => InvoiceViewScreen(
          invoiceId: s.pathParameters['id']!),
    ),

    // ── SUPPLIERS ─────────────────────────────────────
    GoRoute(
      path: '/suppliers',
      builder: (c, s) => const SupplierListScreen(),
    ),
    GoRoute(
      path: '/suppliers/new',
      builder: (c, s) => const AddSupplierScreen(),
    ),
    GoRoute(
      path: '/suppliers/:id/qr',
      builder: (c, s) => SupplierQrScreen(
          supplierId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/suppliers/:id/pay',
      builder: (c, s) => RecordPaymentScreen(
          supplierId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/suppliers/:id',
      builder: (c, s) => SupplierProfileScreen(
          supplierId: s.pathParameters['id']!),
    ),

    // ── EXPENSES ──────────────────────────────────────
    GoRoute(
      path: '/expenses',
      builder: (c, s) => const ExpenseListScreen(),
    ),
    GoRoute(
      path: '/expenses/new',
      builder: (c, s) => const AddExpenseScreen(),
    ),
    GoRoute(
      path: '/expenses/receipt',
      builder: (c, s) => const AttachReceiptScreen(),
    ),

    // ── REPORTS ───────────────────────────────────────
    GoRoute(
      path: '/reports/revenue',
      builder: (c, s) => const RevenueDashboardScreen(),
    ),
    GoRoute(
      path: '/reports/profit',
      builder: (c, s) => const ProfitSummaryScreen(),
    ),
    GoRoute(
      path: '/reports/receivables',
      builder: (c, s) => const ReceivablesScreen(),
    ),
    GoRoute(
      path: '/reports/breakdown',
      builder: (c, s) => const RevenueReportScreen(),
    ),
    GoRoute(
      path: '/reports/export',
      builder: (c, s) => const ExportScreen(),
    ),

    // ── SETTINGS ──────────────────────────────────────
    GoRoute(
      path: '/settings',
      builder: (c, s) => const AppSettingsScreen(),
    ),
    GoRoute(
      path: '/settings/qr',
      builder: (c, s) => const UploadQrScreen(),
    ),

    // ── CUSTOMER SIDE ─────────────────────────────────
    GoRoute(
      path: '/customer/dashboard',
      builder: (c, s) => const CustomerDashboardScreen(),
    ),
    GoRoute(
      path: '/customer/orders',
      builder: (c, s) => const CustomerMyOrdersScreen(),
    ),
    GoRoute(
      path: '/customer/order-progress/:id',
      builder: (c, s) => CustomerOrderProgressScreen(
          orderId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/customer/delivery-mode',
      builder: (c, s) => const DeliveryModeScreen(),
    ),
    GoRoute(
      path: '/customer/order-detail/:id',
      builder: (c, s) => CustomerOrderDetailScreen(
          orderId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/customer/vendors',
      builder: (c, s) => const NearbyVendorsScreen(),
    ),
    GoRoute(
      path: '/customer/vendor-order',
      builder: (c, s) => CreateVendorOrderScreen(
          vendorId: s.uri.queryParameters['vendorId']),
    ),
    GoRoute(
      path: '/customer/vendor-progress/:id',
      builder: (c, s) => VendorProgressScreen(
          orderId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/customer/vendor-payment',
      builder: (c, s) => const VendorPaymentScreen(),
    ),
    GoRoute(
      path: '/customer/payments',
      builder: (c, s) => const PaymentOptionsScreen(),
    ),
    GoRoute(
      path: '/customer/payment-history',
      builder: (c, s) => const PaymentHistoryScreen(),
    ),
    GoRoute(
      path: '/customer/settings',
      builder: (c, s) => const CustomerSettingsScreen(),
    ),
  ],
);

class _ComingSoon extends StatelessWidget {
  final String name;
  const _ComingSoon(this.name);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction,
                size: 64, color: AppColors.accent),
            const SizedBox(height: 16),
            Text(name,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Coming Soon...',
                style: TextStyle(
                    color: AppColors.textSub,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}