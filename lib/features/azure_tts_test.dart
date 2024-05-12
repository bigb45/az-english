// ignore_for_file: avoid_print, unused_local_variable

import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AzureTtsTest extends StatefulWidget {
  const AzureTtsTest({super.key});

  @override
  State<AzureTtsTest> createState() => _AzureTtsTestState();
}

class _AzureTtsTestState extends State<AzureTtsTest> {
  final _controller = TextEditingController();

  // TODO: use post requests to get the audio file and play it back
  // https://dev.to/noahvelasco/amplify-your-flutter-apps-with-elevenlabs-tts-api-a-simple-guide-5147
  @override
  void initState() {
    TtsMicrosoft.init(
        params: InitParamsMicrosoft(
            subscriptionKey: "REDACTED", region: "westeurope"),
        withLogs: true);
    TtsUniversal.setProvider(TtsProviders.microsoft);

    super.initState();
  }

  void speak(String text) async {
    try {
      final voicesResponse = await TtsUniversal.getVoices();

      final voices = voicesResponse.voices;

      print(voices.first.name);

      final voice = voices
          .where((element) => element.locale.code.startsWith("en-"))
          .toList(growable: false)
          .first;

      //Generate Audio for a text
      const text =
          "Amazon, Microsoft and Google Text-to-Speech API are awesome";

      final ttsParams = TtsParamsUniversal(
          voice: voice,
          audioFormat: AudioOutputFormatUniversal.mp3_64k,
          text: text,
          rate: 'slow', //optional
          pitch: 'default' //optional
          );

      final ttsResponse = await TtsUniversal.convertTts(ttsParams);
      print(ttsResponse.reason);
//Get the audio bytes.
      final audioBytes = ttsResponse.audio.buffer.asByteData();
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            'Azure TTS Test',
            style: TextStyles.titleTextStyle.copyWith(
              color: Palette.primaryText,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CustomTextField(
              controller: _controller,
              hintText: "Type a text and tap the \"Speak\" button",
              maxLines: 5,
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
              type: ButtonType.primaryVariant,
              onPressed: () async {
                speak(_controller.text);
                print("speaking: ${_controller.text}");
              },
              text: "Speak",
            ),
            const SizedBox(
              height: 20,
            ),
            Button(
              type: ButtonType.primaryVariant,
              onPressed: () {
                print("stopping");
              },
              text: "Stop",
            ),
          ]),
        ),
      ),
    );
  }
}
