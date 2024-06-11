import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyavasaay/database/database_helper.dart';
import 'package:vyavasaay/model/user_model.dart';
import 'package:vyavasaay/screens/login_signup_screens/login_screen.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/container_button.dart';
import 'package:vyavasaay/widgets/custom_page_route.dart';
import 'package:vyavasaay/widgets/custom_textfield.dart';
import 'package:vyavasaay/widgets/update_screen_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController accountTypeController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController centerNameController = TextEditingController();
  Color containerColor = primaryColorLite;
  DatabaseHelper database = DatabaseHelper();
  List<String> accountType = ['Admin'];
  int adminAccountLength = 10;
  void setCenterName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('centerName', centerNameController.text.toUpperCase());
  }

  @override
  void initState() {
    accountTypeController.text = accountType.first;
    database.initDB().whenComplete(() async {
      adminAccountLength = await database.getAdminAccountLength();
    });
    super.initState();
  }

  void showBanner(BuildContext context) {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        padding: EdgeInsets.only(
          left: defaultSize + 10,
          right: defaultSize - 10,
        ),
        backgroundColor: primaryColorDark,
        dividerColor: primaryColorDark,
        contentTextStyle: TextStyle(
          fontSize: defaultSize,
          fontWeight: FontWeight.w600,
        ),
        forceActionsBelow: false,
        overflowAlignment: OverflowBarAlignment.end,
        content: const Text(
          'An Admin Account is Already Created.\nContact Admin For Your Account Creation.',
          style: TextStyle(
            color: Colors.black,
          ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: titleLargeTextSize,
                          ),
                        ),
                        Gap(defaultSize),
                        CustomTextField(
                          controller: nameController,
                          hintText: 'Name',
                        ),
                        Gap(defaultSize),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: centerNameController,
                                hintText: 'Center Name',
                              ),
                            ),
                            Gap(defaultSize),
                            Expanded(
                              child: DropdownButtonFormField(
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
                                value: accountType.first,
                                items: accountType.map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    accountTypeController.text = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Gap(defaultSize),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: passwordController,
                                isObscure: true,
                                hintText: 'Password',
                              ),
                            ),
                            Gap(defaultSize),
                            Expanded(
                              child: CustomTextField(
                                controller: confirmPasswordController,
                                isObscure: true,
                                isConfirm: true,
                                passwordController: passwordController,
                                hintText: 'Confirm Password',
                              ),
                            ),
                          ],
                        ),
                        Gap(defaultSize),
                        CustomTextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          hintText: 'Phone Number',
                        ),
                        Gap(defaultSize),
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context)
                                  .clearMaterialBanners();
                              if (adminAccountLength > 0) {
                                showBanner(context);
                                return;
                              } else {
                                await database
                                    .createAccount(
                                      model: UserModel(
                                        name: nameController.text.toUpperCase(),
                                        phoneNumber: phoneController.text,
                                        password: passwordController.text,
                                        accountType: accountTypeController.text,
                                      ),
                                    )
                                    .then(
                                      (value) => {
                                        if (value != 0)
                                          {
                                            setCenterName(),
                                            Navigator.pushReplacement(
                                              context,
                                              // MaterialPageRoute(
                                              //   builder: (context) {
                                              //     return const LoginScreen();
                                              //   },
                                              // ),
                                              MyCustomPageRoute(
                                                route: const LoginScreen(),
                                              ),
                                            ),
                                          }
                                        else
                                          {
                                            showBanner(context),
                                          }
                                      },
                                    );
                              }
                            }
                          },
                          child: const ContainerButton(
                              iconData: Icons.check_circle_outline_outlined,
                              btnName: 'Sign up'),
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
                                    'Already have an account?',
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
                                        //     return const LoginScreen();
                                        //   },
                                        // ),
                                        MyCustomPageRoute(
                                          route: const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Log in instead',
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
