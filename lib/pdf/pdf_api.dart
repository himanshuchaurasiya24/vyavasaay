import 'dart:io';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vyavasaay/model/incentive_model.dart';
import 'package:vyavasaay/utils/constants.dart';

class PdfApi {
  static String getDate({required String date}) {
    DateTime tempDate = DateFormat("dd MMMM yyyy").parse(date);
    final parsedDate = DateFormat('dd/MM/yyyy');
    final formatDate = parsedDate.format(tempDate);
    return formatDate;
  }

  static Future<File> generateCenteredText(String text) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Text(
              text,
              style: const pw.TextStyle(
                fontSize: 48,
              ),
            ),
          );
        },
      ),
    );
    return saveDocument(name: 'first_pdf.pdf', pdf: pdf);
  }

  static Future<File> generateIncentive({
    required List<IncentiveModel> incentiveList,
    required bool pName,
    required bool date,
    required bool age,
    required bool sex,
    required bool type,
    required bool remark,
    required bool total,
    required bool paid,
    required bool incentive,
    required bool incentivePerc,
    required bool discountByDoc,
    required bool discountByCenter,
    required bool dName,
    required String orientation,
  }) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        orientation: orientation == 'landscape'
            ? pw.PageOrientation.landscape
            : pw.PageOrientation.portrait,
        margin: const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Column(
              children: [
                ...List.generate(incentiveList.length, (index) {
                  int incentiveCount = 0;
                  return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                          color: pdfBtnColor,
                          child: pw.Text(
                            '   ${incentiveList[index].refBy}',
                            style: const pw.TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        pw.Container(
                          margin:
                              const pw.EdgeInsets.symmetric(horizontal: 0.5),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(
                              color: pdfBtnColor,
                              style: pw.BorderStyle.solid,
                              width: 1,
                            ),
                          ),
                          child: pw.Column(
                            children: [
                              pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  date
                                      ? pw.Expanded(
                                          flex: 1,
                                          child: pw.Text(
                                            textAlign: pw.TextAlign.center,
                                            'Date',
                                            style: pw.TextStyle(
                                              fontSize: 14,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : pw.SizedBox(),
                                  pName
                                      ? pw.Expanded(
                                          flex: 1,
                                          child: pw.Text(
                                            textAlign: pw.TextAlign.center,
                                            'Patient',
                                            style: pw.TextStyle(
                                              fontSize: 14,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : pw.SizedBox(),
                                  age
                                      ? pw.Expanded(
                                          flex: 1,
                                          child: pw.Text(
                                            textAlign: pw.TextAlign.center,
                                            'Age',
                                            style: pw.TextStyle(
                                              fontSize: 14,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : pw.SizedBox(),
                                  sex
                                      ? pw.Expanded(
                                          flex: 1,
                                          child: pw.Text(
                                            textAlign: pw.TextAlign.center,
                                            'Sex',
                                            style: pw.TextStyle(
                                              fontSize: 14,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : pw.SizedBox(),
                                  type
                                      ? pw.Expanded(
                                          flex: 1,
                                          child: pw.Text(
                                            textAlign: pw.TextAlign.center,
                                            'Type',
                                            style: pw.TextStyle(
                                              fontSize: 14,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : pw.SizedBox(),
                                  remark
                                      ? pw.Expanded(
                                          flex: 1,
                                          child: pw.Text(
                                            textAlign: pw.TextAlign.center,
                                            'Remark',
                                            style: pw.TextStyle(
                                              fontSize: 14,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : pw.SizedBox(),
                                  total
                                      ? pw.Expanded(
                                          flex: 1,
                                          child: pw.Text(
                                            textAlign: pw.TextAlign.center,
                                            'Total',
                                            style: pw.TextStyle(
                                              fontSize: 14,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : pw.SizedBox(),
                                  paid
                                      ? pw.Expanded(
                                          flex: 1,
                                          child: pw.Text(
                                            textAlign: pw.TextAlign.center,
                                            'Paid',
                                            style: pw.TextStyle(
                                              fontSize: 14,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : pw.SizedBox(),
                                  discountByDoc
                                      ? pw.Expanded(
                                          flex: 1,
                                          child: pw.Text(
                                            textAlign: pw.TextAlign.center,
                                            'Doctor Disc',
                                            style: pw.TextStyle(
                                              fontSize: 12,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : pw.SizedBox(),
                                  discountByCenter
                                      ? pw.Expanded(
                                          flex: 1,
                                          child: pw.Text(
                                            textAlign: pw.TextAlign.center,
                                            'Center Disc',
                                            style: pw.TextStyle(
                                              fontSize: 12,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : pw.SizedBox(),
                                  incentivePerc
                                      ? pw.Expanded(
                                          flex: 1,
                                          child: pw.Text(
                                            textAlign: pw.TextAlign.center,
                                            'Incentive %',
                                            style: pw.TextStyle(
                                              fontSize: 12,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : pw.SizedBox(),
                                  incentive
                                      ? pw.Expanded(
                                          flex: 1,
                                          child: pw.Text(
                                            textAlign: pw.TextAlign.center,
                                            'Incentive',
                                            style: pw.TextStyle(
                                              fontSize: 14,
                                              fontWeight: pw.FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      : pw.SizedBox(),
                                ],
                              ),
                              ...List.generate(
                                incentiveList[index].patientDetails.length,
                                (i) {
                                  incentiveCount = incentiveCount +
                                      incentiveList[index]
                                          .patientDetails[i]
                                          .incentive;
                                  return pw.Row(
                                    children: [
                                      date
                                          ? pw.Expanded(
                                              flex: 1,
                                              child: pw.Text(
                                                getDate(
                                                    date: incentiveList[index]
                                                        .patientDetails[i]
                                                        .date),
                                                textAlign: pw.TextAlign.center,
                                                style: const pw.TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            )
                                          : pw.SizedBox(),
                                      pName
                                          ? pw.Expanded(
                                              flex: 1,
                                              child: pw.Text(
                                                  incentiveList[index]
                                                      .patientDetails[i]
                                                      .name,
                                                  style: const pw.TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign:
                                                      pw.TextAlign.center),
                                            )
                                          : pw.SizedBox(),
                                      age
                                          ? pw.Expanded(
                                              flex: 1,
                                              child: pw.Text(
                                                  incentiveList[index]
                                                      .patientDetails[i]
                                                      .age
                                                      .toString(),
                                                  style: const pw.TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign:
                                                      pw.TextAlign.center),
                                            )
                                          : pw.SizedBox(),
                                      sex
                                          ? pw.Expanded(
                                              flex: 1,
                                              child: pw.Text(
                                                  incentiveList[index]
                                                      .patientDetails[i]
                                                      .sex,
                                                  style: const pw.TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign:
                                                      pw.TextAlign.center),
                                            )
                                          : pw.SizedBox(),
                                      type
                                          ? pw.Expanded(
                                              flex: 1,
                                              child: pw.Text(
                                                  incentiveList[index]
                                                      .patientDetails[i]
                                                      .type,
                                                  style: const pw.TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign:
                                                      pw.TextAlign.center),
                                            )
                                          : pw.SizedBox(),
                                      remark
                                          ? pw.Expanded(
                                              flex: 1,
                                              child: pw.Text(
                                                  incentiveList[index]
                                                      .patientDetails[i]
                                                      .remark,
                                                  style: const pw.TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign:
                                                      pw.TextAlign.center),
                                            )
                                          : pw.SizedBox(),
                                      total
                                          ? pw.Expanded(
                                              flex: 1,
                                              child: pw.Text(
                                                  incentiveList[index]
                                                      .patientDetails[i]
                                                      .totalAmount
                                                      .toString(),
                                                  style: const pw.TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign:
                                                      pw.TextAlign.center),
                                            )
                                          : pw.SizedBox(),
                                      paid
                                          ? pw.Expanded(
                                              flex: 1,
                                              child: pw.Text(
                                                  incentiveList[index]
                                                      .patientDetails[i]
                                                      .paidAmount
                                                      .toString(),
                                                  style: const pw.TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign:
                                                      pw.TextAlign.center),
                                            )
                                          : pw.SizedBox(),
                                      discountByDoc
                                          ? pw.Expanded(
                                              flex: 1,
                                              child: pw.Text(
                                                  incentiveList[index]
                                                      .patientDetails[i]
                                                      .discDoc
                                                      .toString(),
                                                  style: const pw.TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign:
                                                      pw.TextAlign.center),
                                            )
                                          : pw.SizedBox(),
                                      discountByCenter
                                          ? pw.Expanded(
                                              flex: 1,
                                              child: pw.Text(
                                                  incentiveList[index]
                                                      .patientDetails[i]
                                                      .discCen
                                                      .toString(),
                                                  style: const pw.TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign:
                                                      pw.TextAlign.center),
                                            )
                                          : pw.SizedBox(),
                                      incentivePerc
                                          ? pw.Expanded(
                                              flex: 1,
                                              child: pw.Text(
                                                  incentiveList[index]
                                                      .patientDetails[i]
                                                      .percent
                                                      .toString(),
                                                  style: const pw.TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign:
                                                      pw.TextAlign.center),
                                            )
                                          : pw.SizedBox(),
                                      incentive
                                          ? pw.Expanded(
                                              flex: 1,
                                              child: pw.Text(
                                                  incentiveList[index]
                                                      .patientDetails[i]
                                                      .incentive
                                                      .toString(),
                                                  style: const pw.TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                  textAlign:
                                                      pw.TextAlign.center),
                                            )
                                          : pw.SizedBox(),
                                    ],
                                  );
                                },
                              ),
                              pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.end,
                                  children: [
                                    pw.Text(
                                      'Total Incentive  $incentiveCount   ',
                                      style: pw.TextStyle(
                                        fontSize: 14,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ])
                            ],
                          ),
                        ),
                        pw.SizedBox(height: 5),
                      ]);
                })
              ],
            )
          ];
        },
      ),
    );
    return saveDocument(name: 'first_pdf.pdf', pdf: pdf);
  }

  static Future<File> saveDocument(
      {required String name, required pw.Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile({required File file}) async {
    final url = file.path;
    await OpenFilex.open(url);
  }
}
