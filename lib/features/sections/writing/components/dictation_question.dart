// ignore_for_file: avoid_print

import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/network/apis_constants.dart';
import 'package:ez_english/core/network/custom_response.dart';
import 'package:ez_english/core/network/network_helper.dart';
import 'package:ez_english/widgets/microphone_button.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';

class DictationQuestion extends StatefulWidget {
  final TextEditingController controller;
  final String text;

  DictationQuestion({
    super.key,
    required this.controller,
    required this.text,
  });

  @override
  State<DictationQuestion> createState() => _DictationQuestionState();
}

class _DictationQuestionState extends State<DictationQuestion> {
  final String apiKey = dotenv.env['AZURE_API_KEY_1'] ?? '';

  final AudioPlayer player = AudioPlayer();
  void getAudioBytes(String? text) async {
    String requestBody =
        '<speak version="1.0" xml:lang="en-US"><voice xml:lang="en-US" xml:gender="Female" name="en-US-JennyNeural">${widget.text}</voice></speak>';
    Map<String, dynamic> requestBodyHeaders = {
      'Ocp-Apim-Subscription-Key': apiKey,
      'Content-Type': 'application/ssml+xml',
      'X-Microsoft-OutputFormat': 'audio-24khz-160kbitrate-mono-mp3',
    };

    try {
      print("Request body: $requestBody");
      CustomResponse response = await NetworkHelper.instance.post(
        url: APIConstants.ttsEndPoint,
        headersForRequest: requestBodyHeaders,
        body: requestBody,
        returnBytesResponse: true,
      );
      if (response.statusCode == 200) {
        final bytes = response.data;
        // final bytes = response.data.map((str) => int.parse(str)).toList();

        print(bytes);
        await player.setAudioSource(DictationQuestionSource(bytes));
        player.play();
      } else {
        print("Status code: ${response.statusCode}");
        print("Error: ${response.errorMessage}");
      }
    } catch (e) {
      print("Error: $e");
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
            SizedBox(height: Constants.padding20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Type the sentence you hear"),
              ],
            ),
            SizedBox(height: Constants.padding20),
            AudioControlButton(
              onPressed: () {
                // TODO: call azure tts service
                getAudioBytes("testing ");
              },
              type: AudioControlType.speaker,
            ),
            SizedBox(height: Constants.padding20),
            const Text(
              "Tap the speaker button and listen to the sentence.\nType the sentence out in the box below.",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Constants.padding20),
            CustomTextField(
              controller: widget.controller,
              maxLines: 10,
              hintText: "Type your answer here",
            ),
          ],
        ),
      ],
    );
  }
}

class DictationQuestionSource extends StreamAudioSource {
  final List<int> bytes;
  DictationQuestionSource(this.bytes);

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
