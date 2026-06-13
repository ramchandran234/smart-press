// lib/features/reports/screens/export_screen.dart
// PPT Screen 38 — Export Screen
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  String _format = 'PDF';
  DateTime _from =
      DateTime.now().subtract(const Duration(days: 30));
  DateTime _to = DateTime.now();
  final _formats = ['PDF', 'CSV', 'Excel'];
  final Map<String, bool> _include = {
    'Orders': true,
    'Payments': true,
    'Expenses': false,
    'Invoices': true,
    'Suppliers': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Report')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Date Range'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _dateButton('From', _from,
                    (d) => setState(() => _from = d))),
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10),
                  child: Text('→',
                      style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textSub)),
                ),
                Expanded(child: _dateButton('To', _to,
                    (d) => setState(() => _to = d))),
              ],
            ),
            const SizedBox(height: 20),

            _label('Format'),
            const SizedBox(height: 10),
            Row(
              children: _formats.map((f) {
                final sel = _format == f;
                return Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _format = f),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.green
                            : AppColors.white,
                        borderRadius:
                            BorderRadius.circular(10),
                        border: Border.all(
                            color: sel
                                ? AppColors.green
                                : AppColors.cardBorder),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            f == 'PDF'
                                ? Icons.picture_as_pdf
                                : f == 'CSV'
                                    ? Icons.table_chart
                                    : Icons.grid_on,
                            color: sel
                                ? AppColors.white
                                : AppColors.textSub,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(f,
                              style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 12,
                                  color: sel
                                      ? AppColors.white
                                      : AppColors.textSub)),
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
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.cardBorder),
              ),
              child: Column(
                children: _include.entries.map((e) {
                  return SwitchListTile(
                    title: Text(e.key,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600)),
                    value: e.value,
                    activeColor: AppColors.green,
                    onChanged: (v) => setState(
                        () => _include[e.key] = v),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Preview summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.highlight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text('Export Summary',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent2)),
                  const SizedBox(height: 8),
                  Text(
                      'Format: $_format  •  Period: ${_from.day}/${_from.month} – ${_to.day}/${_to.month}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSub)),
                  Text(
                      'Includes: ${_include.entries.where((e) => e.value).map((e) => e.key).join(', ')}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSub)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Export $_format',
              color: AppColors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Exporting as $_format...'),
                    backgroundColor: AppColors.green,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Share via WhatsApp / Email',
              color: AppColors.accent2,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppColors.textDark));

  Widget _dateButton(String label, DateTime date,
      Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2024),
          lastDate: DateTime.now(),
        );
        if (picked != null) onPicked(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSub)),
            Text(
                '${date.day}/${date.month}/${date.year}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}