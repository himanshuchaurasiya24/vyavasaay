import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:vyavasaay/database/database_helper.dart';
import 'package:vyavasaay/model/incentive_model.dart';
import 'package:vyavasaay/model/patient_model.dart';
import 'package:vyavasaay/screens/pages/incentive/show_incentive.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/container_button.dart';
import 'package:vyavasaay/widgets/custom_floating_action_button.dart';
import 'package:vyavasaay/widgets/custom_page_route.dart';
import 'package:vyavasaay/widgets/custom_textfield.dart';

class GenerateIncentive extends StatefulWidget {
  const GenerateIncentive({super.key});

  @override
  State<GenerateIncentive> createState() => _GenerateIncentiveState();
}

class _GenerateIncentiveState extends State<GenerateIncentive> {
  bool pName = true;
  bool date = true;
  bool age = true;
  bool sex = false;
  bool type = true;
  bool remark = false;
  bool total = true;
  bool paid = false;
  bool incentive = true;
  bool incentivePerc = true;
  bool discountByDoc = true;
  bool discountByCenter = false;
  bool dName = false;
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final docIdController = TextEditingController();
  final docNameController = TextEditingController();
  final monthController = TextEditingController();
  final orientationController = TextEditingController();
  List<int> doctorIdList = [];
  bool isLoading = false;
  final List orientation = [
    'landscape',
    'portrait',
  ];
  @override
  void initState() {
    super.initState();
    docIdController.text = 0.toString();
    orientationController.text = 'landscape';
    databaseHelper.initDB();
    getAllDoctorId();
    setMonth();
  }

  void setMonth() {
    final parsedDate = DateFormat('MMMM yyyy');
    final formatDate = parsedDate.format(DateTime.now());
    monthController.text = formatDate.toString();
  }

  void getAllDoctorId() async {
    int docId = int.tryParse(docIdController.text) ?? 0;
    if (docId == 0) {
      doctorIdList = await databaseHelper.getAllDoctorId();
    } else {
      doctorIdList = [docId];
    }
  }

  void generateIncentive() async {
    setState(() {
      isLoading = true;
    });
    List<IncentiveModel> incetiveDetailsList = [];
    for (int i = 0; i < doctorIdList.length; i++) {
      List<PatientModel> patientModel =
          await databaseHelper.getPatientListByDoctorIdAndMonth(
              id: doctorIdList[i], month: monthController.text);
      if (patientModel.isEmpty) {
        i++;
      } else {
        String doctorName = patientModel[0].refBy;
        List<PatientDetailsModel> patientDetailsModel = [];
        for (int j = 0; j < patientModel.length; j++) {
          patientDetailsModel.add(
            PatientDetailsModel(
              name: patientModel[j].name,
              age: patientModel[j].age,
              sex: patientModel[j].sex,
              date: patientModel[j].date,
              type: patientModel[j].type,
              remark: patientModel[j].remark,
              totalAmount: patientModel[j].totalAmount,
              paidAmount: patientModel[j].paidAmount,
              discDoc: patientModel[j].discDoc,
              discCen: patientModel[j].discCen,
              incentive: patientModel[j].incentive,
              percent: patientModel[j].percent,
            ),
          );
        }
        incetiveDetailsList.add(
          IncentiveModel(
            refBy: doctorName,
            patientDetails: patientDetailsModel,
          ),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    Navigator.push(
      context,
      MyCustomPageRoute(
        route: ShowIncentive(
          incentiveModelList: incetiveDetailsList,
          pName: pName,
          date: date,
          age: age,
          sex: sex,
          type: type,
          remark: remark,
          total: total,
          paid: paid,
          incentive: incentive,
          incentivePerc: incentivePerc,
          discountByDoc: discountByDoc,
          discountByCenter: discountByCenter,
          dName: dName,
          orientation: orientationController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    fillColor: primaryColorLite,
                    hoverColor: primaryColorLite,
                    controller: docNameController,
                    hintText: 'Select doctor',
                    readOnly: true,
                  ),
                ),
                Gap(defaultSize),
                TextButton(
                  onPressed: () {
                    doctorSelector();
                  },
                  child: const Icon(
                    Icons.search_outlined,
                    weight: 20,
                  ),
                ),
              ],
            ),
            Gap(defaultSize),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    fillColor: primaryColorLite,
                    hoverColor: primaryColorLite,
                    controller: monthController,
                    hintText: 'Select Month',
                    readOnly: true,
                  ),
                ),
                Gap(defaultSize),
                TextButton(
                  onPressed: () {
                    showMonthPicker(
                      context: context,
                      animationMilliseconds: 200,
                      firstDate: DateTime(2024),
                      initialDate: DateTime.now(),
                      lastDate: DateTime.now(),
                      backgroundColor: primaryColorDark,
                      selectedMonthBackgroundColor: btnColor,
                      selectedMonthTextColor: Colors.black,
                      currentMonthTextColor: Colors.black,
                      roundedCornersRadius: defaultBorderRadius,
                    ).then((date) {
                      if (date != null) {
                        final parsedDate = DateFormat('MMMM yyyy');
                        final formatDate = parsedDate.format(date);
                        setState(() {
                          monthController.text = formatDate.toString();
                        });
                      }
                    });
                  },
                  child: const Icon(
                    Icons.search_outlined,
                    weight: 20,
                  ),
                ),
                Gap(defaultSize),
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField(
                    dropdownColor: primaryColorLite,
                    borderRadius: BorderRadius.circular(defaultSize),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          defaultBorderRadius,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: primaryColorLite,
                      filled: true,
                    ),
                    value: orientation.first,
                    items: orientation
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        orientationController.text = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            Gap(defaultSize),
            GestureDetector(
              onTap: () {
                setState(() {
                  isLoading = true;
                });
                generateIncentive();
              },
              child: isLoading
                  ? const ContainerButton(
                      isLoading: true,
                      loadingWidget: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                      iconData: Icons.view_list_outlined,
                      btnName: 'Generate Incentive Report',
                    )
                  : ContainerButton(
                      backgroundColor: primaryColorLite,
                      iconData: Icons.view_list_outlined,
                      btnName: 'Generate Incentive Report',
                    ),
            )
          ],
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: CustomFloatingActionButton(
              onTap: () async {
                showIncentiveItem(context);
              },
              title: 'Change List Data'),
        ),
      ],
    );
  }

  void doctorSelector() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            decoration: BoxDecoration(
              color: primaryColorLite,
              borderRadius: BorderRadius.circular(
                defaultSize,
              ),
            ),
            child: Column(children: [
              Text(
                'Select Doctor',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              GestureDetector(
                onTap: () {
                  docNameController.text = 'All Doctors';
                  docIdController.text = 0.toString();
                  getAllDoctorId();
                  Navigator.pop(context);
                },
                child: Card(
                  elevation: 0,
                  color: btnColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding,
                      vertical: 5,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'All Doctors',
                                style: patientHeader,
                              ),
                              Text(
                                'Click to select all Doctors',
                                style: patientHeaderSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: databaseHelper.getDoctorList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Some error occurred!',
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'Empty Doctor List',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        );
                      }
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            docNameController.text = snapshot.data![index].name;
                            docIdController.text =
                                snapshot.data![index].id!.toString();
                            setState(() {
                              getAllDoctorId();
                            });
                            Navigator.pop(context);
                          },
                          child: Card(
                            elevation: 0,
                            color: primaryColorDark,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding,
                                vertical: 5,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data![index].name,
                                          style: patientHeader,
                                        ),
                                        Text(
                                          snapshot.data![index].address,
                                          style: patientHeaderSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    snapshot.data![index].phone,
                                    style: patientHeaderSmall,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  void showIncentiveItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 300, vertical: 100),
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              decoration: BoxDecoration(
                color: primaryColorDark,
                borderRadius: BorderRadius.circular(
                  defaultSize,
                ),
              ),
              child: Material(
                color: primaryColorDark,
                child: ListView(
                  children: [
                    Gap(defaultSize),
                    Text(
                      'Select the field to be printed on pdf',
                      style: patientHeader,
                      textAlign: TextAlign.center,
                    ),
                    Gap(defaultSize),
                     incentiveItems(
                        title: 'Age',
                        value: age,
                        onChanged: (value) {
                          setState(() {
                            age = value!;
                          });
                        },
                        context: context,
                        setState: setState),
                    Gap(defaultSize),
                     incentiveItems(
                        title: 'Sex',
                        value: sex,
                        onChanged: (value) {
                          setState(() {
                            sex = value!;
                          });
                        },
                        context: context,
                        setState: setState),
                    Gap(defaultSize),
                     incentiveItems(
                        title: 'Remark',
                        value: remark,
                        onChanged: (value) {
                          setState(() {
                            remark = value!;
                          });
                        },
                        context: context,
                        setState: setState),
                    Gap(defaultSize),
                    incentiveItems(
                        title: 'Total Amount',
                        value: total,
                        onChanged: (value) {
                          setState(() {
                            total = value!;
                          });
                        },
                        context: context,
                        setState: setState),
                    Gap(defaultSize),
                     incentiveItems(
                        title: 'Type',
                        value: type,
                        onChanged: (value) {
                          setState(() {
                            type = value!;
                          });
                        },
                        context: context,
                        setState: setState),
                    Gap(defaultSize),
                     incentiveItems(
                        title: 'Paid',
                        value: paid,
                        onChanged: (value) {
                          setState(() {
                            paid = value!;
                          });
                        },
                        context: context,
                        setState: setState),
                    Gap(defaultSize),
                     incentiveItems(
                        title: 'Incentive',
                        value: incentive,
                        onChanged: (value) {
                          setState(() {
                            incentive = value!;
                          });
                        },
                        context: context,
                        setState: setState),
                    Gap(defaultSize),
                    incentiveItems(
                        title: 'Incentive Percentage',
                        value: incentivePerc,
                        onChanged: (value) {
                          setState(() {
                            incentivePerc = value!;
                          });
                        },
                        context: context,
                        setState: setState),
                    Gap(defaultSize),
                    incentiveItems(
                        title: 'Discount by Doctor',
                        value: discountByDoc,
                        onChanged: (value) {
                          setState(() {
                            discountByDoc = value!;
                          });
                        },
                        context: context,
                        setState: setState),
                    Gap(defaultSize),
                    incentiveItems(
                      title: 'Discount by Center',
                      value: discountByCenter,
                      onChanged: (value) {
                        setState(() {
                          discountByCenter = value!;
                        });
                      },
                      context: context,
                      setState: setState,
                    ),
                    Gap(defaultSize),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Container incentiveItems(
      {required String title,
      required bool value,
      required Function onChanged,
      required BuildContext context,
      required StateSetter setState}) {
    return Container(
      height: getDeviceHeight(context: context) * 0.13,
      width: getDeviceWidth(context: context) * 0.5,
      padding: EdgeInsets.all(defaultSize),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        color: primaryColorLite,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: patientHeaderSmall,
          ),
          Checkbox(
            value: value,
            onChanged: (value) {
              setState(() {
                onChanged(value);
              });
            },
          )
        ],
      ),
    );
  }
}
