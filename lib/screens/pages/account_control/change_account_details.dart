import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:vyavasaay/database/database_helper.dart';
import 'package:vyavasaay/model/user_model.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/container_button.dart';
import 'package:vyavasaay/widgets/custom_textfield.dart';
import 'package:vyavasaay/widgets/update_screen_widget.dart';

class ChangeAccountDetails extends StatefulWidget {
  const ChangeAccountDetails({
    super.key,
    this.userModel,
    this.adminAccountLength = 2,
  });
  final UserModel? userModel;
  final int? adminAccountLength;
  @override
  State<ChangeAccountDetails> createState() => _ChangeAccountDetailsState();
}

class _ChangeAccountDetailsState extends State<ChangeAccountDetails> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final accountType = TextEditingController();
  bool changePassword = false;
  List<String> accountTypeList = ['Technician', 'Admin'];
  final databaseHelper = DatabaseHelper();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    databaseHelper.initDB();
    if (widget.userModel != null) {
      name.text = widget.userModel!.name;
      currentPassword.text = widget.userModel!.password;
      phone.text = widget.userModel!.phoneNumber;
      accountType.text = widget.userModel!.accountType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorLite,
      appBar: AppBar(
        title: const Text('Update Details'),
      ),
      body: SingleChildScrollView(
        child: UpdateScreenWidget(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: name,
                        hintText: 'Name',
                        readOnly: true,
                      ),
                    ),
                    Gap(defaultSize),
                    Expanded(
                      child: CustomTextField(
                        controller: phone,
                        hintText: 'Phone',
                      ),
                    ),
                    Gap(defaultSize),
                    Expanded(
                      child: CustomTextField(
                        controller: currentPassword,
                        hintText: 'Current Password',
                        readOnly: true,
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: !changePassword,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Want to update details?',
                        style: patientHeaderSmall,
                      ),
                      Gap(defaultSize),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            changePassword = !changePassword;
                          });
                        },
                        child: Text(
                          'Click Here',
                          style: patientChildrenHeading,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: changePassword,
                  child: Column(
                    children: [
                      Visibility(
                        visible: widget.adminAccountLength! > 1,
                        child: Gap(
                          defaultSize,
                        ),
                      ),
                      Visibility(
                        visible: widget.adminAccountLength! > 1,
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
                          value: widget.userModel == null
                              ? accountTypeList.first
                              : accountType.text,
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
                      Gap(defaultSize),
                      CustomTextField(
                        controller: newPassword,
                        hintText: 'New Passsword',
                        maxLines: 1,
                      ),
                      Gap(defaultSize),
                      CustomTextField(
                        controller: confirmPassword,
                        isConfirm: true,
                        passwordController: newPassword,
                        hintText: 'Confirm Passsword',
                        maxLines: 1,
                      ),
                      Gap(defaultSize),
                      GestureDetector(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            if (widget.userModel != null) {
                              await databaseHelper
                                  .updateAccount(
                                model: UserModel(
                                  id: widget.userModel!.id,
                                  name: name.text.toString(),
                                  phoneNumber: phone.text,
                                  password: confirmPassword.text.toString(),
                                  accountType: accountType.text,
                                ),
                              )
                                  .then((value) {
                                Navigator.pop(context, value);
                              });
                            }
                          }
                        },
                        child: const ContainerButton(
                            iconData: Icons.update_outlined,
                            btnName: 'Update info'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
