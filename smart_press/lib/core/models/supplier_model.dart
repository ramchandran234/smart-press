// lib/core/models/supplier_model.dart
import '../utils/date_helper.dart';

class PaymentHistory {
  final double amount;
  final String? mode;
  final String? reference;
  final String? note;
  final String? screenshot;
  final DateTime paidAt;

  PaymentHistory({
    required this.amount,
    this.mode,
    this.reference,
    this.note,
    this.screenshot,
    required this.paidAt,
  });

  factory PaymentHistory.fromMap(Map<String, dynamic> map) {
    return PaymentHistory(
      amount: (map['amount'] ?? 0).toDouble(),
      mode: map['mode'],
      reference: map['reference'],
      note: map['note'],
      screenshot: map['screenshot'],
      paidAt: DateHelper.parseDateTime(map['paidAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'mode': mode,
      'reference': reference,
      'note': note,
      'screenshot': screenshot,
      'paidAt': paidAt,
    };
  }
}

class SupplierModel {
  final String id;
  final String ownerId;
  final String name;
  final String category; // 'Detergent', 'Transport', 'Equipment', 'Packaging', 'Other'
  final String? mobile;
  final String? address;
  final String? upiId;
  final String? bankAccount;
  final String? ifscCode;
  final String? qrImage;
  final double openingBalance;
  final double balance;
  final double totalPaid;
  final List<PaymentHistory> paymentHistory;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SupplierModel({
    required this.id,
    required this.ownerId,
    required this.name,
    this.category = 'Other',
    this.mobile,
    this.address,
    this.upiId,
    this.bankAccount,
    this.ifscCode,
    this.qrImage,
    this.openingBalance = 0,
    this.balance = 0,
    this.totalPaid = 0,
    this.paymentHistory = const [],
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory SupplierModel.fromMap(Map<String, dynamic> map) {
    return SupplierModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? 'Other',
      mobile: map['mobile'],
      address: map['address'],
      upiId: map['upiId'],
      bankAccount: map['bankAccount'],
      ifscCode: map['ifscCode'],
      qrImage: map['qrImage'],
      openingBalance: (map['openingBalance'] ?? 0).toDouble(),
      balance: (map['balance'] ?? 0).toDouble(),
      totalPaid: (map['totalPaid'] ?? 0).toDouble(),
      paymentHistory: (map['paymentHistory'] as List<dynamic>?)
          ?.map((p) => PaymentHistory.fromMap(p as Map<String, dynamic>))
          .toList() ?? [],
      isActive: map['isActive'] ?? true,
      createdAt: DateHelper.parseDateTime(map['createdAt']),
      updatedAt: DateHelper.parseDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'category': category,
      'mobile': mobile,
      'address': address,
      'upiId': upiId,
      'bankAccount': bankAccount,
      'ifscCode': ifscCode,
      'qrImage': qrImage,
      'openingBalance': openingBalance,
      'balance': balance,
      'totalPaid': totalPaid,
      'paymentHistory': paymentHistory.map((p) => p.toMap()).toList(),
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Helper methods
  String get categoryDisplay => category[0].toUpperCase() + category.substring(1);

  bool get hasOutstandingBalance => balance > 0;

  bool get hasUPI => upiId != null && upiId!.isNotEmpty;

  bool get hasBankDetails => bankAccount != null && bankAccount!.isNotEmpty;

  String get status => isActive ? 'Active' : 'Inactive';
}