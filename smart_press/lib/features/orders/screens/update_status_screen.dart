// lib/features/orders/screens/update_status_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/order_service.dart';

class UpdateStatusScreen extends StatefulWidget {
  final String orderId;
  const UpdateStatusScreen({super.key, required this.orderId});

  @override
  State<UpdateStatusScreen> createState() =>
      _UpdateStatusScreenState();
}

class _UpdateStatusScreenState
    extends State<UpdateStatusScreen> {
  int _currentStep = 0;
  bool _notifyCustomer = true;
  bool _isLoading = true;
  bool _submitting = false;
  final _noteController = TextEditingController();

  final List<Map<String, dynamic>> _steps = [
    {'label': 'Received', 'icon': Icons.inbox, 'color': AppColors.accent},
    {'label': 'Washing', 'icon': Icons.local_laundry_service, 'color': AppColors.accent2},
    {'label': 'Ironing', 'icon': Icons.iron, 'color': AppColors.orange},
    {'label': 'Ready', 'icon': Icons.check_circle_outline, 'color': AppColors.gold},
    {'label': 'Delivered', 'icon': Icons.done_all, 'color': AppColors.green},
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentStatus();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentStatus() async {
    try {
      final res = await OrderService.getOrderById(widget.orderId);
      if (res['success'] == true) {
        final status = res['order']['status'] as String? ?? 'received';
        final statusIdxMap = {
          'received': 0,
          'washing': 1,
          'ironing': 2,
          'ready': 3,
          'delivered': 4,
        };
        setState(() {
          _currentStep = statusIdxMap[status.toLowerCase()] ?? 0;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus() async {
    final status = _steps[_currentStep]['label'].toLowerCase();
    final note = _noteController.text.trim();

    setState(() => _submitting = true);

    try {
      final res = await OrderService.updateStatus(widget.orderId, status, note: note);
      setState(() => _submitting = false);

      if (!mounted) return;

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to: ${_steps[_currentStep]['label']}'),
            backgroundColor: AppColors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['error'] ?? 'Failed to update status'),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(title: Text('Update — ${widget.orderId}')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current status card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.receipt_long,
                            color: AppColors.accent2),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Current Status',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSub)),
                            Text(
                              _steps[_currentStep]['label'],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: _steps[_currentStep]['color']),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text('Select New Status',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),

                  // Status grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: _steps.length,
                    itemBuilder: (_, i) {
                      final step = _steps[i];
                      final selected = _currentStep == i;
                      final passed = i < _currentStep;
                      final color = step['color'] as Color;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _currentStep = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: selected
                                ? color
                                : passed
                                    ? color.withOpacity(0.08)
                                    : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: selected
                                    ? color
                                    : AppColors.cardBorder,
                                width: selected ? 2 : 1),
                          ),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(step['icon'] as IconData,
                                  color: selected
                                      ? AppColors.white
                                      : color,
                                  size: 28),
                              const SizedBox(height: 6),
                              Text(step['label'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: selected
                                          ? AppColors.white
                                          : color)),
                              if (passed)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Icon(Icons.check_circle,
                                      size: 12,
                                      color: color.withOpacity(0.6)),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Notes
                  const Text('Add Note (Optional)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText:
                          'e.g. Ready for pickup, stain treated...',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notify toggle
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sms_outlined,
                            color: AppColors.accent2),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text('Notify Customer via SMS',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600)),
                              Text('Send status update to customer',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSub)),
                            ],
                          ),
                        ),
                        Switch(
                          value: _notifyCustomer,
                          activeColor: AppColors.accent,
                          onChanged: (v) =>
                              setState(() => _notifyCustomer = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Confirm button
                  _submitting
                      ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                      : SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _updateStatus,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _steps[_currentStep]['color'] as Color,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              'Confirm — ${_steps[_currentStep]['label']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}