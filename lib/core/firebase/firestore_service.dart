import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/features/models/level.dart';
import 'package:ez_english/features/models/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Level>> fetchLevels() async {
    try {
      QuerySnapshot snapshot =
          await _db.collection(FirestoreConstants.levelsCollection).get();
      return snapshot.docs
          .map((doc) => Level.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch levels: $e');
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      await _db
          .collection(FirestoreConstants.usersCollections)
          .doc("${user.id}")
          .set(user.toMap());
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }
}
