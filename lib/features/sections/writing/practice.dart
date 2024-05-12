// ignore_for_file: avoid_print

import 'package:ez_english/features/sections/components/evaluation_section.dart';
import 'package:ez_english/features/sections/writing/components/dictation_question.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/theme/text_styles.dart';
import 'package:ez_english/widgets/progress_bar.dart';
import 'package:ez_english/widgets/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WritingPractice extends StatefulWidget {
  const WritingPractice({super.key});

  @override
  State<WritingPractice> createState() => _WritingPracticeState();
}

class _WritingPracticeState extends State<WritingPractice> {
  late FlutterTts flutterTts;
  bool isSpeaking = false;

  configureTts() async {
    flutterTts = FlutterTts();

    // flutterTts.setProgressHandler((_, __, ___, currentWord) {
    //   print("$currentWord");
    // });
    // TODO: set voice to female voice

    // await flutterTts.setLanguage('en-US');
    // await flutterTts.setSpeechRate(0.5);
    // await flutterTts.setVolume(1.0);
    // await flutterTts.setPitch(0.5);
    // await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});

    flutterTts = FlutterTts();
    await flutterTts.awaitSpeakCompletion(true);

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
      });
    });

    flutterTts.setErrorHandler((message) {
      setState(() {
        print("Error: $message");
      });
    });

    // flutterTts.setStartHandler(() {
    //   setState(() {
    //     isSpeaking = true;
    //   });
    // });
    // flutterTts.completionHandler = () {
    //   setState(() {
    //     isSpeaking = false;
    //   });
    // };

    // await flutterTts.setSharedInstance(true);
    // await flutterTts.setIosAudioCategory(
    //     IosTextToSpeechAudioCategory.playback,
    //     [
    //       IosTextToSpeechAudioCategoryOptions.allowBluetooth,
    //       IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
    //       IosTextToSpeechAudioCategoryOptions.mixWithOthers,
    //       IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
    //     ],
    //     IosTextToSpeechAudioMode.defaultMode);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    });
    configureTts();
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  void speakText(String text) async {
    await flutterTts.speak(text);
  }

  void stopSpeaking() async {
    await flutterTts.stop();
  }

  final TextEditingController _controller = TextEditingController();
  String text = "The quick brown fox jumps over the lazy dog.";

  RadioItemData? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        title: ListTile(
          contentPadding: const EdgeInsets.only(left: 0, right: 0),
          title: Text(
            'Writing & Listening Practice',
            style: TextStyles.titleTextStyle.copyWith(
              color: Palette.primaryText,
            ),
          ),
          subtitle: Text(
            "Daily Conversations",
            style: TextStyles.subtitleTextStyle.copyWith(
              color: Palette.primaryText,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: ProgressBar(value: 20),
                    ),
                    // todo: pass tts state to dictation question to control the audio playback (play pause)
                    DictationQuestion(
                      controller: _controller,
                      text: text,
                      flutterTts: flutterTts,
                    ),
                    // MultipleChoiceQuestion(
                    //   question:
                    //       "Select the sentence that best describes the image above",
                    //   image: "assets/images/writing_question_image.png",
                    //   options: [
                    //     RadioItemData(title: "A Backpack", value: "1"),
                    //     RadioItemData(title: "A Leather Purse", value: "2"),
                    //     RadioItemData(title: "A Suitcase", value: "3"),
                    //     RadioItemData(title: "A Shopping Bag", value: "4"),
                    //   ],
                    //   onChanged: (value) {
                    //     selectedOption = value;
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          ),
          EvaluateAnswer(
            onPressed: () {
              print("Continuing");
            },
          )
        ],
      ),
    );
  }
}
