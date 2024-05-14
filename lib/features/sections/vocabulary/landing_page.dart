// this may not be necessary
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:routemaster/routemaster.dart';

class VocabularySection extends StatelessWidget {
  const VocabularySection({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterStatusbarcolor.setStatusBarColor(Palette.primary);
    });
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Palette.secondary,
          ),
          onPressed: () {
            Routemaster.of(context).history.back();
          },
        ),
        title: const Text('Vocabulary Section'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Vocabulary Section'),
            Button(
              onPressed: () {
                Routemaster.of(context).push('/section/vocabulary/word_list');
              },
              text: "Continue",
            ),
          ],
        ),
      ),
    );
  }
}
