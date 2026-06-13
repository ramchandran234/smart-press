// lib/core/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_service.dart';

class FirestoreService {
  // Generic CRUD operations

  // Create document
  static Future<String> createDocument({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    final docRef = FirebaseService.firestore.collection(collection).doc();
    data['id'] = docRef.id;
    data['createdAt'] = FieldValue.serverTimestamp();
    data['updatedAt'] = FieldValue.serverTimestamp();

    await docRef.set(data);
    return docRef.id;
  }

  // Read document
  static Future<Map<String, dynamic>?> getDocument({
    required String collection,
    required String documentId,
  }) async {
    final doc = await FirebaseService.firestore
        .collection(collection)
        .doc(documentId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      data['id'] = doc.id;
      return data;
    }
    return null;
  }

  // Update document
  static Future<void> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await FirebaseService.firestore
        .collection(collection)
        .doc(documentId)
        .update(data);
  }

  // Delete document
  static Future<void> deleteDocument({
    required String collection,
    required String documentId,
  }) async {
    await FirebaseService.firestore
        .collection(collection)
        .doc(documentId)
        .delete();
  }

  // Get collection with optional filters
  static Future<List<Map<String, dynamic>>> getCollection({
    required String collection,
    Query Function(Query query)? queryBuilder,
  }) async {
    Query query = FirebaseService.firestore.collection(collection);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  // Real-time listener for collection
  static Stream<List<Map<String, dynamic>>> listenToCollection({
    required String collection,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = FirebaseService.firestore.collection(collection);

    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Real-time listener for document
  static Stream<Map<String, dynamic>?> listenToDocument({
    required String collection,
    required String documentId,
  }) {
    return FirebaseService.firestore
        .collection(collection)
        .doc(documentId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return data;
      }
      return null;
    });
  }

  // Batch operations
  static Future<void> batchWrite(List<WriteBatch> operations) async {
    final batch = FirebaseService.firestore.batch();

    for (final operation in operations) {
      // Apply each operation to the batch
      // This is a simplified version - you'd need to implement specific batch operations
    }

    await batch.commit();
  }

  // Specific collection methods for your app

  // Orders
  static Future<List<Map<String, dynamic>>> getOrders({
    String? userId,
    String? status,
  }) {
    return getCollection(
      collection: 'orders',
      queryBuilder: (query) {
        Query q = query;
        if (userId != null) {
          q = q.where('userId', isEqualTo: userId);
        }
        if (status != null) {
          q = q.where('status', isEqualTo: status);
        }
        return q.orderBy('createdAt', descending: true);
      },
    );
  }

  // Customers
  static Future<List<Map<String, dynamic>>> getCustomers({String? userId}) {
    return getCollection(
      collection: 'customers',
      queryBuilder: userId != null
          ? (query) => query.where('userId', isEqualTo: userId)
          : null,
    );
  }

  // Suppliers
  static Future<List<Map<String, dynamic>>> getSuppliers({String? userId}) {
    return getCollection(
      collection: 'suppliers',
      queryBuilder: userId != null
          ? (query) => query.where('userId', isEqualTo: userId)
          : null,
    );
  }

  // Expenses
  static Future<List<Map<String, dynamic>>> getExpenses({
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return getCollection(
      collection: 'expenses',
      queryBuilder: (query) {
        Query q = query;
        if (userId != null) {
          q = q.where('userId', isEqualTo: userId);
        }
        if (startDate != null) {
          q = q.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
        }
        if (endDate != null) {
          q = q.where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
        }
        return q.orderBy('date', descending: true);
      },
    );
  }

  // Invoices
  static Future<List<Map<String, dynamic>>> getInvoices({String? userId}) {
    return getCollection(
      collection: 'invoices',
      queryBuilder: userId != null
          ? (query) => query.where('userId', isEqualTo: userId)
          : null,
    );
  }
}