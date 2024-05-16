import 'package:easy_localization/easy_localization.dart';
import 'package:ez_english/firebase_options.dart';
import 'package:ez_english/router.dart';
import 'package:ez_english/theme/palette.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
        Locale('tr'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // this value will be initially false, after the user creates an account
    // or logs in, it will be set to true and retreived from sharedPreferences
    bool isLoggedIn = true;
    context.setLocale(const Locale('en'));
    return
        // AppProviders(
        //   child:
        ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, child) => MaterialApp.router(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        title: 'EZ English',
        theme: Palette.lightModeAppTheme,
        // ignore: dead_code
        routerConfig: isLoggedIn ? loggedInRouter : loggedOutRotuer,
      ),
      // ),
    );
  }
}
