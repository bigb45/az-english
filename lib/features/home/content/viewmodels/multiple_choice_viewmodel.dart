import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/features/models/base_question.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ez_english/core/permissions/permission_handler_service.dart';
import 'package:ez_english/features/sections/models/multiple_choice_answer.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';

class MultipleChoiceViewModel extends ChangeNotifier {
  final PermissionHandlerService _permissionHandlerService =
      PermissionHandlerService();
  File? _image;
  File? get image => _image;
  FirestoreService _firestoreService = FirestoreService();
  List<RadioItemData> answers = [];
  RadioItemData? selectedAnswer;
  int maxAnswers = 5;
  int answerCount = 0;

  Future<void> pickImage() async {
    bool hasPermission =
        await _permissionHandlerService.requestPhotoPermission();
    if (hasPermission) {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        notifyListeners();
      }
    } else {
      print("Permission denied");
    }
  }

  Future<String> uploadImageAndGetUrl(File file, String imageName) async {
    try {
      UploadTask uploadTask =
          FirebaseStorage.instance.ref('questions/$imageName').putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  bool validateOptions() {
    for (var option in answers) {
      if (option.title.isEmpty) {
        return false;
      }
    }
    return true;
  }

  void updateAnswer(String newAnswer, RadioItemData option) {
    int index = answers.indexOf(option);
    if (index != -1) {
      answers[index] = RadioItemData(title: newAnswer, value: option.value);
      notifyListeners();
    }
  }

  void addAnswer() {
    answers.add(RadioItemData(title: "", value: answers.length.toString()));
    notifyListeners();
  }

  void deleteAnswer(RadioItemData option) {
    answers.remove(option);
    notifyListeners();
  }

  Future<void> submitForm({
    required String? questionTextInEnglish,
    required String? questionTextInArabic,
    required String? questionSentenceInEnglish,
    required String? questionSentenceInArabic,
    required String? titleInEnglish,
    required String level,
    required String section,
    required String day,
  }) async {
    if (selectedAnswer != null && validateOptions()) {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await uploadImageAndGetUrl(
            _image!, 'question_image_${DateTime.now().millisecondsSinceEpoch}');
      }
      MultipleChoiceQuestionModel question = MultipleChoiceQuestionModel(
        questionTextInEnglish: questionTextInEnglish,
        questionTextInArabic: questionTextInArabic,
        questionSentenceInEnglish: questionSentenceInEnglish,
        questionSentenceInArabic: questionSentenceInArabic,
        imageUrl: imageUrl ?? "",
        options: answers,
        answer: MultipleChoiceAnswer(answer: selectedAnswer!),
        titleInEnglish: titleInEnglish,
      );
      await _firestoreService.uploadQuestionToFirestore(
          level: level,
          section: section,
          day: day,
          questionMap: question.toMap());
    } else {
      print("Form is not valid or no answer is selected or options are empty.");
      return null;
    }
  }
}
