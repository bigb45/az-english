import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_english/core/constants.dart';
import 'package:ez_english/core/firebase/constants.dart';
import 'package:ez_english/core/network/apis_constants.dart';
import 'package:ez_english/core/network/custom_response.dart';
import 'package:ez_english/core/network/network_helper.dart';
import 'package:ez_english/features/sections/components/view_model/dictation_question_view.model.dart';
import 'package:ez_english/features/sections/writing/viewmodel/writing_section_viewmodel.dart';
import 'package:ez_english/widgets/audio_control_button.dart';
import 'package:ez_english/widgets/text_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../models/dictation_question_model.dart';

class DictationQuestion extends StatefulWidget {
  final TextEditingController controller = TextEditingController();
  final Function(String) onAnswerChanged;
  final DictationQuestionModel question;
  DictationQuestion({
    super.key,
    required this.onAnswerChanged,
    required this.question,
  });

  @override
  State<DictationQuestion> createState() => _DictationQuestionState();
}

class _DictationQuestionState extends State<DictationQuestion> {
  final String apiKey = dotenv.env['AZURE_API_KEY_1'] ?? '';
  late DictationQuestionViewModel viewmodel;
  void initState() {
    super.initState();
    viewmodel = Provider.of<DictationQuestionViewModel>(context, listen: false);
  }

  final AudioPlayer player = AudioPlayer();
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
              onPressed: () async {
                String audioUrl =
                    await viewmodel.getAudioBytes(widget.question);
                await player.setUrl(audioUrl);
                player.play();
                viewmodel.setLoading(false);
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

class DictationQuestionAudioSource extends StreamAudioSource {
  final List<int> bytes;
  DictationQuestionAudioSource(this.bytes);

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

extension StringExtension on String {
  String normalize() {
    return replaceAll(RegExp(r'[^\w\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .toLowerCase();
  }
}
