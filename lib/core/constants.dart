import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Constants {
  static const wrongAnswerSkipLimit = 3;

  static final gapW10 = SizedBox(width: 10.w);
  static final gapW4 = SizedBox(width: 4.w);

  static final gapH8 = SizedBox(height: 8.h);
  static final gapH12 = SizedBox(height: 12.h);
  static final gapH14 = SizedBox(height: 14.h);
  static final gapH16 = SizedBox(height: 16.h);
  static final gapH18 = SizedBox(height: 18.h);
  static final gapH24 = SizedBox(height: 24.h);
  static final gapH20 = SizedBox(height: 20.h);
  static final gapH28 = SizedBox(height: 28.h);
  static final gapH36 = SizedBox(height: 36.h);

  static final gapAppBarH = SizedBox(height: 56.h);

  static final padding30 = 30.w;
  static final padding20 = 20.w;
  static final padding12 = 12.w;
  static final padding8 = 8.w;
  static final padding6 = 6.w;
  static final padding4 = 4.w;
  static final padding2 = 2.w;
  static final iconSizeWidth20 = 20.w;
}

class RouteConstants {
  // map of  Id, Level name
  static final Map<String, String> levelIdName = {
    "0": "A1",
    "1": "A2",
    "2": "B1",
    "3": "B2",
    "4": "C1",
    "5": "C2",
  };

  static final Map<String, String> sectionIdName = {
    "0": "reading",
    "1": "writing",
    "2": "vocabulary",
    "3": "grammar",
    '4': 'test'
  };
  static final Map<String, String> sectionNameId = {
    "reading": "0",
    "listeningWriting": "1",
    "vocabulary": "2",
    "grammar": "3",
    'test': "4"
  };
  static final Map<String, int> levelNameId = {
    "A1": 0,
    "A2": 1,
    "B1": 2,
    "B2": 3,
    "C1": 4
  };

  static const String readingSectionName = "reading";
  static const String listeningWritingSectionName = "listeningWriting";
  static const String vocabularySectionName = "vocabulary";
  static const String grammarSectionName = "grammar";
  static const String testSectionName = "test";
  static String getSectionIds(String sectionName) {
    return sectionNameId[sectionName]!;
  }

  static String getSectionName(String sectionId) {
    return sectionIdName[sectionId]!;
  }

  static String getLevelName(String levelId) {
    return levelIdName[levelId]!;
  }

  static int getLevelIds(String levelName) {
    return levelNameId[levelName]!;
  }
}
