import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:vyavasaay/database/database_helper.dart';
import 'package:vyavasaay/model/user_model.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/container_button.dart';
import 'package:vyavasaay/widgets/custom_textfield.dart';
import 'package:vyavasaay/widgets/update_screen_widget.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final name = TextEditingController();

  final phone = TextEditingController();

  final password = TextEditingController();

  final cPassword = TextEditingController();
  final accountType = TextEditingController();
  List<String> accountTypeList = ['Technician', 'Admin'];
  bool isAdminAccount = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    accountType.text = 'Technician';
    databaseHelper.initDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorDark,
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        child: UpdateScreenWidget(
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: name,
                          hintText: 'Name',
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
                          value: accountTypeList.first,
                          items: accountTypeList.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              accountType.text = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Gap(defaultSize),
                  CustomTextField(
                    controller: phone,
                    hintText: 'Phone Number',
                  ),
                  Gap(defaultSize),
                  CustomTextField(
                    controller: password,
                    isObscure: true,
                    hintText: 'Password',
                  ),
                  Gap(defaultSize),
                  CustomTextField(
                    controller: cPassword,
                    isConfirm: true,
                    isObscure: true,
                    hintText: 'Confirm Password',
                    passwordController: password,
                  ),
                  Gap(defaultSize),
                  GestureDetector(
                    onTap: () async {
                      ScaffoldMessenger.of(context).clearMaterialBanners();
                      if (formKey.currentState!.validate()) {
                        {
                          await databaseHelper
                              .createAccount(
                            model: UserModel(
                              name: name.text.toUpperCase(),
                              phoneNumber: phone.text,
                              password: password.text,
                              accountType: accountType.text,
                            ),
                          )
                              .then((value) {
                            Navigator.pop(context, value);
                          }).onError((error, stackTrace) {
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
                                  'User already exists. Try adding a different name',
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .clearMaterialBanners();
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
                          });
                        }
                      }
                    },
                    child: const ContainerButton(
                        iconData: Icons.create_outlined,
                        btnName: 'Create Account'),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
