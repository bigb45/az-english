import 'dart:io';

import 'package:ez_english/core/firebase/firestore_service.dart';
import 'package:ez_english/core/permissions/permission_handler_service.dart';
import 'package:ez_english/features/sections/models/multiple_choice_answer.dart';
import 'package:ez_english/features/sections/models/multiple_choice_question_model.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MultipleChoiceViewModel extends ChangeNotifier {
  final PermissionHandlerService _permissionHandlerService =
      PermissionHandlerService();
  bool _isLoading = false;
  get isLoading => _isLoading;
  File? _image;
  File? get image => _image;
  final FirestoreService _firestoreService = FirestoreService();
  List<RadioItemData> answers = [RadioItemData(title: "", value: "0")];
  RadioItemData _selectedAnswer = RadioItemData(title: "", value: "0");
  RadioItemData get selectedAnswer => _selectedAnswer;
  bool shouldSetOptions = true;
  final int maxAnswers = 5;
  int answerCount = 1;
  final idGenerator = const Uuid();
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

  void removeImage() {
    _image = null;
    _showCachedImage = false;
    notifyListeners();
  }

  Future<String> uploadImageAndGetUrl(File file, String imageName) async {
    _isLoading = true;
    notifyListeners();
    try {
      UploadTask uploadTask =
          FirebaseStorage.instance.ref('questions/$imageName').putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return '';
  }

  void updateAnswerInEditMode(
      List<RadioItemData> options, RadioItemData answer) {
    answers = options;
    _selectedAnswer = answer;
    shouldSetOptions = false;
    // notifyListeners();
  }

  void setSelectedAnswer(RadioItemData newAnswer) {
    _selectedAnswer = newAnswer;
    notifyListeners();
  }

  void updateAnswer(String newAnswer, RadioItemData option) {
    int index = answers.indexOf(option);
    if (index != -1) {
      answers[index].title = newAnswer;
      // answers[index].value = (index + 1).toString();
      for (var answer in answers) {
        print(
            "updating answer, title: ${answer.title}, value: ${answer.value}");
      }
      notifyListeners();
    }
  }

  void addAnswer() {
    if (answers.length < maxAnswers) {
      answers.add(RadioItemData(title: "", value: idGenerator.v4()));
      answerCount++;
      print("selected answer: ${_selectedAnswer.value}");

      for (var answer in answers) {
        print(
            "updating answer, title: ${answer.title}, value: ${answer.value}");
      }
      notifyListeners();
    }
  }

  void deleteAnswer(RadioItemData option) {
    if (answers.length > 1) {
      answers.remove(option);
      answerCount--;
      for (var answer in answers) {
        print("title: ${answer.title}, value: ${answer.value}");
      }
      notifyListeners();
    }
  }

  Future<MultipleChoiceQuestionModel?> submitForm({
    required String? questionTextInEnglish,
    required String? questionTextInArabic,
    required String? questionSentenceInEnglish,
    required String? questionSentenceInArabic,
    required String? titleInEnglish,
    required String? imageUrlInEditMode,
  }) async {
    if (selectedAnswer != null && questionTextInEnglish != null) {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await uploadImageAndGetUrl(
            _image!, 'question_image_${DateTime.now().millisecondsSinceEpoch}');
      } else {
        imageUrl = imageUrlInEditMode;
      }
      return MultipleChoiceQuestionModel(
        questionTextInEnglish: questionTextInEnglish,
        questionTextInArabic: questionTextInArabic,
        questionSentenceInEnglish: questionSentenceInEnglish,
        questionSentenceInArabic: questionSentenceInArabic,
        imageUrl: imageUrl,
        options: answers,
        answer: MultipleChoiceAnswer(answer: selectedAnswer!),
        titleInEnglish: titleInEnglish,
      );
    } else {
      print("Form is not valid or no answer is selected or options are empty.");
    }
    return null;
  }

  Future<void> uploadQuestion({
    required String level,
    required String section,
    required String day,
    required MultipleChoiceQuestionModel question,
  }) async {
    try {
      _firestoreService.uploadQuestionToFirestore(
          day: day,
          level: level,
          section: section,
          questionMap: question.toMap());
    } catch (e) {
      print('Error adding question: $e');
    }
  }

  void reset() {
    final id = idGenerator.v4();
    _image = null;
    _showCachedImage = true;
    answers = [RadioItemData(title: "", value: id)];
    _selectedAnswer = answers[0];
    shouldSetOptions = true;
    answerCount = 1;
    notifyListeners();
  }
}
