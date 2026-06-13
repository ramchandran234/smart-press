// lib/features/dashboard/screens/daily_schedule_screen.dart
// PPT Screen 6 — Daily Schedule Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class DailyScheduleScreen extends StatefulWidget {
  const DailyScheduleScreen({super.key});

  @override
  State<DailyScheduleScreen> createState() =>
      _DailyScheduleScreenState();
}

class _DailyScheduleScreenState
    extends State<DailyScheduleScreen> {
  int _selectedDay = 0;

  final _days = [
    {'label': 'Today', 'date': '05'},
    {'label': 'Tue', 'date': '06'},
    {'label': 'Wed', 'date': '07'},
    {'label': 'Thu', 'date': '08'},
    {'label': 'Fri', 'date': '09'},
    {'label': 'Sat', 'date': '10'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Schedule'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Slot',
              onPressed: () => context.push('/schedule-slot')),
        ],
      ),
      body: Column(
        children: [
          // Day Picker
          Container(
            color: AppColors.darkBg,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
            child: SizedBox(
              height: 68,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                itemBuilder: (_, i) {
                  final selected = _selectedDay == i;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedDay = i),
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      width: 60,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.accent
                            : AppColors.accent2
                                .withOpacity(0.25),
                        borderRadius:
                            BorderRadius.circular(12),
                        border: selected
                            ? Border.all(
                                color: AppColors.gold,
                                width: 1.5)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(_days[i]['label']!,
                              style: TextStyle(
                                  color: selected
                                      ? AppColors.white
                                      : AppColors.textSub,
                                  fontSize: 11,
                                  fontWeight:
                                      FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(_days[i]['date']!,
                              style: TextStyle(
                                  color: selected
                                      ? AppColors.white
                                      : AppColors.textSub,
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Summary chips
          Container(
            color: AppColors.highlight,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _chip('5 Pickups', AppColors.orange),
                const SizedBox(width: 10),
                _chip('7 Deliveries', AppColors.green),
                const SizedBox(width: 10),
                _chip('2 Pending', AppColors.red),
              ],
            ),
          ),

          // Schedule List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _slotHeader(
                    '🌅 Morning  (9 AM – 12 PM)', AppColors.orange),
                _scheduleCard(
                  type: 'Pickup',
                  name: 'Priya Sharma',
                  address: 'Koramangala 4th Block',
                  time: '9:00 AM',
                  garments: '5 items',
                  color: AppColors.orange,
                  done: false,
                ),
                _scheduleCard(
                  type: 'Pickup',
                  name: 'Ravi Kumar',
                  address: 'Indiranagar 100 Feet Rd',
                  time: '10:30 AM',
                  garments: '3 items',
                  color: AppColors.orange,
                  done: true,
                ),
                const SizedBox(height: 16),
                _slotHeader(
                    '🌆 Evening  (4 PM – 8 PM)', AppColors.green),
                _scheduleCard(
                  type: 'Delivery',
                  name: 'Anita Mehta',
                  address: 'HSR Layout Sector 7',
                  time: '4:00 PM',
                  garments: '₹340 • Paid',
                  color: AppColors.green,
                  done: false,
                ),
                _scheduleCard(
                  type: 'Delivery',
                  name: 'Suresh Babu',
                  address: 'BTM Layout Stage 2',
                  time: '5:30 PM',
                  garments: '₹220 • Unpaid',
                  color: AppColors.green,
                  done: false,
                ),
                _scheduleCard(
                  type: 'Pickup',
                  name: 'Deepa Nair',
                  address: 'Jayanagar 4th Block',
                  time: '7:00 PM',
                  garments: '6 items',
                  color: AppColors.orange,
                  done: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _slotHeader(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 8),
          Text(text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color)),
        ],
      ),
    );
  }

  Widget _scheduleCard({
    required String type,
    required String name,
    required String address,
    required String time,
    required String garments,
    required Color color,
    required bool done,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Time column
            SizedBox(
              width: 52,
              child: Column(
                children: [
                  Text(time.split(' ')[0],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 14)),
                  Text(time.split(' ')[1],
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textSub)),
                ],
              ),
            ),
            // Divider
            Container(
                width: 1,
                height: 50,
                color: color.withOpacity(0.3),
                margin:
                    const EdgeInsets.symmetric(horizontal: 10)),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  Text(address,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSub)),
                  const SizedBox(height: 4),
                  Text(garments,
                      style: TextStyle(
                          fontSize: 11, color: color)),
                ],
              ),
            ),
            // Badge
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: done
                        ? AppColors.green.withOpacity(0.12)
                        : color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    done ? '✅ Done' : type,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color:
                            done ? AppColors.green : color),
                  ),
                ),
                const SizedBox(height: 6),
                Icon(Icons.call_outlined,
                    size: 18, color: AppColors.accent2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}