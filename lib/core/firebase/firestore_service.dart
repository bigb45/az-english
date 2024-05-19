import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/firebase/exceptions.dart';
import 'package:ez_english/features/models/level.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Level>> fetchLevels() async {
    try {
      QuerySnapshot snapshot =
          await _db.collection(FirestoreConstants.levelsCollection).get();
      if (snapshot.docs.isEmpty) {
        throw CustomException(
            message: "No levels found",
            type: FirebaseExceptionType.networkError);
      }
      return snapshot.docs
          .map((doc) => Level.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CustomException(
          message: "A network error occured",
          type: FirebaseExceptionType.networkError);
    }
  }
}
