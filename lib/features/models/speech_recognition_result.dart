class SpeechRecognitionResult {
  String recognitionStatus;
  List<NBestEntry> nBest;
  String displayText;

  SpeechRecognitionResult({
    required this.recognitionStatus,
    required this.nBest,
    required this.displayText,
  });

  factory SpeechRecognitionResult.fromJson(Map<String, dynamic> json) {
    SpeechRecognitionResult? result;
    try {
      result = SpeechRecognitionResult(
        recognitionStatus: json['RecognitionStatus'],
        nBest: List<NBestEntry>.from(
            json['NBest'].map((x) => NBestEntry.fromJson(x))),
        displayText: json['DisplayText'],
      );
    } catch (e) {}
    return result ??
        SpeechRecognitionResult(
          recognitionStatus: "Error",
          nBest: [],
          displayText: "",
        );
  }
}

class NBestEntry {
  double confidence;
  String lexical;
  double accuracyScore;
  double fluencyScore;
  double completenessScore;
  double pronScore;
  List<Word> words;

  NBestEntry({
    required this.confidence,
    required this.lexical,
    required this.accuracyScore,
    required this.fluencyScore,
    required this.completenessScore,
    required this.pronScore,
    required this.words,
  });

  factory NBestEntry.fromJson(Map<String, dynamic> json) {
    return NBestEntry(
      confidence: json['Confidence'],
      lexical: json['Lexical'],
      accuracyScore: json['AccuracyScore'],
      fluencyScore: json['FluencyScore'],
      completenessScore: json['CompletenessScore'],
      pronScore: json['PronScore'],
      words: List<Word>.from(
        json['Words'].map(
          (x) => Word.fromJson(
            x,
          ),
        ),
      ),
    );
  }
}

class Word {
  String word;
  double confidence;
  double accuracyScore;
  List<Syllable> syllables;
  List<Phoneme> phonemes;

  Word({
    required this.word,
    required this.confidence,
    required this.accuracyScore,
    required this.syllables,
    required this.phonemes,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      word: json['Word'],
      confidence: json['Confidence'],
      accuracyScore: json['AccuracyScore'],
      syllables: List<Syllable>.from(
          json['Syllables'].map((x) => Syllable.fromJson(x))),
      phonemes:
          List<Phoneme>.from(json['Phonemes'].map((x) => Phoneme.fromJson(x))),
    );
  }
}

class Syllable {
  String syllable;
  double accuracyScore;

  Syllable({required this.syllable, required this.accuracyScore});

  factory Syllable.fromJson(Map<String, dynamic> json) {
    return Syllable(
      syllable: json['Syllable'],
      accuracyScore: json['AccuracyScore'],
    );
  }
}

class Phoneme {
  String phoneme;
  double accuracyScore;

  Phoneme({required this.phoneme, required this.accuracyScore});

  factory Phoneme.fromJson(Map<String, dynamic> json) {
    return Phoneme(
      phoneme: json['Phoneme'],
      accuracyScore: json['AccuracyScore'],
    );
  }
}
