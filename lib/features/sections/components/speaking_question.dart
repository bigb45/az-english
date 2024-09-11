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
    initRecorder();
  }

// TODO add all these methods to the view model
  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(_audioFilePath!);
      await audioPlayer.play(urlSource);
      // Add an event listener to be notified when the audio playback completes
    } catch (e) {
      print("AUDIO PLAYING++++++++++++++++++++++++$e+++++++++++++++++++++++++");
    }
  }

  Future<void> initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw "Microphone permission not granted ";
    }
    recorder = FlutterSoundRecorder();
    await recorder!.openRecorder();
    isRecorderReady = true;
  }

  Future record() async {
    if (!isRecorderReady) return;
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;

      String path = '$appDocPath/your_audio_file.wav';
      await recorder!.startRecorder(
        toFile: path,
        codec: Codec.pcm16WAV,
      );
      setState(() {
        _isRecording = true;
        _audioFilePath = path; // Save the file path
      });
    } catch (err) {
      print('Error starting recording: $err');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    } catch (err) {
      print('Error stopping recording: $err');
    }
  }

  Future<void> _sendAudioFile() async {
    List<int> audioBytes = File(_audioFilePath!).readAsBytesSync();

    String url = APIConstants.sttEndPoint; // Replace with your API endpoint
    try {
      // Define your JSON payload
      Map<String, dynamic> pronAssessmentParams = {
        "ReferenceText": "Test",
        "GradingSystem": "HundredMark",
        "Granularity": "Phoneme",
        "Dimension": "Comprehensive"
      };

      // Convert JSON payload to String
      String pronAssessmentParamsJson = jsonEncode(pronAssessmentParams);

      // Encode the JSON payload to Base64
      String pronAssessmentHeader =
          base64Encode(utf8.encode(pronAssessmentParamsJson));

      // Construct headers for the request
      Map<String, dynamic> headers = {
        'Content-Type': 'audio/wav',
        'Pronunciation-Assessment': pronAssessmentHeader,
      };
      // Call the custom post method
      CustomResponse response = await NetworkHelper.instance.post(
        url: url,
        headersForRequest: headers,
        body: Stream.fromIterable(audioBytes.map((e) => [e])),
      );

      // Handle response
      if (response.statusCode == 200) {
        print("Status code: ${response.data}");
      } else {
        print(
            'Failed to send audio file: ${response.errorMessage} ${response.statusCode}');
      }
    } catch (error) {
      print('Error sending audio file: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Constants.gapH18,
            CustomTextBox(
              // TODO: Dynamic text
              paragraphText:
                  '''Lorem  ipsum  dolor  sit  amet, consectetur  adipiscing  elit,
  sed  do  eiusmod  tempor  incididunt  ut  labore  et  dolore  magna  aliqua.  Ut  enim  ad  minim  veniam,  quis  nostrud  exercitation  ullamco  laboris   ''',
              maxLineNum: 7,
              secondaryTextStyle:
                  TextStyles.readingPracticeTextStyle.copyWith(height: 1.5),
            ),
            Constants.gapH18,
            CustomTextBox(
              paragraphText:
                  '''Lorem  ipsum  dolor  sit  amet, consectetur  adipiscing  elit ''',
              maxLineNum: 2,
              secondaryTextStyle:
                  TextStyles.readingPracticeTextStyle.copyWith(height: 1.5),
            ),
            Constants.gapH8,
            AudioControlButton(
              onPressed: () async {
                if (recorder!.isRecording) {
                  await _stopRecording();
                  if (_audioFilePath != null) {
                    // Call your API sending function here
                    print('Sending audio file: $_audioFilePath');
                    _sendAudioFile();
                  }
                } else {
                  await record();
                }
              },
              type: AudioControlType.microphone,
            ),
            Constants.gapH12,
            Text(
              AppStrings.speakingQuesiton,
              textAlign: TextAlign.center,
              style: TextStyles.readingPracticeSecondaryTextStyle,
            ),
          ],
        ),
      ],
    );
  }
}
