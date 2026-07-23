// lib/core/models/customer_model.dart
import '../utils/date_helper.dart';

class CustomerModel {
  final String id;
  final String ownerId;
  final String name;
  final String mobile;
  final String? whatsapp;
  final String? addressLine1;
  final String? area;
  final String? city;
  final String? landmark;
  final String? notes;
  final String? preferredSlot;
  final bool isActive;
  final int totalOrders;
  final double totalSpend;
  final double balance;
  final DateTime? lastOrderAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomerModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.mobile,
    this.whatsapp,
    this.addressLine1,
    this.area,
    this.city,
    this.landmark,
    this.notes,
    this.preferredSlot,
    this.isActive = true,
    this.totalOrders = 0,
    this.totalSpend = 0,
    this.balance = 0,
    this.lastOrderAt,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      whatsapp: map['whatsapp'],
      addressLine1: map['addressLine1'],
      area: map['area'],
      city: map['city'],
      landmark: map['landmark'],
      notes: map['notes'],
      preferredSlot: map['preferredSlot'],
      isActive: map['isActive'] ?? true,
      totalOrders: map['totalOrders'] ?? 0,
      totalSpend: (map['totalSpend'] ?? 0).toDouble(),
      balance: (map['balance'] ?? 0).toDouble(),
      lastOrderAt: DateHelper.parseDateTime(map['lastOrderAt']),
      createdAt: DateHelper.parseDateTime(map['createdAt']),
      updatedAt: DateHelper.parseDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'mobile': mobile,
      'whatsapp': whatsapp,
      'addressLine1': addressLine1,
      'area': area,
      'city': city,
      'landmark': landmark,
      'notes': notes,
      'preferredSlot': preferredSlot,
      'isActive': isActive,
      'totalOrders': totalOrders,
      'totalSpend': totalSpend,
      'balance': balance,
      'lastOrderAt': lastOrderAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Get full address
  String get fullAddress {
    final parts = [addressLine1, area, city, landmark].where((part) => part != null && part.isNotEmpty);
    return parts.join(', ');
  }

  // Check if customer has outstanding balance
  bool get hasOutstandingBalance => balance > 0;

  // Get customer status
  String get status => isActive ? 'Active' : 'Inactive';
}