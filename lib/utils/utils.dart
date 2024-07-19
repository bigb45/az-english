import 'package:ez_english/core/network/apis_constants.dart';
import 'package:ez_english/core/network/custom_response.dart';
import 'package:ez_english/core/network/network_helper.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/utils/AzureAudioSource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showErrorSnackBar(String? errorText) {
    if (errorText == null) return;

    final snackBar = SnackBar(
      content: Text(errorText),
      backgroundColor: Colors.red,
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static showSnackbar({required String text, Color? color}) {
    final snackBar = SnackBar(
      content: Text(
        text,
      ),
      backgroundColor: color ?? Colors.black,
    );
    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Future<CustomResponse> speakText(String text) async {
    final String apiKey = dotenv.env['AZURE_API_KEY_1'] ?? '';

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
      return response;
    } catch (e) {
      throw Exception("Error while generating audio");
    }
  }
}

class DynamicRichTextSpan {
  DynamicRichTextSpan();

  TextSpan defaultTextSpan(String text) => TextSpan(
        text: text,
        style: TextStyles.bodyLarge,
      );

  // TextSpan clickableTextSpan(String text, TextStyle? style) => TextSpan(
  //       text: text,
  //       recognizer: TapGestureRecognizer()..onTap = () => print(text),
  //       style: style ??
  //           const TextStyle(
  //               fontSize: 22,
  //               decoration: TextDecoration.underline,
  //               color: Palette.primary),
  //     );
  TextSpan underlinedTextSpan(String text, TextStyle? style) => TextSpan(
        text: text,

        style: TextStyles.bodyLarge.copyWith(
          decoration: TextDecoration.underline,
          decorationThickness: 2,
        ),

        // TODO: pass style to function
        // style: style == null
        //     ? const TextStyle(
        //         fontSize: 22,
        //         decoration: TextDecoration.underline,
        //         color: Palette.primaryText)
        //     : style.copyWith(decoration: TextDecoration.underline
        // ),
      );
}

Map<String, Function> richTextGenerator = {
  'a': (String text) => DynamicRichTextSpan().underlinedTextSpan(text, null),
  'z': (String text) => DynamicRichTextSpan().defaultTextSpan(text),
};

List<InlineSpan> stringToRichText(String text, {bool shouldReverse = true}) {
  var spans = <InlineSpan>[];

  text.split('{{').forEach((element) {
    if (element.contains("}}")) {
      spans.add(richTextGenerator[element.split('}}')[0].substring(0, 1)]!(
          element.split('}}')[0].substring(1)));
      if (!element.endsWith("}}")) {
        spans.add(richTextGenerator['z']!(element.split('}}')[1]));
      }
    } else {
      spans.add(richTextGenerator['z']!(element));
    }
  });
  text.isArabic() ? spans = spans.reversed.toList() : spans = spans;
  return spans;
}

extension StringExtension on String {
  String normalize() {
    return replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .toLowerCase()
        .trim()
        .trimLeft();
  }

  bool isArabic() {
    final RegExp arabic = RegExp(r'^[\u0621-\u064A]+');
    return arabic.hasMatch(this) ? true : false;
  }
}
