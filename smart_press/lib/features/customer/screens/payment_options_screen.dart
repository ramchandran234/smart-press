import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class PaymentOptionsScreen extends StatefulWidget {
  const PaymentOptionsScreen({super.key});

  @override
  State<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  final List<Map<String, dynamic>> _savedCards = [
    {
      'type': 'card',
      'last4': '4567',
      'brand': 'Visa',
      'expiry': '12/26',
      'isDefault': true,
    },
    {
      'type': 'card',
      'last4': '8901',
      'brand': 'Mastercard',
      'expiry': '08/25',
      'isDefault': false,
    },
  ];

  final List<Map<String, dynamic>> _savedUPI = [
    {
      'id': 'john.doe@upi',
      'app': 'Google Pay',
      'isDefault': true,
    },
    {
      'id': 'john.doe@paytm',
      'app': 'Paytm',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Options'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addPaymentMethod,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saved Cards
            const Text(
              'Saved Cards',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._savedCards.map((card) => _buildCardTile(card)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addPaymentMethod,
              icon: const Icon(Icons.add),
              label: const Text('Add New Card'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 32),

            // UPI IDs
            const Text(
              'UPI IDs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._savedUPI.map((upi) => _buildUPITile(upi)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _addPaymentMethod,
              icon: const Icon(Icons.add),
              label: const Text('Add UPI ID'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 32),

            // Other Payment Methods
            const Text(
              'Other Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildOtherPaymentOption(
              'Net Banking',
              'Pay using your bank account',
              Icons.account_balance,
              () {
                // TODO: Navigate to net banking
              },
            ),
            const SizedBox(height: 12),
            _buildOtherPaymentOption(
              'Digital Wallets',
              'Paytm, Mobikwik, Ola Money',
              Icons.account_balance_wallet,
              () {
                // TODO: Navigate to wallets
              },
            ),
            const SizedBox(height: 12),
            _buildOtherPaymentOption(
              'Cash on Delivery',
              'Pay when you receive your order',
              Icons.money,
              () {
                // TODO: Enable COD
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTile(Map<String, dynamic> card) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.credit_card,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${card['brand']} **** ${card['last4']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (card['isDefault']) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    'Expires ${card['expiry']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteCard(card);
                } else if (value == 'set_default') {
                  _setDefaultCard(card);
                }
              },
              itemBuilder: (context) => [
                if (!card['isDefault'])
                  const PopupMenuItem(
                    value: 'set_default',
                    child: Text('Set as Default'),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUPITile(Map<String, dynamic> upi) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        upi['id'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (upi['isDefault']) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    upi['app'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _deleteUPI(upi);
                } else if (value == 'set_default') {
                  _setDefaultUPI(upi);
                }
              },
              itemBuilder: (context) => [
                if (!upi['isDefault'])
                  const PopupMenuItem(
                    value: 'set_default',
                    child: Text('Set as Default'),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherPaymentOption(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _addPaymentMethod() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Add Debit/Credit Card'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to add card screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Add UPI ID'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to add UPI screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Link Bank Account'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to link bank screen
              },
            ),
          ],
        ),
      ),
    );
  }

  void _deleteCard(Map<String, dynamic> card) {
    setState(() {
      _savedCards.remove(card);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card deleted successfully')),
    );
  }

  void _setDefaultCard(Map<String, dynamic> card) {
    setState(() {
      for (var c in _savedCards) {
        c['isDefault'] = false;
      }
      card['isDefault'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Default card updated')),
    );
  }

  void _deleteUPI(Map<String, dynamic> upi) {
    setState(() {
      _savedUPI.remove(upi);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('UPI ID deleted successfully')),
    );
  }

  void _setDefaultUPI(Map<String, dynamic> upi) {
    setState(() {
      for (var u in _savedUPI) {
        u['isDefault'] = false;
      }
      upi['isDefault'] = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Default UPI ID updated')),
    );
  }
}