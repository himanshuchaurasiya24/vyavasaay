import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyavasaay/database/database_helper.dart';
import 'package:vyavasaay/screens/introduction_screens/splash_screen.dart';
import 'package:vyavasaay/screens/login_signup_screens/login_screen.dart';
import 'package:vyavasaay/screens/pages/account_control/change_account_details.dart';
import 'package:vyavasaay/screens/pages/account_control/create_account.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/custom_floating_action_button.dart';
import 'package:vyavasaay/widgets/custom_page_route.dart';

class AccessControl extends StatefulWidget {
  const AccessControl({super.key});

  @override
  State<AccessControl> createState() => _AccessControlState();
}

class _AccessControlState extends State<AccessControl> {
  var adminAccountLength = 0;
  @override
  void initState() {
    super.initState();
    databaseHelper.initDB();
  }

  final DatabaseHelper databaseHelper = DatabaseHelper();
  Future<int> checkAdminExists() async {
    adminAccountLength = await databaseHelper.getAdminAccountLength();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fetchedName =
        await databaseHelper.getAccountName(id: prefs.getInt('loggedInId')!);

    if (adminAccountLength < 1) {
      await databaseHelper.deleteEverything().then((value) {
        return Navigator.pushReplacement(
          context,
          MyCustomPageRoute(
            route: const SplashScreen(),
          ),
        );
      });
    } else if (fetchedName == 'null') {
      prefs.setBool('isLoggedIn', false);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MyCustomPageRoute(
            route: const LoginScreen(),
          ),
        );
      }
    }
    return adminAccountLength;
  }

  @override
  Widget build(BuildContext context) {
    checkAdminExists();
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(defaultSize),
                      child: Column(
                        children: [
                          Text(
                            'Admin Account List',
                            style: patientHeader,
                          ),
                          Gap(defaultSize),
                          Expanded(
                            child: FutureBuilder(
                              future: databaseHelper.getAllAdminAccount(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Some error occurred!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  );
                                }
                                if (snapshot.hasData) {
                                  if (snapshot.data!.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'Empty Admin Account',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    );
                                  }
                                }
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: primaryColorLite,
                                      elevation: 0,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: defaultSize),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data![index].name,
                                                  style: patientHeader,
                                                ),
                                                Text(
                                                  snapshot
                                                      .data![index].phoneNumber,
                                                  style: patientHeaderSmall,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    await Navigator.push(
                                                      context,
                                                      MyCustomPageRoute(
                                                        route:
                                                            ChangeAccountDetails(
                                                          userModel: snapshot
                                                              .data![index],
                                                          adminAccountLength:
                                                              adminAccountLength,
                                                        ),
                                                      ),
                                                    ).then((value) =>
                                                        setState(() {}));
                                                  },
                                                  icon: const Icon(
                                                      Icons.edit_outlined),
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                            'Are you sure you want to delete this account?\nDeleting this will also delete entries made by this account',
                                                            style:
                                                                patientHeaderSmall,
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await databaseHelper
                                                                    .deleteAccount(
                                                                        userId: snapshot
                                                                            .data![
                                                                                index]
                                                                            .id!)
                                                                    .then(
                                                                        (value) {
                                                                  Navigator.pop(
                                                                      context);
                                                                }).onError((error,
                                                                            stackTrace) =>
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(
                                                                              content: Text(
                                                                                error.toString(),
                                                                                style: patientHeader,
                                                                              ),
                                                                            );
                                                                          },
                                                                        ));
                                                              },
                                                              child: Text(
                                                                'Yes',
                                                                style: patientChildrenHeading
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .red[400]),
                                                              ),
                                                            ),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'No',
                                                                  style: patientChildrenHeading
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.green[400]),
                                                                ))
                                                          ],
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        setState(() {}));
                                                  },
                                                  icon: Icon(
                                                    Icons.delete_outlined,
                                                    color: Colors.red[400]!,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(defaultSize),
                      child: Column(
                        children: [
                          Text(
                            'Technician Account List',
                            style: patientHeader,
                          ),
                          Gap(defaultSize),
                          Expanded(
                            child: FutureBuilder(
                              future: databaseHelper.getAllTechnicianAccount(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Some error occurred!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  );
                                }
                                if (snapshot.hasData) {
                                  if (snapshot.data!.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'Empty technician Account',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                    );
                                  }
                                }
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: primaryColorLite,
                                      elevation: 0,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: defaultSize),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data![index].name,
                                                  style: patientHeader,
                                                ),
                                                Text(
                                                  snapshot
                                                      .data![index].phoneNumber,
                                                  style: patientHeaderSmall,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    await Navigator.push(
                                                      context,
                                                      MyCustomPageRoute(
                                                        route:
                                                            ChangeAccountDetails(
                                                          userModel: snapshot
                                                              .data![index],
                                                        ),
                                                      ),
                                                    ).then((value) =>
                                                        setState(() {}));
                                                  },
                                                  icon: const Icon(
                                                      Icons.edit_outlined),
                                                ),
                                                IconButton(
                                                  onPressed: () async {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                            'Are you sure you want to delete this account?\nDeleting this will also delete entries made by this account',
                                                            style:
                                                                patientHeaderSmall,
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                await databaseHelper
                                                                    .deleteAccount(
                                                                        userId: snapshot
                                                                            .data![
                                                                                index]
                                                                            .id!)
                                                                    .then(
                                                                        (value) {
                                                                  Navigator.pop(
                                                                      context);
                                                                }).onError((error,
                                                                            stackTrace) =>
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(
                                                                              content: Text(
                                                                                error.toString(),
                                                                                style: patientHeader,
                                                                              ),
                                                                            );
                                                                          },
                                                                        ));
                                                              },
                                                              child: Text(
                                                                'Yes',
                                                                style: patientChildrenHeading
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .red[400]),
                                                              ),
                                                            ),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'No',
                                                                  style: patientChildrenHeading
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.green[400]),
                                                                ))
                                                          ],
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        setState(() {}));
                                                  },
                                                  icon: Icon(
                                                    Icons.delete_outlined,
                                                    color: Colors.red[400]!,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(
              'To delete everything and start from the beginning you can delete all admin account',
              style: patientHeader,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 80,
            )
          ],
        ),
        Positioned(
          bottom: 10,
          right: 0,
          child: CustomFloatingActionButton(
              onTap: () async {
                await Navigator.push(
                  context,
                  MyCustomPageRoute(
                    route: const CreateAccount(),
                  ),
                ).then((value) => setState(() {}));
              },
              title: 'Create Account'),
        ),
      ],
    );
  }
}
