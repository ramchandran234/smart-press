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
import '../../shared/widgets/responsive_web_wrapper.dart';

/// Helper to build fluid, smooth Fade + Scale spring page transition for all screens
Page<dynamic> _buildPage(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: ResponsiveWebWrapper(child: child),
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curveAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curveAnimation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1.0).animate(curveAnimation),
          child: child,
        ),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  errorBuilder: (context, state) => Scaffold(
    backgroundColor: AppColors.darkBg,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Page not found',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(state.uri.toString(), style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home, color: Colors.white),
            label: const Text('Go to Home', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  ),

  routes: [
    // ── AUTH ──────────────────────────────────────────
    GoRoute(
      path: '/',
      pageBuilder: (c, s) => _buildPage(c, s, const WelcomeScreen()),
    ),
    GoRoute(
      path: '/customer-register',
      pageBuilder: (c, s) => _buildPage(c, s, const CustomerRegisterScreen()),
    ),
    GoRoute(
      name: 'otp',
      path: '/otp',
      pageBuilder: (c, s) => _buildPage(c, s, OtpScreen(role: s.uri.queryParameters['role'] ?? 'owner')),
    ),
    GoRoute(
      name: 'forgot-password',
      path: '/forgot-password',
      pageBuilder: (c, s) => _buildPage(c, s, ForgotPasswordScreen(role: s.uri.queryParameters['role'] ?? 'owner')),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (c, s) => _buildPage(c, s, const OwnerRegisterScreen()),
    ),
    GoRoute(
      path: '/verify',
      pageBuilder: (c, s) => _buildPage(c, s, const OwnerVerifyScreen()),
    ),

    // ── OWNER DASHBOARD ───────────────────────────────
    GoRoute(
      path: '/home',
      pageBuilder: (c, s) => _buildPage(c, s, const HomeDashboardScreen()),
    ),
    GoRoute(
      path: '/schedule',
      pageBuilder: (c, s) => _buildPage(c, s, const DailyScheduleScreen()),
    ),

    // ── ORDERS ────────────────────────────────────────
    GoRoute(
      path: '/orders',
      pageBuilder: (c, s) => _buildPage(c, s, const OrderListScreen()),
    ),
    GoRoute(
      path: '/orders/new',
      pageBuilder: (c, s) => _buildPage(c, s, const CreateOrderScreen()),
    ),
    GoRoute(
      path: '/orders/history',
      pageBuilder: (c, s) => _buildPage(c, s, const OrderHistoryScreen()),
    ),
    GoRoute(
      path: '/orders/:id',
      pageBuilder: (c, s) => _buildPage(c, s, OrderDetailScreen(orderId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/orders/:id/status',
      pageBuilder: (c, s) => _buildPage(c, s, UpdateStatusScreen(orderId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/qr-scanner',
      pageBuilder: (c, s) => _buildPage(c, s, const QrScannerScreen()),
    ),
    GoRoute(
      path: '/rate-card',
      pageBuilder: (c, s) => _buildPage(c, s, const RateCardScreen()),
    ),

    // ── LOGISTICS ─────────────────────────────────────
    GoRoute(
      path: '/pickups',
      pageBuilder: (c, s) => _buildPage(c, s, const PickupListScreen()),
    ),
    GoRoute(
      path: '/deliveries',
      pageBuilder: (c, s) => _buildPage(c, s, const DeliveryListScreen()),
    ),
    GoRoute(
      path: '/schedule-slot',
      pageBuilder: (c, s) => _buildPage(c, s, const ScheduleScreen()),
    ),

    // ── CUSTOMERS (Owner) ─────────────────────────────
    GoRoute(
      path: '/customers',
      pageBuilder: (c, s) => _buildPage(c, s, const CustomerListScreen()),
    ),
    GoRoute(
      path: '/customers/new',
      pageBuilder: (c, s) => _buildPage(c, s, const AddCustomerScreen()),
    ),
    GoRoute(
      path: '/customers/:id',
      pageBuilder: (c, s) => _buildPage(c, s, CustomerProfileScreen(customerId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/customers/:id/orders',
      pageBuilder: (c, s) => _buildPage(c, s, CustomerOrdersScreen(customerId: s.pathParameters['id']!)),
    ),

    // ── PAYMENTS ──────────────────────────────────────
    GoRoute(
      path: '/collect-payment',
      pageBuilder: (c, s) => _buildPage(c, s, const CollectPaymentScreen()),
    ),
    GoRoute(
      path: '/owner-qr',
      pageBuilder: (c, s) => _buildPage(c, s, const OwnerQrScreen()),
    ),

    // ── INVOICES ──────────────────────────────────────
    GoRoute(
      path: '/invoices',
      pageBuilder: (c, s) => _buildPage(c, s, const InvoiceListScreen()),
    ),
    GoRoute(
      path: '/invoices/:id/share',
      pageBuilder: (c, s) => _buildPage(c, s, ShareInvoiceScreen(invoiceId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/invoices/:id',
      pageBuilder: (c, s) => _buildPage(c, s, InvoiceViewScreen(invoiceId: s.pathParameters['id']!)),
    ),

    // ── SUPPLIERS ─────────────────────────────────────
    GoRoute(
      path: '/suppliers',
      pageBuilder: (c, s) => _buildPage(c, s, const SupplierListScreen()),
    ),
    GoRoute(
      path: '/suppliers/new',
      pageBuilder: (c, s) => _buildPage(c, s, const AddSupplierScreen()),
    ),
    GoRoute(
      path: '/suppliers/:id/qr',
      pageBuilder: (c, s) => _buildPage(c, s, SupplierQrScreen(supplierId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/suppliers/:id/pay',
      pageBuilder: (c, s) => _buildPage(c, s, RecordPaymentScreen(supplierId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/suppliers/:id',
      pageBuilder: (c, s) => _buildPage(c, s, SupplierProfileScreen(supplierId: s.pathParameters['id']!)),
    ),

    // ── EXPENSES ──────────────────────────────────────
    GoRoute(
      path: '/expenses',
      pageBuilder: (c, s) => _buildPage(c, s, const ExpenseListScreen()),
    ),
    GoRoute(
      path: '/expenses/new',
      pageBuilder: (c, s) => _buildPage(c, s, const AddExpenseScreen()),
    ),
    GoRoute(
      path: '/expenses/receipt',
      pageBuilder: (c, s) => _buildPage(c, s, const AttachReceiptScreen()),
    ),

    // ── REPORTS ───────────────────────────────────────
    GoRoute(
      path: '/reports/revenue',
      pageBuilder: (c, s) => _buildPage(c, s, const RevenueDashboardScreen()),
    ),
    GoRoute(
      path: '/reports/profit',
      pageBuilder: (c, s) => _buildPage(c, s, const ProfitSummaryScreen()),
    ),
    GoRoute(
      path: '/reports/receivables',
      pageBuilder: (c, s) => _buildPage(c, s, const ReceivablesScreen()),
    ),
    GoRoute(
      path: '/reports/breakdown',
      pageBuilder: (c, s) => _buildPage(c, s, const RevenueReportScreen()),
    ),
    GoRoute(
      path: '/reports/export',
      pageBuilder: (c, s) => _buildPage(c, s, const ExportScreen()),
    ),

    // ── SETTINGS ──────────────────────────────────────
    GoRoute(
      path: '/settings',
      pageBuilder: (c, s) => _buildPage(c, s, const AppSettingsScreen()),
    ),
    GoRoute(
      path: '/settings/qr',
      pageBuilder: (c, s) => _buildPage(c, s, const UploadQrScreen()),
    ),

    // ── CUSTOMER SIDE ─────────────────────────────────
    GoRoute(
      path: '/customer/dashboard',
      pageBuilder: (c, s) => _buildPage(c, s, const CustomerDashboardScreen()),
    ),
    GoRoute(
      path: '/customer/orders',
      pageBuilder: (c, s) => _buildPage(c, s, const CustomerMyOrdersScreen()),
    ),
    GoRoute(
      path: '/customer/order-progress/:id',
      pageBuilder: (c, s) => _buildPage(c, s, CustomerOrderProgressScreen(orderId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/customer/delivery-mode',
      pageBuilder: (c, s) => _buildPage(c, s, const DeliveryModeScreen()),
    ),
    GoRoute(
      path: '/customer/order-detail/:id',
      pageBuilder: (c, s) => _buildPage(c, s, CustomerOrderDetailScreen(orderId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/customer/vendors',
      pageBuilder: (c, s) => _buildPage(c, s, const NearbyVendorsScreen()),
    ),
    GoRoute(
      path: '/customer/vendor-order',
      pageBuilder: (c, s) => _buildPage(c, s, CreateVendorOrderScreen(vendorId: s.uri.queryParameters['vendorId'])),
    ),
    GoRoute(
      path: '/customer/vendor-progress/:id',
      pageBuilder: (c, s) => _buildPage(c, s, VendorProgressScreen(orderId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/customer/vendor-payment',
      pageBuilder: (c, s) => _buildPage(c, s, const VendorPaymentScreen()),
    ),
    GoRoute(
      path: '/customer/payments',
      pageBuilder: (c, s) => _buildPage(c, s, const PaymentOptionsScreen()),
    ),
    GoRoute(
      path: '/customer/payment-history',
      pageBuilder: (c, s) => _buildPage(c, s, const PaymentHistoryScreen()),
    ),
    GoRoute(
      path: '/customer/settings',
      pageBuilder: (c, s) => _buildPage(c, s, const CustomerSettingsScreen()),
    ),
  ],
);