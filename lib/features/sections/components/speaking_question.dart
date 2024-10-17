import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_session/audio_session.dart'; // New import for audio session
import 'package:audioplayers/audioplayers.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/network/apis_constants.dart';
import 'package:ez_english/core/network/custom_response.dart';
import 'package:ez_english/core/network/network_helper.dart';
import 'package:ez_english/features/models/speech_recognition_result.dart';
import 'package:ez_english/features/sections/models/speaking_answer.dart';
import 'package:ez_english/features/sections/models/speaking_question_model.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/utils.dart';
import 'package:ez_english/widgets/audio_control_button.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeakingQuestion extends StatefulWidget {
  final SpeakingQuestionModel question;
  final Function(SpeakingAnswer) onAnswerChanged;
  const SpeakingQuestion({
    required this.question,
    required this.onAnswerChanged,
    super.key,
  });

  @override
  State<SpeakingQuestion> createState() => _SpeakingQuestionState();
}

class _SpeakingQuestionState extends State<SpeakingQuestion> {
  TextEditingController controller = TextEditingController();
  FlutterSoundRecorder? recorder;
  bool isRecorderReady = false;
  String? _audioFilePath;
  bool _isRecording = false;
  late AudioPlayer audioPlayer;
  double accuracyScore = 0.0;
  double fluencyScore = 0.0;
  double pronunciationScore = 0.0;
  bool _userHasRecorded = false;
  bool _isLoading = false;
  SpeechRecognitionResult? speechRecognitionResult;

  @override
  void initState() {
    super.initState();
    accuracyScore = 0.0;
    fluencyScore = 0.0;
    pronunciationScore = 0.0;
    _userHasRecorded = false;
    _isLoading = false;
    audioPlayer = AudioPlayer();
    configureAudioSession();
    initRecorder();
  }

  @override
  void dispose() {
    recorder?.closeRecorder();
    if (recorder != null) {
      recorder!.closeRecorder();
      recorder = null;
    }
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
  }

  Future<void> playRecording() async {
    printDebug("$_audioFilePath");
    if (_audioFilePath != null) {
      try {
        Source urlSource = UrlSource(_audioFilePath!);
        await audioPlayer.play(urlSource);
      } catch (e) {
        printDebug("AUDIO PLAYING ERROR: $e");
      }
    }
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      Utils.showErrorSnackBar("Microphone permission not granted");
      throw "Microphone permission not granted";
    }
    recorder = FlutterSoundRecorder(logLevel: Level.error);
    await recorder!.openRecorder();
    isRecorderReady = true;
  }

  Future record() async {
    if (!isRecorderReady) return;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    var timestamp = DateTime.now().millisecondsSinceEpoch;

    String path = '$appDocPath/$timestamp.wav';
    await recorder!.startRecorder(
      toFile: path,
      codec: Codec.pcm16WAV,
    );
    setState(() {
      _isRecording = true;
      _audioFilePath = path;
    });
  }

  Future<void> _stopRecording() async {
    await recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  void updateScores(double accuracy, double fluency, double completeness,
      double pronunciation, String text) {
    widget.onAnswerChanged(SpeakingAnswer(answer: (accuracy).toInt()));
    setState(() {
      accuracyScore = accuracy;
      fluencyScore = fluency;
      pronunciationScore = pronunciation;
      _userHasRecorded = true;
    });
  }

  void updateUIWithResponse(SpeechRecognitionResult result) {
    speechRecognitionResult = result;

    updateScores(
      result.nBest.first.accuracyScore,
      result.nBest.first.fluencyScore,
      result.nBest.first.completenessScore,
      result.nBest.first.pronScore,
      result.displayText,
    );
  }

  void _sendAudioFile() async {
    resetQuestion();
    await _sendAudioForPronunciationAssessment();
  }

  Future<void> _sendAudioForPronunciationAssessment() async {
    if (_audioFilePath != null) {
      List<int> audioBytes = File(_audioFilePath!).readAsBytesSync();
      String url = APIConstants.sttEndPoint;

      Map<String, dynamic> headers = generateHeaders();
      setLoading(true);
      CustomResponse response = await NetworkHelper.getNewInstance().post(
        url: url,
        headersForRequest: headers,
        body: Stream.value(audioBytes),
      );

      if (response.statusCode == 200) {
        printDebug("Pronunciation assessment successful: ${response.data}");

        handleSttResponse(response.data);
      } else {
        Utils.showErrorSnackBar(
            "Pronunciation assessment failed. Please try again.");
        printDebug(
            'Failed to send audio file: ${response.errorMessage} ${response.statusCode}');
      }
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Constants.gapH18,
        CustomTextBox(
          textSpans: [
            TextSpan(
              text: widget.question.question,
              style: const TextStyle(color: Colors.black),
            ),
          ],
          maxLineNum: 7,
          secondaryTextStyle:
              TextStyles.readingPracticeTextStyle.copyWith(height: 1.5),
        ),
        Constants.gapH8,
        if (_userHasRecorded) ...[
          CustomTextBox(
            textSpans: [
              highlightedText(
                  words: speechRecognitionResult?.nBest.first.words ?? [])
            ],
            maxLineNum: 7,
            secondaryTextStyle:
                TextStyles.readingPracticeTextStyle.copyWith(height: 1.5),
          ),
          Constants.gapH18,
          pronunciationEvaluation(
            accuracyScore,
            fluencyScore,
            pronunciationScore,
          ),
        ],
        Constants.gapH8,
        AudioControlButton(
          isRecording: _isRecording,
          isLoading: _isLoading,
          onPressed: () async {
            if (_isRecording) {
              await _stopRecording();
              _sendAudioFile();
            } else {
              await record();
            }
          },
          type: AudioControlType.microphone,
        ),
      ],
    );
  }

  void setLoading(isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Map<String, dynamic> generateHeaders() {
    printDebug(
        "generating headers, reference text is ${widget.question.question}");
    Map<String, dynamic> pronAssessmentParams = {
      "ReferenceText": widget.question.question,
      "GradingSystem": "HundredMark",
      "Granularity": "Phoneme",
      "Dimension": "Comprehensive"
    };

    String pronAssessmentParamsJson = jsonEncode(pronAssessmentParams);
    String pronAssessmentHeader =
        base64Encode(utf8.encode(pronAssessmentParamsJson));

    Map<String, dynamic> headers = {
      'Content-Type': 'audio/wav; codecs=audio/pcm; samplerate=16000',
      'Pronunciation-Assessment': pronAssessmentHeader,
      'Ocp-Apim-Subscription-Key': APIConstants.sttApiKey,
      'Accept': 'application/json',
    };
    return headers;
  }

  void handleSttResponse(Map<String, dynamic> response) {
    SpeechRecognitionResult result = SpeechRecognitionResult.fromJson(response);
    switch (result.recognitionStatus) {
      case "Success":
        updateUIWithResponse(result);
        break;
      case "InitialSilenceTimeout":
        Utils.showErrorSnackBar("Please read the text out loud.");
        break;
      case "BabbleTimeout":
        Utils.showErrorSnackBar("Please read the text correctly");
        break;
      case "Error":
        Utils.showErrorSnackBar(
            "Pronunciation assessment failed. Please try again.");
        break;
    }
  }

  void resetQuestion() {
    setState(() {
      accuracyScore = 0.0;
      fluencyScore = 0.0;
      pronunciationScore = 0.0;
    });
  }
}

TextSpan highlightedText({required List<Word> words}) {
  return TextSpan(
    children: words.map((word) {
      Color wordColor;
      if (word.accuracyScore >= 90) {
        wordColor = Colors.green;
      } else if (word.accuracyScore >= 70) {
        wordColor = Colors.lightGreen;
      } else if (word.accuracyScore >= 50) {
        wordColor = Colors.orange;
      } else if (word.accuracyScore >= 30) {
        wordColor = Colors.deepOrange;
      } else {
        wordColor = Colors.red;
      }

      return TextSpan(
        text: "${word.word} ",
        style: TextStyles.bodyLarge.copyWith(color: wordColor),
      );
    }).toList(),
    style: TextStyles.bodyLarge,
  );
}

Widget pronunciationEvaluation(
    double accuracyScore, double fluencyScore, double pronunciationScore) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Accuracy",
            style: TextStyles.bodyMedium,
          ),
          Constants.gapH8,
          Text(
            "Fluency",
            style: TextStyles.bodyMedium,
          ),
          Constants.gapH8,
          Text(
            "Pronunciation",
            style: TextStyles.bodyMedium,
          ),
        ],
      ),
      Column(
        children: [
          Text(
            "${accuracyScore.toInt()}%",
            style: TextStyles.bodyMedium,
          ),
          Constants.gapH8,
          Text(
            "${fluencyScore.toInt()}%",
            style: TextStyles.bodyMedium,
          ),
          Constants.gapH8,
          Text(
            "${pronunciationScore.toInt()}%",
            style: TextStyles.bodyMedium,
          ),
        ],
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildScoreRow(accuracyScore),
            _buildScoreRow(fluencyScore),
            _buildScoreRow(pronunciationScore),
          ],
        ),
      )
    ],
  );
}

Widget _buildScoreRow(double value) {
  return Padding(
    padding: EdgeInsets.all(Constants.padding8),
    child: ProgressBar(value: value),
  );
}
