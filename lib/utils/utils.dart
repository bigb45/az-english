import 'package:ez_english/core/network/apis_constants.dart';
import 'package:ez_english/core/network/custom_response.dart';
import 'package:ez_english/core/network/network_helper.dart';
import 'package:ez_english/utils/AzureAudioSource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static speakText(String text) async {
    final String apiKey = dotenv.env['AZURE_API_KEY_1'] ?? '';

    final AudioPlayer player = AudioPlayer();

    String requestBody =
        '<speak version="1.0" xml:lang="en-US"><voice xml:lang="en-US" xml:gender="Female" name="en-US-JennyNeural">${text}</voice></speak>';
    Map<String, dynamic> requestBodyHeaders = {
      'Ocp-Apim-Subscription-Key': apiKey,
      'Content-Type': 'application/ssml+xml',
      'X-Microsoft-OutputFormat': 'audio-24khz-160kbitrate-mono-mp3',
    };

    try {
      CustomResponse response = await NetworkHelper.instance.post(
        url: APIConstants.ttsEndPoint,
        headersForRequest: requestBodyHeaders,
        body: requestBody,
        returnBytesResponse: true,
      );
      if (response.statusCode == 200) {
        final bytes = response.data;
        await player.setAudioSource(AzureAudioSource(bytes));
        player.play();
      } else {
        throw Exception(
            "Error while generating audio: ${response.statusCode}, ${response.errorMessage}");
      }
    } catch (e) {
      print("Error while playing audio: $e");
    }
  }
}

extension StringExtension on String {
  String normalize() {
    return replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .toLowerCase()
        .trim()
        .trimLeft();
  }
}
