import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as pw;

Color primaryColorDark = const Color.fromARGB(255, 226, 226, 227);
Color primaryColorLite = const Color.fromARGB(237, 245, 246, 247);
Color btnColor = const Color.fromRGBO(255, 114, 94, 1);
Color iconTextColor = const Color(0xffFdc4cb);
pw.PdfColor pdfBtnColor = const pw.PdfColor.fromInt(0xffFF725E);

double defaultSize = 20;
double defaultPadding = 20;
double defaultBorderRadius = 20;
double titleLargeTextSize = 50;
Color blackTile = Colors.black.withOpacity(0.7);
TextStyle column = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
);
TextStyle appbar = const TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
);
TextStyle patientHeader = const TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
);
TextStyle patientHeaderSmall = const TextStyle(
  fontSize: 20,
);
TextStyle patientChildrenHeading = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);
TextStyle pdfPatientChildrenHeading = const TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);
double getDeviceHeight({required BuildContext context}) {
  return MediaQuery.of(context).size.height;
}

double getDeviceWidth({required BuildContext context}) {
  return MediaQuery.of(context).size.width;
}
