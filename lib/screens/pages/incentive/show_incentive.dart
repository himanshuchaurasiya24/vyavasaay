import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:vyavasaay/model/incentive_model.dart';
import 'package:vyavasaay/pdf/pdf_api.dart';
import 'package:vyavasaay/utils/constants.dart';
import 'package:vyavasaay/widgets/custom_column.dart';
import 'package:vyavasaay/widgets/custom_row.dart';

class ShowIncentive extends StatefulWidget {
  const ShowIncentive(
      {super.key,
      required this.incentiveModelList,
      required this.pName,
      required this.date,
      required this.age,
      required this.sex,
      required this.type,
      required this.remark,
      required this.total,
      required this.paid,
      required this.incentive,
      required this.incentivePerc,
      required this.discountByDoc,
      required this.discountByCenter,
      required this.dName,
      required this.orientation});
  final List<IncentiveModel> incentiveModelList;
  final bool pName;
  final bool date;
  final bool age;
  final bool sex;
  final bool type;
  final bool remark;
  final bool total;
  final bool paid;
  final bool incentive;
  final bool incentivePerc;
  final bool discountByDoc;
  final bool discountByCenter;
  final bool dName;
  final String orientation;
  @override
  State<ShowIncentive> createState() => _ShowIncentiveState();
}

String getDate({required String date}) {
  DateTime tempDate = DateFormat("dd MMMM yyyy").parse(date);
  final parsedDate = DateFormat('dd/MM/yyyy');
  final formatDate = parsedDate.format(tempDate);
  return formatDate;
}

bool isLoading = false;
class _ShowIncentiveState extends State<ShowIncentive> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          final pdfFile = await PdfApi.generateIncentive(
            incentiveList: widget.incentiveModelList,
            pName: widget.pName,
            date: widget.date,
            age: widget.age,
            sex: widget.sex,
            type: widget.type,
            remark: widget.remark,
            total: widget.total,
            paid: widget.paid,
            incentive: widget.incentive,
            incentivePerc: widget.incentivePerc,
            discountByDoc: widget.discountByDoc,
            discountByCenter: widget.discountByCenter,
            dName: widget.dName,
            orientation: widget.orientation,
          );
          setState(() {
            isLoading = false;
          });
          PdfApi.openFile(path: pdfFile.path);
        },
        label:isLoading?const CircularProgressIndicator.adaptive(): Text(
          'Generate PDF',
          style: patientChildrenHeading.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: widget.incentiveModelList.isEmpty
          ? Center(
              child: Text(
                'No data to display',
                style: patientChildrenHeading,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: List.generate(
                    widget.incentiveModelList.length,
                    (index) {
                      List<PatientDetailsModel> patientDetails =
                          widget.incentiveModelList[index].patientDetails;
                      int incentiveCount = 0;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            color: btnColor,
                            child: Text(
                              '   ${widget.incentiveModelList[index].refBy}',
                              style: patientChildrenHeading,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: btnColor,
                              style: BorderStyle.solid,
                              width: 2,
                            )),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CustomColumn(
                                        isVisible: widget.date,
                                        columnName: 'Date'),
                                    CustomColumn(
                                        isVisible: widget.pName,
                                        columnName: 'Patient'),
                                    CustomColumn(
                                        isVisible: widget.age,
                                        columnName: 'Age'),
                                    CustomColumn(
                                        isVisible: widget.sex,
                                        columnName: 'Sex'),
                                    CustomColumn(
                                        isVisible: widget.type,
                                        columnName: 'Type'),
                                    CustomColumn(
                                        isVisible: widget.remark,
                                        columnName: 'Remark'),
                                    CustomColumn(
                                        isVisible: widget.total,
                                        columnName: 'Total'),
                                    CustomColumn(
                                        isVisible: widget.paid,
                                        columnName: 'Paid'),
                                    CustomColumn(
                                        isVisible: widget.discountByDoc,
                                        columnName: 'Doctor Disc'),
                                    CustomColumn(
                                        isVisible: widget.discountByCenter,
                                        columnName: 'Center Disc'),
                                    CustomColumn(
                                        isVisible: widget.incentivePerc,
                                        columnName: 'Incentive %'),
                                    CustomColumn(
                                        isVisible: widget.incentive,
                                        columnName: 'Incentive'),
                                  ],
                                ),
                                Column(
                                  children: List.generate(patientDetails.length,
                                      (index) {
                                    incentiveCount = incentiveCount +
                                        patientDetails[index].incentive;
                                    return Row(
                                      children: [
                                        CustomRow(
                                          isVisible: widget.date,
                                          title: getDate(
                                              date: patientDetails[index].date),
                                        ),
                                        CustomRow(
                                          isVisible: widget.pName,
                                          title: patientDetails[index].name,
                                        ),
                                        CustomRow(
                                          isVisible: widget.age,
                                          title: patientDetails[index]
                                              .age
                                              .toString(),
                                        ),
                                        CustomRow(
                                          isVisible: widget.sex,
                                          title: patientDetails[index].sex,
                                        ),
                                        CustomRow(
                                          isVisible: widget.type,
                                          title: patientDetails[index].type,
                                        ),
                                        CustomRow(
                                          isVisible: widget.remark,
                                          title: patientDetails[index].remark,
                                        ),
                                        CustomRow(
                                          isVisible: widget.total,
                                          title: patientDetails[index]
                                              .totalAmount
                                              .toString(),
                                        ),
                                        CustomRow(
                                          isVisible: widget.paid,
                                          title: patientDetails[index]
                                              .paidAmount
                                              .toString(),
                                        ),
                                        CustomRow(
                                          isVisible: widget.discountByDoc,
                                          title: patientDetails[index]
                                              .discDoc
                                              .toString(),
                                        ),
                                        CustomRow(
                                          isVisible: widget.discountByCenter,
                                          title: patientDetails[index]
                                              .discCen
                                              .toString(),
                                        ),
                                        CustomRow(
                                          isVisible: widget.incentivePerc,
                                          title: patientDetails[index]
                                              .percent
                                              .toString(),
                                        ),
                                        CustomRow(
                                          isVisible: widget.incentive,
                                          title: patientDetails[index]
                                              .incentive
                                              .toString(),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Total Incentive   ',
                                        style: patientChildrenHeading),
                                    Text(
                                      '$incentiveCount   ',
                                      style: patientChildrenHeading,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Gap(5),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
