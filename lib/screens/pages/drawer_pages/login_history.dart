import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyavasaay/database/database_helper.dart';
import 'package:vyavasaay/model/login_history_model.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/custom_details_card.dart';
import 'package:vyavasaay/widgets/custom_textfield.dart';
import 'package:vyavasaay/widgets/patient_details_child.dart';

class LoginHistory extends StatefulWidget {
  const LoginHistory({super.key});

  @override
  State<LoginHistory> createState() => _LoginHistoryState();
}

class _LoginHistoryState extends State<LoginHistory> {
  final databaseHelper = DatabaseHelper();
  String userType = 'Technician';
  int personId = 0;
  final searchController = TextEditingController();
  late Future<List<LoginHistoryModel>> loginList;
  void getUserType() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userType = prefs.getString('logInType') ?? 'Technician';
      personId = prefs.getInt('loggedInId') ?? 0;
    });
  }

  Future<List<LoginHistoryModel>> getLoginHistoryModel() async {
    if (userType == 'Admin') {
      if (searchController.text.isNotEmpty) {
        setState(() {
          loginList = databaseHelper.searchLoginHistoryByName(
              name: searchController.text);
        });
      } else {
        setState(() {
          loginList = databaseHelper.getAllLoginHistory();
        });
      }
    } else {
      setState(() {
        loginList = databaseHelper.searchLoginHistoryById(personId: personId);
      });
    }
    return loginList;
  }

  @override
  void initState() {
    super.initState();
    databaseHelper.initDB();
    getUserType();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Login History',
          style: appbar,
        ),
        const Gap(10),
        Visibility(
          visible: userType == 'Admin',
          child: CustomTextField(
            controller: searchController,
            hintText: 'Search here',
            onChanged: (p0) {
              getLoginHistoryModel();
            },
          ),
        ),
        Visibility(
          visible: userType == 'Admin',
          child: const Gap(10),
        ),
        Expanded(
          child: FutureBuilder(
            future: getLoginHistoryModel(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Some error occurred',
                  ),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Empty data'),
                  );
                }
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return CustomDetailsCard(
                    title: snapshot.data![index].name,
                    subtitle: Text(
                      'Login at ${snapshot.data![index].loginTime}',
                      style: patientHeaderSmall,
                    ),
                    trailing: snapshot.data![index].type,
                    children: [
                      PatientDetailsChild(
                        heading: 'Person Id ',
                        value: snapshot.data![index].personId.toString(),
                      ),
                      PatientDetailsChild(
                        heading: 'Logout at ',
                        value: snapshot.data![index].logoutTime.toString(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
