import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/network/apis_constants.dart';
import 'package:ez_english/core/network/custom_response.dart';
import 'package:ez_english/core/network/network_helper.dart';
import 'package:ez_english/features/sections/models/speaking_question_model.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/audio_control_button.dart';
import 'package:ez_english/widgets/text_box.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    super.initState();
    configureAudioSession();
    initRecorder();
  }

  // Configure the audio session for your app
  Future<void> configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
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
    String path = '$appDocPath/your_audio_file.wav';
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

  Future<void> _sendAudioFile() async {
    if (_audioFilePath != null) {
      List<int> audioBytes = File(_audioFilePath!).readAsBytesSync();
      String url = APIConstants.sttEndPoint;
      Map<String, dynamic> pronAssessmentParams = {
        "ReferenceText": "Test",
        "GradingSystem": "HundredMark",
        "Granularity": "Phoneme",
        "Dimension": "Comprehensive"
      };
      String pronAssessmentParamsJson = jsonEncode(pronAssessmentParams);
      String pronAssessmentHeader =
          base64Encode(utf8.encode(pronAssessmentParamsJson));
      Map<String, dynamic> headers = {
        'Content-Type': 'audio/wav',
        'Pronunciation-Assessment': pronAssessmentHeader,
      };
      CustomResponse response = await NetworkHelper.instance.post(
        url: url,
        headersForRequest: headers,
        body: Stream.fromIterable(audioBytes.map((e) => [e])),
      );
      if (response.statusCode == 200) {
        print("Audio file sent successfully: ${response.data}");
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
          paragraphText:
              '''Lorem ipsum dolor sit amet, consectetur adipiscing elit...''',
          maxLineNum: 7,
          secondaryTextStyle:
              TextStyles.readingPracticeTextStyle.copyWith(height: 1.5),
        ),
        Constants.gapH18,
        CustomTextBox(
          paragraphText: '''More lorem ipsum text here...''',
          maxLineNum: 2,
          secondaryTextStyle:
              TextStyles.readingPracticeTextStyle.copyWith(height: 1.5),
        ),
        Constants.gapH8,
        AudioControlButton(
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
