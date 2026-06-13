// lib/features/invoices/screens/share_invoice_screen.dart
// PPT Screen 25 — Share Invoice Screen
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ShareInvoiceScreen extends StatelessWidget {
  final String invoiceId;
  const ShareInvoiceScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Invoice')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10)
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.picture_as_pdf,
                      size: 60, color: AppColors.red),
                  const SizedBox(height: 10),
                  Text('Invoice_$invoiceId.pdf',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 4),
                  const Text('Smart Press  •  05 May 2026  •  ₹330',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSub)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text('Share via',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 14),

            // Share options
            _shareOption(
              icon: Icons.chat,
              color: const Color(0xFF25D366),
              label: 'WhatsApp',
              subtitle: 'Send as PDF to customer',
              onTap: () => _showSnack(context, 'Sharing via WhatsApp...'),
            ),
            _shareOption(
              icon: Icons.sms_outlined,
              color: AppColors.accent2,
              label: 'SMS with Link',
              subtitle: 'Send download link via SMS',
              onTap: () => _showSnack(context, 'Sending SMS...'),
            ),
            _shareOption(
              icon: Icons.email_outlined,
              color: AppColors.orange,
              label: 'Email',
              subtitle: 'Send invoice to email address',
              onTap: () => _showSnack(context, 'Opening email...'),
            ),
            _shareOption(
              icon: Icons.link,
              color: AppColors.accent,
              label: 'Copy Link',
              subtitle: 'Copy invoice link to clipboard',
              onTap: () => _showSnack(context, 'Link copied!'),
            ),
            _shareOption(
              icon: Icons.download_outlined,
              color: AppColors.textSub,
              label: 'Download to Device',
              subtitle: 'Save PDF locally',
              onTap: () => _showSnack(context, 'Downloading...'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shareOption({
    required IconData icon,
    required Color color,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSub)),
        trailing: const Icon(Icons.chevron_right,
            color: AppColors.cardBorder),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.green),
    );
  }
} 