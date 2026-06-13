// lib/features/logistics/screens/schedule_screen.dart
// PPT Screen 16 — Schedule Pickup/Delivery Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() =>
      _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String _type = 'Pickup';
  String _slot = 'Morning (9AM–12PM)';
  DateTime _date = DateTime.now().add(const Duration(days: 1));

  final _slots = [
    'Morning (9AM–12PM)',
    'Afternoon (12PM–4PM)',
    'Evening (4PM–8PM)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Schedule Pickup / Delivery')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type toggle
            _label('Type'),
            const SizedBox(height: 8),
            Row(
              children: ['Pickup', 'Delivery'].map((t) {
                final sel = _type == t;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _type = t),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 14),
                      decoration: BoxDecoration(
                        color: sel
                            ? (t == 'Pickup'
                                ? AppColors.orange
                                : AppColors.green)
                            : AppColors.white,
                        borderRadius:
                            BorderRadius.circular(12),
                        border: Border.all(
                            color: sel
                                ? (t == 'Pickup'
                                    ? AppColors.orange
                                    : AppColors.green)
                                : AppColors.cardBorder),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            t == 'Pickup'
                                ? Icons.local_shipping
                                : Icons.delivery_dining,
                            color: sel
                                ? AppColors.white
                                : AppColors.textSub,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(t,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
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

            // Customer
            _label('Customer'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.highlight,
                    child: Icon(Icons.person_outline,
                        color: AppColors.accent2),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('Priya Sharma',
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),
                        Text('+91 98765 43210',
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSub)),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text('Change')),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Date picker
            _label('Date'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now()
                      .add(const Duration(days: 30)),
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
                  border:
                      Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: AppColors.accent2, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      '${_date.day} ${_monthName(_date.month)} ${_date.year}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down,
                        color: AppColors.textSub),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Time slot
            _label('Time Slot'),
            const SizedBox(height: 8),
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
                        size: 20,
                      ),
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
                            color: AppColors.accent, size: 18),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            // Address
            _label('Delivery Address'),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: 'Koramangala 4th Block, Bengaluru',
              maxLines: 2,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on_outlined,
                    color: AppColors.accent2),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            _label('Notes for Delivery Partner'),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g. Call before arriving...',
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              label: 'Confirm Schedule',
              color: _type == 'Pickup'
                  ? AppColors.orange
                  : AppColors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '$_type scheduled for $_slot'),
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

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppColors.textDark));

  String _monthName(int m) => [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];
}