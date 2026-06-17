import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CloudSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> syncUserData({
    required String uid,
    required Map<String, dynamic> data,
    String collection = 'users',
  }) async {
    try {
      await _firestore.collection(collection).doc(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      // Silently fail, will retry on next sync
    }
  }

  Future<Map<String, dynamic>?> getUserData({
    required String uid,
    String collection = 'users',
  }) async {
    try {
      final doc = await _firestore.collection(collection).doc(uid).get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }

  Future<void> syncBookmarks({
    required String uid,
    required Map<String, dynamic> bookmarks,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).collection('bookmarks').doc('data').set(
        {'items': bookmarks, 'updatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
    } catch (e) {
      // Silently fail
    }
  }

  Future<Map<String, dynamic>?> getBookmarks({required String uid}) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookmarks')
          .doc('data')
          .get();
      if (!doc.exists) return null;
      return doc.data()?['items'] as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  Future<void> syncKhatmahProgress({
    required String uid,
    required Map<String, dynamic> progress,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).collection('khatmah').doc('progress').set(
        {'data': progress, 'updatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> syncSettings({
    required String uid,
    required Map<String, dynamic> settings,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).collection('settings').doc('prefs').set(
        {'data': settings, 'updatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> deleteUserData({required String uid}) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      // Silently fail
    }
  }
}

final cloudSyncServiceProvider = Provider<CloudSyncService>((ref) {
  return CloudSyncService();
});
