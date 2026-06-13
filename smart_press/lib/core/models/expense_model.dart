// lib/core/models/expense_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String ownerId;
  final String? supplierId;
  final String description;
  final String category; // 'Detergent', 'Transport', 'Equipment', 'Salary', 'Rent', 'Other'
  final double amount;
  final String paymentMode; // 'UPI', 'Cash', 'Cheque', 'Bank Transfer'
  final DateTime expenseDate;
  final String? receipt;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExpenseModel({
    required this.id,
    required this.ownerId,
    this.supplierId,
    required this.description,
    this.category = 'Other',
    required this.amount,
    this.paymentMode = 'Cash',
    required this.expenseDate,
    this.receipt,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      supplierId: map['supplierId'],
      description: map['description'] ?? '',
      category: map['category'] ?? 'Other',
      amount: (map['amount'] ?? 0).toDouble(),
      paymentMode: map['paymentMode'] ?? 'Cash',
      expenseDate: map['expenseDate'] != null
          ? (map['expenseDate'] as Timestamp).toDate()
          : DateTime.now(),
      receipt: map['receipt'],
      notes: map['notes'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'supplierId': supplierId,
      'description': description,
      'category': category,
      'amount': amount,
      'paymentMode': paymentMode,
      'expenseDate': expenseDate,
      'receipt': receipt,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Helper methods
  String get categoryDisplay => category[0].toUpperCase() + category.substring(1);

  String get paymentModeDisplay => paymentMode.toUpperCase();

  bool get hasReceipt => receipt != null && receipt!.isNotEmpty;

  // Get month and year for grouping
  String get monthYear => '${expenseDate.month.toString().padLeft(2, '0')}/${expenseDate.year}';
}