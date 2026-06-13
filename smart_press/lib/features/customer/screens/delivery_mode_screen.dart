// lib/features/customer/screens/delivery_mode_screen.dart
// Screen C3 — Delivery / Pickup Mode Selection
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class DeliveryModeScreen extends StatefulWidget {
  const DeliveryModeScreen({super.key});

  @override
  State<DeliveryModeScreen> createState() =>
      _DeliveryModeScreenState();
}

class _DeliveryModeScreenState
    extends State<DeliveryModeScreen> {
  String _mode = 'Home Delivery';
  String _slot = 'Evening (4PM–8PM)';
  DateTime _date =
      DateTime.now().add(const Duration(days: 1));

  final _modes = [
    {'label': 'Home Delivery',
      'icon': Icons.delivery_dining,
      'desc': 'We deliver to your doorstep',
      'color': AppColors.green},
    {'label': 'Store Pickup',
      'icon': Icons.store,
      'desc': 'Collect from our store',
      'color': AppColors.accent2},
    {'label': 'Scheduled Slot',
      'icon': Icons.schedule,
      'desc': 'Pick your preferred time',
      'color': AppColors.orange},
  ];

  final _slots = [
    'Morning (9AM–12PM)',
    'Afternoon (12PM–4PM)',
    'Evening (4PM–8PM)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        title: const Text('Select Delivery Mode'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('How do you want your clothes?',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textDark)),
            const SizedBox(height: 16),

            // Mode selection
            ..._modes.map((m) {
              final sel = _mode == m['label'];
              final color = m['color'] as Color;
              return GestureDetector(
                onTap: () =>
                    setState(() => _mode = m['label'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: sel
                        ? color.withOpacity(0.08)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: sel
                            ? color
                            : AppColors.cardBorder,
                        width: sel ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                            m['icon'] as IconData,
                            color: color, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(m['label'] as String,
                                style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 15,
                                    color: sel
                                        ? color
                                        : AppColors.textDark)),
                            Text(m['desc'] as String,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSub)),
                          ],
                        ),
                      ),
                      if (sel)
                        Icon(Icons.check_circle,
                            color: color, size: 22),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            // Date picker
            const Text('Select Date',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now()
                      .add(const Duration(days: 14)),
                );
                if (picked != null) {
                  setState(() => _date = picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: AppColors.accent2, size: 20),
                    const SizedBox(width: 10),
                    Text(
                        '${_date.day}/${_date.month}/${_date.year}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down,
                        color: AppColors.textSub),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time slot
            const Text('Select Time Slot',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            const SizedBox(height: 10),
            ..._slots.map((slot) {
              final sel = _slot == slot;
              return GestureDetector(
                onTap: () => setState(() => _slot = slot),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: sel
                        ? AppColors.accent.withOpacity(0.08)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: sel
                            ? AppColors.accent
                            : AppColors.cardBorder,
                        width: sel ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        slot.contains('Morning')
                            ? Icons.wb_sunny_outlined
                            : slot.contains('Afternoon')
                                ? Icons.wb_cloudy_outlined
                                : Icons.nights_stay_outlined,
                        color: sel
                            ? AppColors.accent
                            : AppColors.textSub,
                        size: 20),
                      const SizedBox(width: 12),
                      Text(slot,
                          style: TextStyle(
                              fontWeight: sel
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: sel
                                  ? AppColors.accent
                                  : AppColors.textDark)),
                      const Spacer(),
                      if (sel)
                        const Icon(Icons.check_circle,
                            color: AppColors.accent,
                            size: 18),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            AppButton(
              label: 'Confirm $_mode',
              color: AppColors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '$_mode confirmed for $_slot'),
                    backgroundColor: AppColors.green,
                  ),
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}