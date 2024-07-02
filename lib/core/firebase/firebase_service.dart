import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  Future<String> uploadAudioToFirebase(
      Uint8List audioBytes, String speakableText) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String fileName = "$speakableText.mp3";
    Reference ref = storage.ref().child("questions/$fileName");
    UploadTask uploadTask = ref.putData(audioBytes);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
