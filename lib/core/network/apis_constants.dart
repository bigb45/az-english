import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIConstants {
  static String ttsEndPoint =
      "https://westeurope.tts.speech.microsoft.com/cognitiveservices/v1";
  static String sttEndPoint =
      "https://westeurope.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US";
  static String ttsApiKey = dotenv.env['AZURE_API_KEY_1'] ?? '';
  static String sttApiKey = dotenv.env['AZURE_API_KEY_2'] ?? '';
}
