import 'package:flutter/material.dart';

class WordView extends StatefulWidget {
  const WordView({super.key});

  @override
  State<WordView> createState() => WordViewState();
}

class WordViewState extends State<WordView> {
  @override
  Widget build(BuildContext context) {
    return Text("Words you learned today: (display list of words)");
  }
}
