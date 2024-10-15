import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/network/apis_constants.dart';
import 'package:ez_english/core/network/custom_response.dart';
import 'package:ez_english/core/network/network_helper.dart';
import 'package:ez_english/features/models/speech_recognition_result.dart';
import 'package:ez_english/features/sections/models/speaking_question_model.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/audio_control_button.dart';
import 'package:ez_english/widgets/text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_session/audio_session.dart'; // New import for audio session

class SpeakingQuestion extends StatefulWidget {
  final SpeakingQuestionModel question;

  const SpeakingQuestion({
    required this.question,
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
  int highlightIndex = 0;
  Timer? _timer;
  List<int> segmentIndices = [];
  double accuracyScore = 0.0;
  double fluencyScore = 0.0;
  double completenessScore = 0.0;
  double pronScore = 0.0;
  String displayText = "";

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    super.initState();
    configureAudioSession();
    initRecorder();
    calculateSegmentIndices();
  }

  void calculateSegmentIndices() {
    int segmentLength = 20; // adjust the segment length as needed
    for (int i = 0; i < widget.question.question.length; i += segmentLength) {
      segmentIndices.add(i);
    }
    segmentIndices.add(widget.question.question.length);
  }

  @override
  void dispose() {
    _timer?.cancel();
    recorder?.closeRecorder();
    if (recorder != null) {
      recorder!.closeRecorder();
      recorder = null;
    }
    audioPlayer.dispose();
    super.dispose();
  }

  // Configure the audio session for your app
  Future<void> configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
  }

  void startHighlightTimer() {
    const duration = Duration(seconds: 5);
    _timer = Timer.periodic(
      duration,
      (Timer timer) {
        if (highlightIndex < segmentIndices.length - 1) {
          setState(() {
            highlightIndex++;
          });
        } else {
          _timer?.cancel();
        }
      },
    );
  }

  Future<void> playRecording() async {
    if (_audioFilePath != null) {
      try {
        Source urlSource = UrlSource(_audioFilePath!);
        await audioPlayer.play(urlSource);
      } catch (e) {
        print("AUDIO PLAYING ERROR: $e");
      }
    }
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw "Microphone permission not granted";
    }
    recorder = FlutterSoundRecorder();
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
      highlightIndex = 0;
    });
    startHighlightTimer();
  }

  Future<void> _stopRecording() async {
    await recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
  }

  List<TextSpan> createTextSpans() {
    List<TextSpan> spans = [];
    TextStyle defaultStyle =
        TextStyle(color: Colors.black); // Default text style
    TextStyle highlightStyle = TextStyle(
        color: Colors.black,
        backgroundColor: Colors.yellow); // Highlighted text style

    for (int i = 0; i < segmentIndices.length - 1; i++) {
      spans.add(TextSpan(
        text: widget.question.question
            .substring(segmentIndices[i], segmentIndices[i + 1]),
        style: highlightIndex == i ? highlightStyle : defaultStyle,
      ));
    }
    return spans;
  }

  final String apiKey = dotenv.env['AZURE_API_KEY_1'] ?? '';
  void updateScores(double accuracy, double fluency, double completeness,
      double pron, String text) {
    setState(() {
      accuracyScore = accuracy;
      fluencyScore = fluency;
      completenessScore = completeness;
      pronScore = pron;
      displayText = text;
    });
  }

  void updateUIWithResponse(SpeechRecognitionResult result) {
    updateScores(
        result.nBest.first.accuracyScore,
        result.nBest.first.fluencyScore,
        result.nBest.first.completenessScore,
        result.nBest.first.pronScore,
        result.displayText);
  }

  Future<void> _sendAudioFile() async {
    if (_audioFilePath != null) {
      List<int> audioBytes = File(_audioFilePath!).readAsBytesSync();
      String url = APIConstants.sttEndPoint;
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
        'Ocp-Apim-Subscription-Key': apiKey,
        'Accept': 'application/json',
      };
      CustomResponse response = await NetworkHelper.instance.post(
        url: url,
        headersForRequest: headers,
        body: Stream.fromIterable(audioBytes.map((e) => [e])),
      );
      if (response.statusCode == 200) {
        print("Audio file sent successfully: ${response.data}");
        SpeechRecognitionResult result =
            SpeechRecognitionResult.fromJson((response.data));
        updateUIWithResponse(result);
      } else {
        print(
            'Failed to send audio file: ${response.errorMessage} ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Constants.gapH18,
        CustomTextBox(
          textSpans: createTextSpans(),
          maxLineNum: 7,
          secondaryTextStyle:
              TextStyles.readingPracticeTextStyle.copyWith(height: 1.5),
        ),
        Constants.gapH18,
        Text("Accuracy Score: $accuracyScore%"),
        Text("Fluency Score: $fluencyScore%"),
        Text("Completeness Score: $completenessScore%"),
        Text("Pronunciation Score: $pronScore%"),
        Constants.gapH8,
        Constants.gapH8,
        AudioControlButton(
          onPressed: () async {
            if (_isRecording) {
              await _stopRecording();
              await _sendAudioFile();
            } else {
              await record();
            }
          },
          type: AudioControlType.microphone,
        ),
        Constants.gapH12,
        Text(
          "",
          textAlign: TextAlign.center,
          style: TextStyles.readingPracticeSecondaryTextStyle,
        ),
      ],
    );
  }
}
