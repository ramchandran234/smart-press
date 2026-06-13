// lib/core/models/invoice_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceModel {
  final String id;
  final String invoiceId;
  final String ownerId;
  final String orderId;
  final String customerId;
  final double subtotal;
  final double deliveryCharge;
  final double discount;
  final double totalAmount;
  final bool isPaid;
  final DateTime? paidAt;
  final DateTime? dueDate;
  final String? pdfUrl;
  final List<String> sharedVia;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InvoiceModel({
    required this.id,
    required this.invoiceId,
    required this.ownerId,
    required this.orderId,
    required this.customerId,
    required this.subtotal,
    this.deliveryCharge = 0,
    this.discount = 0,
    required this.totalAmount,
    this.isPaid = false,
    this.paidAt,
    this.dueDate,
    this.pdfUrl,
    this.sharedVia = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      id: map['id'] ?? '',
      invoiceId: map['invoiceId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      orderId: map['orderId'] ?? '',
      customerId: map['customerId'] ?? '',
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      deliveryCharge: (map['deliveryCharge'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      isPaid: map['isPaid'] ?? false,
      paidAt: map['paidAt'] != null
          ? (map['paidAt'] as Timestamp).toDate()
          : null,
      dueDate: map['dueDate'] != null
          ? (map['dueDate'] as Timestamp).toDate()
          : null,
      pdfUrl: map['pdfUrl'],
      sharedVia: List<String>.from(map['sharedVia'] ?? []),
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
      'invoiceId': invoiceId,
      'ownerId': ownerId,
      'orderId': orderId,
      'customerId': customerId,
      'subtotal': subtotal,
      'deliveryCharge': deliveryCharge,
      'discount': discount,
      'totalAmount': totalAmount,
      'isPaid': isPaid,
      'paidAt': paidAt,
      'dueDate': dueDate,
      'pdfUrl': pdfUrl,
      'sharedVia': sharedVia,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Helper methods
  double get balanceAmount => totalAmount - (paidAt != null ? totalAmount : 0);

  bool get isOverdue => dueDate != null && dueDate!.isBefore(DateTime.now()) && !isPaid;

  bool get hasPdf => pdfUrl != null && pdfUrl!.isNotEmpty;

  String get status {
    if (isPaid) return 'Paid';
    if (isOverdue) return 'Overdue';
    return 'Pending';
  }

  // Check if shared via specific method
  bool isSharedVia(String method) => sharedVia.contains(method);
}