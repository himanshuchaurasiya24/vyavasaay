import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyavasaay/database/database_helper.dart';
import 'package:vyavasaay/model/login_history_model.dart';
import 'package:vyavasaay/screens/main_screen/home_screen.dart';
import 'package:vyavasaay/screens/login_signup_screens/signup_screen.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/container_button.dart';
import 'package:vyavasaay/widgets/custom_page_route.dart';
import 'package:vyavasaay/widgets/custom_textfield.dart';
import 'package:vyavasaay/widgets/update_screen_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController loginTypeController = TextEditingController();
  DatabaseHelper database = DatabaseHelper();
  List<String> loginType = ['Technician', 'Admin'];
  Color containerColor = primaryColorLite;
  String centerName = '';
  @override
  void initState() {
    loginTypeController.text = loginType.first;
    super.initState();
  }

  void showBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        backgroundColor: primaryColorDark,
        dividerColor: primaryColorDark,
        contentTextStyle: TextStyle(
          fontSize: defaultSize,
          fontWeight: FontWeight.w600,
        ),
        forceActionsBelow: false,
        overflowAlignment: OverflowBarAlignment.end,
        content: const Text(
          'No Account Found.',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).clearMaterialBanners();
            },
            icon: Text(
              'Okay',
              style: TextStyle(
                fontSize: defaultSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logIn(
      {required String name,
      required String loginType,
      required int personId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('logInType', loginType);
    prefs.setInt('loggedInId', personId);
    centerName = prefs.getString('centerName') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UpdateScreenWidget(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/login_signup.png',
            ),
            Form(
              key: _formKey,
              child: Expanded(
                child: Padding(
                  padding: EdgeInsets.all(defaultSize),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Log In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: titleLargeTextSize,
                          ),
                        ),
                        SizedBox(
                          height: defaultSize,
                        ),
                        CustomTextField(
                          controller: nameController,
                          hintText: 'Name',
                        ),
                        SizedBox(
                          height: defaultSize,
                        ),
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          isObscure: true,
                        ),
                        SizedBox(
                          height: defaultSize,
                        ),
                        DropdownButtonFormField(
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadius),
                          dropdownColor: primaryColorDark,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: primaryColorDark,
                            filled: true,
                          ),
                          value: loginType.first,
                          items: loginType.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              loginTypeController.text = value!;
                            });
                          },
                        ),
                        SizedBox(
                          height: defaultSize,
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context)
                                  .clearMaterialBanners();
                              await database
                                  .authAccount(
                                name: nameController.text.toUpperCase(),
                                password: passwordController.text,
                                loginType: loginTypeController.text,
                              )
                                  .then((value) async {
                                if (value == true) {
                                  final model = await database.getAccount(
                                    name: nameController.text.toUpperCase(),
                                  );
                                  final name = model!.name;
                                  final personId = model.id!;
                                  final loginType = model.accountType;
                                  logIn(
                                    name: name,
                                    loginType: loginType,
                                    personId: personId,
                                  );
                                  await database
                                      .addToLoginHistory(
                                        model: LoginHistoryModel(
                                          personId: personId,
                                          name: name,
                                          loginTime: DateFormat(
                                                  'dd MMMM yyyy hh:mm:ss a')
                                              .format(DateTime.now()),
                                          logoutTime: 'Currently logged in',
                                          type: loginType,
                                        ),
                                      )
                                      .then(
                                          (value) => Navigator.pushReplacement(
                                                context,
                                                MyCustomPageRoute(
                                                  route: HomeScreen(
                                                    name: name,
                                                    logInType: loginType,
                                                    centerName: centerName,
                                                  ),
                                                ),
                                              ));
                                } else {
                                  showBanner(context);
                                }
                              });
                            }
                          },
                          child: const ContainerButton(
                              iconData: Icons.login_outlined, btnName: 'Login'),
                        ),
                        SizedBox(
                          height: defaultSize,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                  const Text(
                                    'Don\'t have an account?',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .clearMaterialBanners();
                                      Navigator.pushReplacement(
                                        context,
                                        // MaterialPageRoute(
                                        //   builder: (context) {
                                        //     return const SignUpScreen();
                                        //   },
                                        // ),
                                        MyCustomPageRoute(
                                          route: const SignUpScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Sign up instead',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
