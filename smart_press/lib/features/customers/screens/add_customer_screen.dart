import 'package:flutter/material.dart';

class AddCustomerScreen extends StatelessWidget {
  const AddCustomerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Customer')),
      body: const Center(child: Text('Add Customer Screen')),
    );
  }
}
