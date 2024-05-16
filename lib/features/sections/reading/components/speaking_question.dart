import 'dart:io';

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/features/azure_tts_test.dart';
import 'package:ez_english/resources/app_strings.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/microphone_button.dart';
import 'package:ez_english/widgets/text_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class SpeakingQuestion extends StatefulWidget {
  const SpeakingQuestion({
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRecorder();
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

  final String apiKey = dotenv.env['AZURE_API_KEY_1'] ?? '';

  Future<void> _sendAudioFile() async {
    List<int> audioBytes = await File(_audioFilePath!).readAsBytes();

    String url =
        'https://westeurope.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Ocp-Apim-Subscription-Key': apiKey,
          'Content-Type': 'audio/wav; codecs=audio/pcm; samplerate=16000',
          'Accept': 'application/json',
        },
        body: audioBytes,
      );

      if (response.statusCode == 200) {
        print("Status code: ${response.statusCode}");
      } else {
        print("Status code: ${response.statusCode}");
        print("Status code: ${response.reasonPhrase}");
      }
    } catch (e, stackTrace) {
      print("Error while playing audio: $e");
      print(stackTrace);
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
            // TODO: New design
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
