import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIsConstants {
  static String ttsEndPoint = "/cognitiveservices/v1";
  static String sttEndPoint =
      "https://westeurope.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US";
  static String apiKey = dotenv.env['AZURE_API_KEY_1'] ?? '';
}
