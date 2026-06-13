// lib/core/models/order_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Garment {
  final String name;
  final int qty;
  final double rate;
  final String? service;
  final double? amount;

  Garment({
    required this.name,
    required this.qty,
    required this.rate,
    this.service,
    this.amount,
  });

  factory Garment.fromMap(Map<String, dynamic> map) {
    return Garment(
      name: map['name'] ?? '',
      qty: map['qty'] ?? 0,
      rate: (map['rate'] ?? 0).toDouble(),
      service: map['service'],
      amount: map['amount']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'qty': qty,
      'rate': rate,
      'service': service,
      'amount': amount,
    };
  }

  double get total => amount ?? (qty * rate);
}

class StatusHistory {
  final String status;
  final String? note;
  final String? updatedBy;
  final DateTime time;

  StatusHistory({
    required this.status,
    this.note,
    this.updatedBy,
    required this.time,
  });

  factory StatusHistory.fromMap(Map<String, dynamic> map) {
    return StatusHistory(
      status: map['status'] ?? '',
      note: map['note'],
      updatedBy: map['updatedBy'],
      time: map['time'] != null
          ? (map['time'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'note': note,
      'updatedBy': updatedBy,
      'time': time,
    };
  }
}

class OrderModel {
  final String id;
  final String orderId;
  final String ownerId;
  final String customerId;
  final List<Garment> garments;
  final String orderType; // 'walk-in', 'pickup', 'delivery'
  final String? serviceType;
  final String status; // 'received', 'washing', 'ironing', 'ready', 'delivered', 'cancelled'
  final List<StatusHistory> statusHistory;
  final double subtotal;
  final double deliveryCharge;
  final double discount;
  final double totalAmount;
  final double paidAmount;
  final bool isPaid;
  final String? paymentMode;
  final DateTime? paymentDate;
  final DateTime? expectedDate;
  final DateTime? deliveredAt;
  final DateTime? pickupDate;
  final String? pickupSlot;
  final DateTime? deliveryDate;
  final String? deliverySlot;
  final String? pickupAddress;
  final String? deliveryAddress;
  final String? notes;
  final String? qrCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.orderId,
    required this.ownerId,
    required this.customerId,
    required this.garments,
    this.orderType = 'walk-in',
    this.serviceType,
    this.status = 'received',
    this.statusHistory = const [],
    this.subtotal = 0,
    this.deliveryCharge = 0,
    this.discount = 0,
    this.totalAmount = 0,
    this.paidAmount = 0,
    this.isPaid = false,
    this.paymentMode,
    this.paymentDate,
    this.expectedDate,
    this.deliveredAt,
    this.pickupDate,
    this.pickupSlot,
    this.deliveryDate,
    this.deliverySlot,
    this.pickupAddress,
    this.deliveryAddress,
    this.notes,
    this.qrCode,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      orderId: map['orderId'] ?? '',
      ownerId: map['ownerId'] ?? '',
      customerId: map['customerId'] ?? '',
      garments: (map['garments'] as List<dynamic>?)
          ?.map((g) => Garment.fromMap(g as Map<String, dynamic>))
          .toList() ?? [],
      orderType: map['orderType'] ?? 'walk-in',
      serviceType: map['serviceType'],
      status: map['status'] ?? 'received',
      statusHistory: (map['statusHistory'] as List<dynamic>?)
          ?.map((h) => StatusHistory.fromMap(h as Map<String, dynamic>))
          .toList() ?? [],
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      deliveryCharge: (map['deliveryCharge'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      paidAmount: (map['paidAmount'] ?? 0).toDouble(),
      isPaid: map['isPaid'] ?? false,
      paymentMode: map['paymentMode'],
      paymentDate: map['paymentDate'] != null
          ? (map['paymentDate'] as Timestamp).toDate()
          : null,
      expectedDate: map['expectedDate'] != null
          ? (map['expectedDate'] as Timestamp).toDate()
          : null,
      deliveredAt: map['deliveredAt'] != null
          ? (map['deliveredAt'] as Timestamp).toDate()
          : null,
      pickupDate: map['pickupDate'] != null
          ? (map['pickupDate'] as Timestamp).toDate()
          : null,
      pickupSlot: map['pickupSlot'],
      deliveryDate: map['deliveryDate'] != null
          ? (map['deliveryDate'] as Timestamp).toDate()
          : null,
      deliverySlot: map['deliverySlot'],
      pickupAddress: map['pickupAddress'],
      deliveryAddress: map['deliveryAddress'],
      notes: map['notes'],
      qrCode: map['qrCode'],
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
      'orderId': orderId,
      'ownerId': ownerId,
      'customerId': customerId,
      'garments': garments.map((g) => g.toMap()).toList(),
      'orderType': orderType,
      'serviceType': serviceType,
      'status': status,
      'statusHistory': statusHistory.map((h) => h.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryCharge': deliveryCharge,
      'discount': discount,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'isPaid': isPaid,
      'paymentMode': paymentMode,
      'paymentDate': paymentDate,
      'expectedDate': expectedDate,
      'deliveredAt': deliveredAt,
      'pickupDate': pickupDate,
      'pickupSlot': pickupSlot,
      'deliveryDate': deliveryDate,
      'deliverySlot': deliverySlot,
      'pickupAddress': pickupAddress,
      'deliveryAddress': deliveryAddress,
      'notes': notes,
      'qrCode': qrCode,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Helper methods
  double get balanceAmount => totalAmount - paidAmount;

  bool get isCompleted => status == 'delivered';

  bool get isCancelled => status == 'cancelled';

  bool get isReady => status == 'ready';

  String get statusDisplay => status[0].toUpperCase() + status.substring(1);

  // Calculate totals
  double calculateSubtotal() {
    return garments.fold(0, (sum, garment) => sum + garment.total);
  }

  double calculateTotal() {
    return subtotal + deliveryCharge - discount;
  }
}