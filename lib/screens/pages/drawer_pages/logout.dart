import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyavasaay/database/database_helper.dart';
import 'package:vyavasaay/screens/introduction_screens/splash_screen.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/custom_page_route.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  void initState() {
    super.initState();
    database.initDB();
  }

  final databaseHelper = DatabaseHelper();

  final database = DatabaseHelper();

  void navigate(BuildContext context) {
    Navigator.pushReplacement(
      context,
      // MaterialPageRoute(
      //   builder: (context) {
      //     return const SplashScreen();
      //   },
      // ),
      MyCustomPageRoute(
        route: const SplashScreen(),
      ),
    );
  }

  void logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    final loginPersonId = prefs.getInt('loggedInId');
    final model = await databaseHelper.getLoginInfo(personId: loginPersonId!);
    await databaseHelper
        .updateStatusOfLogin(
          model: model.copyWith(
            logoutTime:
                DateFormat('dd MMMM yyyy hh:mm:ss a').format(DateTime.now()),
          ),
        )
        .then((value) => navigate(context));
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 1), () async {
      logOut(context);
    });
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Logging you out!',
            style: TextStyle(
              fontSize: titleLargeTextSize,
            ),
          ),
        ],
      ),
    );
  }
}
