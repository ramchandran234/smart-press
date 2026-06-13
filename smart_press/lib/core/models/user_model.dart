// lib/core/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel {
  final String id;
  final String name;
  final String mobile;
  final String role;
  final String? shopName;
  final String? shopImage;
  final String? address;
  final String? city;
  final String? gstin;
  final String? upiId;
  final String? qrImage;
  final bool isVerified;
  final bool isActive;
  final String? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.role,
    this.shopName,
    this.shopImage,
    this.address,
    this.city,
    this.gstin,
    this.upiId,
    this.qrImage,
    this.isVerified = false,
    this.isActive = true,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  // Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      mobile: map['mobile'] ?? '',
      role: map['role'] ?? 'customer',
      shopName: map['shopName'],
      shopImage: map['shopImage'],
      address: map['address'],
      city: map['city'],
      gstin: map['gstin'],
      upiId: map['upiId'],
      qrImage: map['qrImage'],
      isVerified: map['isVerified'] ?? false,
      isActive: map['isActive'] ?? true,
      fcmToken: map['fcmToken'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'role': role,
      'shopName': shopName,
      'shopImage': shopImage,
      'address': address,
      'city': city,
      'gstin': gstin,
      'upiId': upiId,
      'qrImage': qrImage,
      'isVerified': isVerified,
      'isActive': isActive,
      'fcmToken': fcmToken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Create copy with updated fields
  UserModel copyWith({
    String? name,
    String? shopName,
    String? shopImage,
    String? address,
    String? city,
    String? gstin,
    String? upiId,
    String? qrImage,
    bool? isVerified,
    bool? isActive,
    String? fcmToken,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      mobile: mobile,
      role: role,
      shopName: shopName ?? this.shopName,
      shopImage: shopImage ?? this.shopImage,
      address: address ?? this.address,
      city: city ?? this.city,
      gstin: gstin ?? this.gstin,
      upiId: upiId ?? this.upiId,
      qrImage: qrImage ?? this.qrImage,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Check if user is owner
  bool get isOwner => role == 'owner';

  // Check if user is customer
  bool get isCustomer => role == 'customer';
}