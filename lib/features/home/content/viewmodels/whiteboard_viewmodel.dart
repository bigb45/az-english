import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ez_english/core/permissions/permission_handler_service.dart';
import 'package:ez_english/features/home/whiteboard/whiteboard_model.dart';
import 'package:ez_english/features/models/base_viewmodel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class WhiteboardViewmodel extends BaseViewModel {
  final PermissionHandlerService _permissionHandlerService =
      PermissionHandlerService();
  File? _image;

  File? get image => _image;

  @override
  FutureOr<void> init() {}

  bool _showCachedImage = true; // Flag to control cached image display
  bool get showCachedImage => _showCachedImage;
  Future<void> pickImage() async {
    bool hasPermission =
        await _permissionHandlerService.requestStoragePermission();
    if (hasPermission) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _showCachedImage = false;

        notifyListeners();
      }
    } else {
      print("Permission denied");
    }
  }

  Future<WhiteboardModel?> submitQuestion({
    required WhiteboardModel question,
    required String levelID,
    required String unitNumber,
    required String section,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      String? imageUrl;
      if (!question.imageUrl!.contains("https")) {
        imageUrl = await uploadImageAndGetUrl(
            question.imageUrl!, '${DateTime.now().millisecondsSinceEpoch}');
      } else {
        imageUrl = question.imageUrl!;
      }

      WhiteboardModel whiteboard =
          WhiteboardModel(title: question.title, imageUrl: imageUrl);

      return whiteboard;
    } catch (e) {
      print("Error uploading image: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> uploadQuestion({
    required String level,
    required String section,
    required String day,
    required WhiteboardModel question,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      await firestoreService.uploadQuestionToFirestore(
          day: day,
          level: level,
          section: section,
          questionMap: question.toMap());
    } catch (e) {
      print("Error uploading image: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void removeImage() {
    _image = null;
    _showCachedImage = false;
    notifyListeners();
  }

  Future<String> uploadImageAndGetUrl(
      String imagePath, String imageName) async {
    isLoading = true;
    notifyListeners();
    try {
      File imageFile = File(imagePath);
      Uint8List imageData = await imageFile.readAsBytes();

      UploadTask uploadTask = FirebaseStorage.instance
          .ref('whiteboards/$imageName')
          .putData(imageData);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return '';
  }
}
