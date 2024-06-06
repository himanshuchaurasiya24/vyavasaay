import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vyavasaay/screens/introduction_screens/splash_screen.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:window_size/window_size.dart';

late SharedPreferences pref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();

  sqfliteFfiInit();
  databaseFactoryOrNull = databaseFactoryFfi;
  if (Platform.isWindows) {
    setWindowTitle('Vyavasaay');
    setWindowMaxSize(Size.infinite);
    setWindowMinSize(
      const Size(1280, 720),
    );
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: btnColor,
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          useMaterial3: true,
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          scaffoldBackgroundColor: primaryColorDark,
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: btnColor),
          appBarTheme: AppBarTheme(
            backgroundColor: primaryColorDark,
            centerTitle: true,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: WidgetStatePropertyAll(btnColor),
              foregroundColor: const WidgetStatePropertyAll(
                Colors.black,
              ),
            ),
          ),
          checkboxTheme: CheckboxThemeData(
            overlayColor: WidgetStatePropertyAll(primaryColorLite),
            checkColor: WidgetStatePropertyAll(btnColor),
            fillColor: WidgetStatePropertyAll(primaryColorDark),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: primaryColorLite,
          ).copyWith(error: Colors.black),
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: btnColor, selectionColor: btnColor)),
      home: const SplashScreen(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}
