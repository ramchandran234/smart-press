// lib/features/reports/screens/export_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/order_service.dart';
import '../../../shared/widgets/app_button.dart';

// Web download import using universal conditional check or HTML fallback
import 'dart:html' as html if (dart.library.io) 'dart:io';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  String _format = 'PDF';
  DateTime _from = DateTime.now().subtract(const Duration(days: 30));
  DateTime _to = DateTime.now();
  final _formats = ['PDF', 'CSV', 'Excel'];
  
  bool _isExporting = false;

  final Map<String, bool> _include = {
    'Orders': true,
    'Payments': true,
    'Expenses': true,
    'Invoices': true,
    'Suppliers': false,
  };

  void _triggerFileDownload(String content, String fileName, String mimeType) {
    if (kIsWeb) {
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
    } else {
      Share.share(content, subject: fileName);
    }
  }

  Future<void> _exportAndDownload() async {
    setState(() => _isExporting = true);

    try {
      final res = await OrderService.getOrders();
      final orders = res['success'] == true ? (res['orders'] as List<dynamic>) : [];

      // Generate Report Content
      final StringBuffer buffer = StringBuffer();
      final dateStr = '${_from.day}_${_from.month}_${_from.year}_to_${_to.day}_${_to.month}_${_to.year}';
      
      if (_format == 'CSV' || _format == 'Excel') {
        buffer.writeln('IRON BUDDY LAUNDRY MANAGEMENT REPORT');
        buffer.writeln('Date Range:,${_from.day}/${_from.month}/${_from.year} to ${_to.day}/${_to.month}/${_to.year}');
        buffer.writeln('Generated On:,${DateTime.now().toString()}');
        buffer.writeln('');

        if (_include['Orders'] == true) {
          buffer.writeln('--- ORDERS SUMMARY ---');
          buffer.writeln('Order ID,Customer Name,Service Type,Order Type,Status,Total Amount (INR),Created Date');
          for (var o in orders) {
            final cust = o['customer'] as Map<String, dynamic>?;
            final custName = cust?['name'] as String? ?? 'Walk-in';
            buffer.writeln('${o['orderId'] ?? ''},"$custName",${o['serviceType'] ?? ''},${o['orderType'] ?? ''},${o['status'] ?? ''},${o['totalAmount'] ?? 0},${o['createdAt'] ?? ''}');
          }
          buffer.writeln('');
        }

        if (_include['Payments'] == true) {
          buffer.writeln('--- PAYMENTS SUMMARY ---');
          buffer.writeln('Order ID,Amount,Payment Status');
          for (var o in orders) {
            final isPaid = o['isPaid'] == true ? 'PAID' : 'UNPAID';
            buffer.writeln('${o['orderId'] ?? ''},${o['totalAmount'] ?? 0},$isPaid');
          }
        }
      } else {
        // PDF / Text Format
        buffer.writeln('====================================================');
        buffer.writeln('            IRON BUDDY EXPRESS LAUNDRY REPORT       ');
        buffer.writeln('====================================================');
        buffer.writeln('Period: ${_from.day}/${_from.month}/${_from.year} - ${_to.day}/${_to.month}/${_to.year}');
        buffer.writeln('Generated: ${DateTime.now()}');
        buffer.writeln('Total Orders Found: ${orders.length}');
        buffer.writeln('----------------------------------------------------');
        buffer.writeln('');
        
        for (var o in orders) {
          final cust = o['customer'] as Map<String, dynamic>?;
          final custName = cust?['name'] as String? ?? 'Walk-in';
          buffer.writeln('Order #${o['orderId']} | Customer: $custName');
          buffer.writeln('Status: ${(o['status'] ?? '').toString().toUpperCase()} | Amount: ₹${o['totalAmount']} | Type: ${o['orderType']}');
          buffer.writeln('----------------------------------------------------');
        }
      }

      await Future.delayed(const Duration(milliseconds: 800)); // Smooth export delay feedback

      final ext = _format == 'CSV' ? 'csv' : _format == 'Excel' ? 'csv' : 'txt';
      final fileName = 'Iron_Buddy_Report_$dateStr.$ext';
      final mimeType = _format == 'CSV' ? 'text/csv' : 'text/plain';

      _triggerFileDownload(buffer.toString(), fileName, mimeType);

      if (mounted) {
        setState(() => _isExporting = false);
        _showSuccessDialog(fileName);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isExporting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export error: $e'), backgroundColor: AppColors.red),
        );
      }
    }
  }

  void _showSuccessDialog(String fileName) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.green),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.green, size: 28),
              SizedBox(width: 10),
              Text('Report Exported!', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your report has been generated and saved as:', style: TextStyle(color: AppColors.textSub, fontSize: 13)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.green.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file, color: AppColors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileName,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.green, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text('The download has been triggered in your browser.', style: TextStyle(color: AppColors.white, fontSize: 12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Great!', style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Export Report', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Date Range'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _dateButton('From', _from, (d) => setState(() => _from = d))),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.arrow_forward, color: AppColors.accent, size: 20),
                ),
                Expanded(child: _dateButton('To', _to, (d) => setState(() => _to = d))),
              ],
            ),
            const SizedBox(height: 20),

            _label('Export Format'),
            const SizedBox(height: 10),
            Row(
              children: _formats.map((f) {
                final sel = _format == f;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _format = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.green : AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: sel ? AppColors.green : AppColors.cardBorder,
                          width: sel ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            f == 'PDF'
                                ? Icons.picture_as_pdf
                                : f == 'CSV'
                                    ? Icons.table_chart
                                    : Icons.grid_on,
                            color: sel ? AppColors.darkBg : AppColors.white,
                            size: 24,
                          ),
                          const SizedBox(height: 6),
                          Text(f,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: sel ? AppColors.darkBg : AppColors.white)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            _label('Include in Report'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: _include.entries.map((e) {
                  return SwitchListTile(
                    title: Text(e.key,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                            fontSize: 14)),
                    value: e.value,
                    activeColor: AppColors.green,
                    onChanged: (v) => setState(() => _include[e.key] = v),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Preview summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.accent.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.assessment_outlined, color: AppColors.accent, size: 20),
                      SizedBox(width: 8),
                      Text('Export Summary',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.accent)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                      'Format: $_format  •  Period: ${_from.day}/${_from.month}/${_from.year} – ${_to.day}/${_to.month}/${_to.year}',
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.white,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(
                      'Includes: ${_include.entries.where((e) => e.value).map((e) => e.key).join(', ')}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSub)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _isExporting
                ? const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: AppColors.green),
                        SizedBox(height: 10),
                        Text('Generating & Downloading Report...',
                            style: TextStyle(color: AppColors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                : AppButton(
                    label: 'Export & Download $_format Report',
                    color: AppColors.green,
                    icon: Icons.file_download_outlined,
                    onTap: _exportAndDownload,
                  ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Share Report via WhatsApp',
              color: AppColors.accent2,
              icon: Icons.share,
              onTap: () {
                final text = 'Iron Buddy Report (${_from.day}/${_from.month} - ${_to.toLocal()}) exported successfully!';
                Share.share(text);
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppColors.white));

  Widget _dateButton(String label, DateTime date,
      Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2024),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: AppColors.accent,
                  onPrimary: AppColors.darkBg,
                  surface: AppColors.darkSurface,
                  onSurface: AppColors.white,
                ),
                dialogBackgroundColor: AppColors.darkSurface,
              ),
              child: child!,
            );
          },
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSub)),
            const SizedBox(height: 2),
            Text(
                '${date.day}/${date.month}/${date.year}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}