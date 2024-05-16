// this may not be necessary
import 'package:ez_english/theme/palette.dart';
import 'package:ez_english/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:go_router/go_router.dart';

class VocabularySection extends StatelessWidget {
  const VocabularySection({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterStatusbarcolor.setStatusBarColor(Palette.primary);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Section'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: Center(child: Text('Vocabulary Section'))),
            Button(
              onPressed: () {
                context.push('/practice/vocabulary');
              },
              text: "Continue",
            ),
          ],
        ),
      ),
    );
  }
}
