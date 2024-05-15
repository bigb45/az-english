// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

class AzureTtsTest extends StatefulWidget {
  const AzureTtsTest({super.key});
  @override
  State<AzureTtsTest> createState() => _AzureTtsTestState();
}

class _AzureTtsTestState extends State<AzureTtsTest> {
  final _controller = TextEditingController();
  final player = AudioPlayer();
  final String apiKey = dotenv.env['AZURE_API_KEY_1'] ?? '';

  Future<void> playTextToSpeech(String text) async {
    String voiceRachel =
        '21m00Tcm4TlvDq8ikWAM'; //Rachel voice - change if you know another Voice ID

    String url =
        'https://westeurope.tts.speech.microsoft.com/cognitiveservices/v1';
    try {
      var requestBody =
          '<speak version="1.0" xml:lang="en-US">    <voice xml:lang="en-US" xml:gender="ale" name="en-US-JennyNeural">$text</voice></speak>';
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Ocp-Apim-Subscription-Key': apiKey,
          'Content-Type': 'application/ssml+xml',
          'X-Microsoft-OutputFormat': 'audio-24khz-160kbitrate-mono-mp3',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        await player.setAudioSource(MyCustomSource(bytes));
        player.play();
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
                await playTextToSpeech(_controller.text);

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

class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
