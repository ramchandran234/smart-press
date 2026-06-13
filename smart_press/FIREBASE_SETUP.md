# Firebase Setup Guide

## 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `smart-press-laundry`
4. Enable Google Analytics (optional)
5. Choose Google Analytics account or create new
6. Click "Create project"

## 2. Enable Firebase Services

### Authentication
1. Go to Authentication → Get started
2. Go to Sign-in method tab
3. Enable "Phone" authentication
4. Configure authorized domains if needed

### Firestore Database
1. Go to Firestore Database → Create database
2. Choose "Start in test mode" (you can change rules later)
3. Select location (choose closest to your users)

### Storage
1. Go to Storage → Get started
2. Choose "Start in test mode"
3. Select same location as Firestore

## 3. FlutterFire CLI Setup

Install FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

Login to Firebase:
```bash
flutterfire login
```

Configure your Flutter app:
```bash
cd smart_press
flutterfire configure --project=smart-press-laundry
```

This will:
- Generate `lib/firebase_options.dart` (replacing our placeholder)
- Create `google-services.json` for Android
- Create `GoogleService-Info.plist` for iOS

## 4. Update Firebase Security Rules

### Firestore Rules (firestore.rules)
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Orders: owners can manage their orders, customers can read their orders
    match /orders/{orderId} {
      allow read: if request.auth != null &&
        (resource.data.ownerId == request.auth.uid ||
         resource.data.customerId == request.auth.uid);
      allow write: if request.auth != null && resource.data.ownerId == request.auth.uid;
    }

    // Similar rules for customers, suppliers, expenses, invoices...
    match /customers/{customerId} {
      allow read, write: if request.auth != null && resource.data.ownerId == request.auth.uid;
    }

    match /suppliers/{supplierId} {
      allow read, write: if request.auth != null && resource.data.ownerId == request.auth.uid;
    }

    match /expenses/{expenseId} {
      allow read, write: if request.auth != null && resource.data.ownerId == request.auth.uid;
    }

    match /invoices/{invoiceId} {
      allow read, write: if request.auth != null && resource.data.ownerId == request.auth.uid;
    }
  }
}
```

### Storage Rules (storage.rules)
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can upload/delete their own files
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Shop images, QR codes, etc.
    match /shops/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Order receipts
    match /orders/{orderId}/{allPaths=**} {
      allow read, write: if request.auth != null;
    }

    // Customer photos
    match /customers/{customerId}/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 5. Test the Setup

Run your Flutter app:
```bash
flutter run
```

The app should now initialize Firebase and you can start using the Firebase services instead of your API backend.

## 6. Data Migration (Optional)

If you want to migrate existing MongoDB data to Firestore:

1. Export your MongoDB data as JSON
2. Create a migration script to import data to Firestore
3. Update document IDs to match Firebase Auth UIDs where applicable

## Next Steps

1. Update your UI code to use Firebase services instead of HTTP API calls
2. Implement real-time listeners for live updates
3. Add offline support with Firestore persistence
4. Set up push notifications with Firebase Cloud Messaging