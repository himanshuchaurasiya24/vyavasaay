import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyavasaay/database/database_helper.dart';
import 'package:vyavasaay/model/patient_model.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/details_container.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key, this.type});
  final String? type;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  String userType = 'Technician';

  @override
  void initState() {
    super.initState();
    databaseHelper.initDB();
    getUserType();
  }

  void getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString('logInType') ?? 'Technician';
    });
  }

  List<Color> colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  String getPreviousMonth() {
    DateTime tempDate = DateTime.now();
    final parsedMonthFormat = DateFormat('M');
    final formatMonth = parsedMonthFormat.format(tempDate);
    int monthNum = int.tryParse(formatMonth)!;
    String monthString = '';
    debugPrint(monthNum.toString());
    final parsedYearFormat = DateFormat('yyyy');
    final formatYear = parsedYearFormat.format(tempDate);
    int yearNum = int.tryParse(formatYear)!;
    if (monthNum == 1) {
      yearNum = yearNum - 1;
      monthNum = 12;
    } else {
      monthNum = monthNum - 1;
    }
    if (monthNum < 10) {
      monthString = '0$monthNum';
    } else {
      monthString = '$monthNum';
    }
    final DateTime previousMonthString =
        DateTime.parse('$yearNum-$monthString-01');
    final previousMonthStringFormat = DateFormat('MMMM yyyy');
    final previousMonthDate =
        previousMonthStringFormat.format(previousMonthString);
    return previousMonthDate;
  }

  String getThisMonth() {
    DateTime tempDate = DateTime.now();
    final parsedDate = DateFormat('MMMM yyyy');
    final formatDate = parsedDate.format(tempDate);
    return formatDate;
  }

  Future<String> getAllPatientCount() async {
    final List<PatientModel> patientList =
        await databaseHelper.getAllPatientList();
    return patientList.length.toString();
  }

  Future<String> getAllPatientCountIncentive() async {
    int incentiveCount = 0;
    final List<PatientModel> patientList =
        await databaseHelper.getAllPatientList();
    for (int i = 0; i < patientList.length; i++) {
      incentiveCount = incentiveCount + patientList[i].incentive;
    }
    return incentiveCount.toString();
  }

  Future<String> getAllPatientCountMonthlyIncentive(
      {required String month}) async {
    int incentiveCount = 0;
    final List<PatientModel> patientList =
        await databaseHelper.getAllPatientListByMonth(month: month);
    for (int i = 0; i < patientList.length; i++) {
      incentiveCount = incentiveCount + patientList[i].incentive;
    }
    return incentiveCount.toString();
  }

  Future<String> getAllPatientCountUltrasound() async {
    final List<PatientModel> patientList =
        await databaseHelper.getAllPatientListByType(type: 'Ultrasound');
    return patientList.length.toString();
  }

  Future<String> getAllPatientCountPathology() async {
    final List<PatientModel> patientList =
        await databaseHelper.getAllPatientListByType(type: 'Pathology');
    return patientList.length.toString();
  }

  Future<String> getAllPatientCountECG() async {
    final List<PatientModel> patientList =
        await databaseHelper.getAllPatientListByType(type: 'ECG');
    return patientList.length.toString();
  }

  Future<String> getAllPatientCountXRay() async {
    final List<PatientModel> patientList =
        await databaseHelper.getAllPatientListByType(type: 'X-Ray');
    return patientList.length.toString();
  }

  Future<String> getAllPatientByMonth({required String month}) async {
    final List<PatientModel> patientList =
        await databaseHelper.getAllPatientListByMonth(month: month);
    return patientList.length.toString();
  }

  Future<String> getAllPatientByMonthAndType(
      {required String month, required String type}) async {
    final List<PatientModel> patientList = await databaseHelper
        .getAllPatientListByTypeAndMonth(month: month, type: type);
    return patientList.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: SizedBox(
          height: getDeviceHeight(context: context) * 1.5,
          width: getDeviceWidth(context: context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This Month',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(defaultSize),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DetailsContainer(
                      borderText: 'Total',
                      childWidget: FutureBuilder(
                        future: getAllPatientByMonth(month: getThisMonth()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(defaultSize),
                    DetailsContainer(
                      borderText: 'Ultrasound',
                      childWidget: FutureBuilder(
                        future: getAllPatientByMonthAndType(
                            month: getThisMonth(), type: 'Ultrasound'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(defaultSize),
                    DetailsContainer(
                      borderText: 'Pathology',
                      childWidget: FutureBuilder(
                        future: getAllPatientByMonthAndType(
                            month: getThisMonth(), type: 'Pathology'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(defaultSize),
                    DetailsContainer(
                      borderText: 'ECG',
                      childWidget: FutureBuilder(
                        future: getAllPatientByMonthAndType(
                            type: 'ECG', month: getThisMonth()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(defaultSize),
                    DetailsContainer(
                      borderText: 'X-Ray',
                      childWidget: FutureBuilder(
                        future: getAllPatientByMonthAndType(
                            month: getThisMonth(), type: 'X-Ray'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: userType == 'Admin',
                      child: Gap(defaultSize),
                    ),
                    Visibility(
                      visible: userType == 'Admin',
                      child: DetailsContainer(
                        borderText: 'Incentive',
                        childWidget: FutureBuilder(
                          future: getAllPatientCountMonthlyIncentive(
                              month: getThisMonth()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                'Loading',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                'Error',
                                style: TextStyle(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return const Text(
                                  'No data found',
                                  style: TextStyle(
                                    fontSize: 70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            }
                            return ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(defaultBorderRadius),
                                  bottomRight:
                                      Radius.circular(defaultBorderRadius)),
                              child: AnimatedTextKit(
                                repeatForever: true,
                                animatedTexts: [
                                  ColorizeAnimatedText(
                                    snapshot.data!,
                                    textStyle: TextStyle(
                                      fontSize:
                                          snapshot.data!.length > 7 ? 40 : 80,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    colors: colorizeColors,
                                  ),
                                ],
                                isRepeatingAnimation: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Previous Month',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(defaultSize),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DetailsContainer(
                      borderText: 'Total',
                      childWidget: FutureBuilder(
                        future: getAllPatientByMonth(month: getPreviousMonth()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(defaultSize),
                    DetailsContainer(
                      borderText: 'Ultrasound',
                      childWidget: FutureBuilder(
                        future: getAllPatientByMonthAndType(
                            month: getPreviousMonth(), type: 'Ultrasound'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(defaultSize),
                    DetailsContainer(
                      borderText: 'Pathology',
                      childWidget: FutureBuilder(
                        future: getAllPatientByMonthAndType(
                            month: getPreviousMonth(), type: 'Pathology'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(defaultSize),
                    DetailsContainer(
                      borderText: 'ECG',
                      childWidget: FutureBuilder(
                        future: getAllPatientByMonthAndType(
                            type: 'ECG', month: getPreviousMonth()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(defaultSize),
                    DetailsContainer(
                      borderText: 'X-Ray',
                      childWidget: FutureBuilder(
                        future: getAllPatientByMonthAndType(
                            month: getPreviousMonth(), type: 'X-Ray'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: userType == 'Admin',
                      child: Gap(defaultSize),
                    ),
                    Visibility(
                      visible: userType == 'Admin',
                      child: DetailsContainer(
                        borderText: 'Incentive',
                        childWidget: FutureBuilder(
                          future: getAllPatientCountMonthlyIncentive(
                              month: getPreviousMonth()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                'Loading',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                'Error',
                                style: TextStyle(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return const Text(
                                  'No data found',
                                  style: TextStyle(
                                    fontSize: 70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            }
                            return ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(defaultBorderRadius),
                                  bottomRight:
                                      Radius.circular(defaultBorderRadius)),
                              child: AnimatedTextKit(
                                repeatForever: true,
                                animatedTexts: [
                                  ColorizeAnimatedText(
                                    snapshot.data!,
                                    textStyle: TextStyle(
                                      fontSize:
                                          snapshot.data!.length > 7 ? 40 : 80,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    colors: colorizeColors,
                                  ),
                                ],
                                isRepeatingAnimation: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Total Bills Generated',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(defaultSize),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DetailsContainer(
                      borderText: 'Total',
                      childWidget: FutureBuilder(
                        future: getAllPatientCount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(defaultSize),
                    DetailsContainer(
                      borderText: 'Ultrasound',
                      childWidget: FutureBuilder(
                        future: getAllPatientCountUltrasound(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(defaultSize),
                    DetailsContainer(
                      borderText: 'Pathology',
                      childWidget: FutureBuilder(
                        future: getAllPatientCountPathology(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(defaultSize),
                    DetailsContainer(
                      borderText: 'ECG',
                      childWidget: FutureBuilder(
                        future: getAllPatientCountECG(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Gap(defaultSize),
                    DetailsContainer(
                      borderText: 'X-Ray',
                      childWidget: FutureBuilder(
                        future: getAllPatientCountXRay(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Loading',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data found',
                                style: TextStyle(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Visibility(
                      visible: userType == 'Admin',
                      child: Gap(defaultSize),
                    ),
                    Visibility(
                      visible: userType == 'Admin',
                      child: DetailsContainer(
                        borderText: 'Incentive',
                        childWidget: FutureBuilder(
                          future: getAllPatientCountIncentive(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text(
                                'Loading',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Text(
                                'Error',
                                style: TextStyle(
                                  fontSize: 100,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return const Text(
                                  'No data found',
                                  style: TextStyle(
                                    fontSize: 70,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            }
                            return ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(defaultBorderRadius),
                                  bottomRight:
                                      Radius.circular(defaultBorderRadius)),
                              child: AnimatedTextKit(
                                repeatForever: true,
                                animatedTexts: [
                                  ColorizeAnimatedText(
                                    snapshot.data!,
                                    textStyle: TextStyle(
                                      fontSize:
                                          snapshot.data!.length > 7 ? 40 : 80,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    colors: colorizeColors,
                                  ),
                                ],
                                isRepeatingAnimation: true,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
