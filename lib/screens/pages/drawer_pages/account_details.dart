import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vyavasaay/database/database_helper.dart';
import 'package:vyavasaay/model/patient_model.dart';
import 'package:vyavasaay/screens/pages/drawer_pages/dashboard.dart';
import 'package:vyavasaay/utils/constants.dart';

class AccountDetails extends ConsumerStatefulWidget {
  const AccountDetails({super.key});

  @override
  ConsumerState<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends ConsumerState<AccountDetails> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  int id = 0;
  String name = 'null';
  String userType = 'Technician';
  List<Color> colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];
  @override
  void initState() {
    super.initState();
    databaseHelper.initDB();
    getPref();
    getUserType();
    getPreviousMonth();
  }

  void getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString('logInType') ?? 'Technician';
    });
  }

  void getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    id = prefs.getInt('loggedInId') ?? 0;
    name = await databaseHelper.getAccountName(id: id);
    setState(() {});
  }

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

  Future<String> getTotalBillingCount() async {
    List<PatientModel> patientList =
        await databaseHelper.getPatientListofTechnician(technicianId: id);
    return patientList.length.toString();
  }

  Future<String> getTotalBillingUltrasound() async {
    List<PatientModel> patientList = await databaseHelper
        .getPatientListByTechnicianIdAndType(id: id, type: 'Ultrasound');
    return patientList.length.toString();
  }

  Future<String> getTotalBillingPathology() async {
    List<PatientModel> patientList = await databaseHelper
        .getPatientListByTechnicianIdAndType(id: id, type: 'Pathology');
    return patientList.length.toString();
  }

  Future<String> getTotalBillingECG() async {
    List<PatientModel> patientList = await databaseHelper
        .getPatientListByTechnicianIdAndType(id: id, type: 'ECG');
    return patientList.length.toString();
  }

  Future<String> getTotalBillingXRay() async {
    List<PatientModel> patientList = await databaseHelper
        .getPatientListByTechnicianIdAndType(id: id, type: 'xray');
    return patientList.length.toString();
  }

  Future<String> getTotalIncentiveCount() async {
    int incentiveCount = 0;
    List<PatientModel> patientList =
        await databaseHelper.getPatientListofTechnician(technicianId: id);
    for (int i = 0; i < patientList.length; i++) {
      incentiveCount = incentiveCount + patientList[i].incentive;
    }
    return incentiveCount.toString();
  }

  Future<String> getMonthTotalBillingCount({required String month}) async {
    List<PatientModel> patientList =
        await databaseHelper.getPatientListByTechnicianIdAndMonth(
      id: id,
      month: month,
    );
    return patientList.length.toString();
  }

  Future<String> getMonthUltrasoundCount({required String month}) async {
    List<PatientModel> patientList =
        await databaseHelper.getPatientListByTechnicianIdMonthAndType(
            id: id, month: month, type: 'Ultrasound');
    return patientList.length.toString();
  }

  Future<String> getMonthPathologyCount({required String month}) async {
    List<PatientModel> patientList =
        await databaseHelper.getPatientListByTechnicianIdMonthAndType(
            id: id, month: month, type: 'Pathology');
    return patientList.length.toString();
  }

  Future<String> getMonthECGCount({required String month}) async {
    List<PatientModel> patientList =
        await databaseHelper.getPatientListByTechnicianIdMonthAndType(
            id: id, month: month, type: 'ECG');
    return patientList.length.toString();
  }

  Future<String> getMonthXRayCount({required String month}) async {
    List<PatientModel> patientList =
        await databaseHelper.getPatientListByTechnicianIdMonthAndType(
            id: id, month: month, type: 'xray');
    return patientList.length.toString();
  }

  Future<String> getMonthTotalIncentiveCount({required String month}) async {
    int incentiveCount = 0;
    List<PatientModel> patientList =
        await databaseHelper.getPatientListByTechnicianIdAndMonth(
      id: id,
      month: month,
    );
    for (int i = 0; i < patientList.length; i++) {
      incentiveCount = incentiveCount + patientList[i].incentive;
    }
    return incentiveCount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: getDeviceHeight(context: context) * 3,
        width: getDeviceWidth(context: context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bills Generated By $name',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(defaultSize),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  detailsContainer(
                    borderText: 'Total',
                    dataToBeFetched: () =>
                        getMonthTotalBillingCount(month: getThisMonth()),
                  ),
                  Gap(defaultSize),
                  detailsContainer(
                    borderText: 'Ultrasound',
                    dataToBeFetched: () =>
                        getMonthUltrasoundCount(month: getThisMonth()),
                  ),
                  Gap(defaultSize),
                  detailsContainer(
                    borderText: 'Pathology',
                    dataToBeFetched: () =>
                        getMonthPathologyCount(month: getThisMonth()),
                  ),
                  Gap(defaultSize),
                  detailsContainer(
                    borderText: 'ECG',
                    dataToBeFetched: () =>
                        getMonthECGCount(month: getThisMonth()),
                  ),
                  Gap(defaultSize),
                  detailsContainer(
                    borderText: 'X-Ray',
                    dataToBeFetched: () =>
                        getMonthXRayCount(month: getThisMonth()),
                  ),
                  Visibility(
                    visible: userType == 'Admin',
                    child: Gap(defaultSize),
                  ),
                  detailsContainer(
                      borderText: 'Incentive',
                      userType: userType,
                      dataToBeFetched: () =>
                          getMonthTotalIncentiveCount(month: getThisMonth()))
                ],
              ),
            ),
            Gap(defaultSize),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  detailsContainer(
                    borderText: 'Total',
                    dataToBeFetched: () =>
                        getMonthTotalBillingCount(month: getPreviousMonth()),
                  ),
                  Gap(defaultSize),
                  detailsContainer(
                    borderText: 'Ultrasound',
                    dataToBeFetched: () =>
                        getMonthUltrasoundCount(month: getPreviousMonth()),
                  ),
                  Gap(defaultSize),
                  detailsContainer(
                    borderText: 'Pathology',
                    dataToBeFetched: () =>
                        getMonthPathologyCount(month: getPreviousMonth()),
                  ),
                  Gap(defaultSize),
                  detailsContainer(
                    borderText: 'ECG',
                    dataToBeFetched: () =>
                        getMonthECGCount(month: getPreviousMonth()),
                  ),
                  Gap(defaultSize),
                  detailsContainer(
                    borderText: 'X-Ray',
                    dataToBeFetched: () =>
                        getMonthXRayCount(month: getPreviousMonth()),
                  ),
                  Visibility(
                    visible: userType == 'Admin',
                    child: Gap(defaultSize),
                  ),
                  detailsContainer(
                      borderText: 'Incentive',                      userType: userType,

                      dataToBeFetched: () => getMonthTotalIncentiveCount(
                          month: getPreviousMonth()))
                ],
              ),
            ),
            Gap(defaultSize),
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(defaultSize),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  detailsContainer(
                    borderText: 'Total',
                    dataToBeFetched: () =>
                        getTotalBillingCount(),
                  ),
                  Gap(defaultSize),
                  detailsContainer(
                    borderText: 'Ultrasound',
                    dataToBeFetched: () =>
                        getTotalBillingUltrasound(),
                  ),
                  Gap(defaultSize),
                  detailsContainer(
                    borderText: 'Pathology',
                    dataToBeFetched: () =>
                        getTotalBillingPathology(),
                  ),
                  Gap(defaultSize),
                  detailsContainer(
                    borderText: 'ECG',
                    dataToBeFetched: () =>
                        getTotalBillingECG(),
                  ),
                  Gap(defaultSize),
                  detailsContainer(
                    borderText: 'X-Ray',
                    dataToBeFetched: () =>
                        getTotalBillingXRay(),
                  ),
                  Visibility(
                    visible: userType == 'Admin',
                    child: Gap(defaultSize),
                  ),
                  detailsContainer(
                      borderText: 'Incentive',
                      userType: userType,
                      dataToBeFetched: () => getTotalIncentiveCount())
                ],
              ),
            ),
            Gap(defaultSize),
            const Text(
              'Billing History',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(defaultSize),
            Expanded(
              child: FutureBuilder(
                future:
                    databaseHelper.getPatientListofTechnician(technicianId: id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Some error occurred while fetching data from this account',
                        style: patientHeader,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No data to display',
                          style: patientHeader,
                        ),
                      );
                    }
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        color: primaryColorLite,
                        child: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].name,
                                      style: patientHeader,
                                    ),
                                    Text(
                                      snapshot.data![index].type,
                                      style: patientHeaderSmall,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                snapshot.data![index].date,
                                style: patientHeaderSmall,
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
    );
  }
}
