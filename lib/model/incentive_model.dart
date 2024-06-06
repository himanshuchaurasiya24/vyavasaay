// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class IncentiveModel {
  String refBy;
  List<PatientDetailsModel> patientDetails;
  IncentiveModel({
    required this.refBy,
    required this.patientDetails,
  });

  IncentiveModel copyWith({
    String? refBy,
    List<PatientDetailsModel>? patientDetails,
  }) {
    return IncentiveModel(
      refBy: refBy ?? this.refBy,
      patientDetails: patientDetails ?? this.patientDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'refBy': refBy,
      'patientDetails': patientDetails.map((x) => x.toMap()).toList(),
    };
  }

  factory IncentiveModel.fromMap(Map<String, dynamic> map) {
    return IncentiveModel(
      refBy: map['refBy'] as String,
      patientDetails: List<PatientDetailsModel>.from(
        (map['patientDetails'] as List<int>).map<PatientDetailsModel>(
          (x) => PatientDetailsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory IncentiveModel.fromJson(String source) =>
      IncentiveModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'IncentiveModel(refBy: $refBy, patientDetails: $patientDetails)';

  @override
  bool operator ==(covariant IncentiveModel other) {
    if (identical(this, other)) return true;

    return other.refBy == refBy &&
        listEquals(other.patientDetails, patientDetails);
  }

  @override
  int get hashCode => refBy.hashCode ^ patientDetails.hashCode;
}

class PatientDetailsModel {
  String name;
  int age;
  String sex;
  String date;
  String type;
  String remark;
  int totalAmount;
  int paidAmount;
  int discDoc;
  int discCen;
  int incentive;
  int percent;
  PatientDetailsModel({
    required this.name,
    required this.age,
    required this.sex,
    required this.date,
    required this.type,
    required this.remark,
    required this.totalAmount,
    required this.paidAmount,
    required this.discDoc,
    required this.discCen,
    required this.incentive,
    required this.percent,
  });

  PatientDetailsModel copyWith({
    String? name,
    int? age,
    String? sex,
    String? date,
    String? type,
    String? remark,
    int? totalAmount,
    int? paidAmount,
    int? discDoc,
    int? discCen,
    int? incentive,
    int? percent,
  }) {
    return PatientDetailsModel(
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      date: date ?? this.date,
      type: type ?? this.type,
      remark: remark ?? this.remark,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      discDoc: discDoc ?? this.discDoc,
      discCen: discCen ?? this.discCen,
      incentive: incentive ?? this.incentive,
      percent: percent ?? this.percent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'age': age,
      'sex': sex,
      'date': date,
      'type': type,
      'remark': remark,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'discDoc': discDoc,
      'discCen': discCen,
      'incentive': incentive,
      'percent': percent,
    };
  }

  factory PatientDetailsModel.fromMap(Map<String, dynamic> map) {
    return PatientDetailsModel(
      name: map['name'] as String,
      age: map['age'] as int,
      sex: map['sex'] as String,
      date: map['date'] as String,
      type: map['type'] as String,
      remark: map['remark'] as String,
      totalAmount: map['totalAmount'] as int,
      paidAmount: map['paidAmount'] as int,
      discDoc: map['discDoc'] as int,
      discCen: map['discCen'] as int,
      incentive: map['incentive'] as int,
      percent: map['percent'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientDetailsModel.fromJson(String source) =>
      PatientDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PatientDetailsModel(name: $name, age: $age, sex: $sex, date: $date, type: $type, remark: $remark, totalAmount: $totalAmount, paidAmount: $paidAmount, discDoc: $discDoc, discCen: $discCen, incentive: $incentive, percent: $percent)';
  }

  @override
  bool operator ==(covariant PatientDetailsModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.age == age &&
        other.sex == sex &&
        other.date == date &&
        other.type == type &&
        other.remark == remark &&
        other.totalAmount == totalAmount &&
        other.paidAmount == paidAmount &&
        other.discDoc == discDoc &&
        other.discCen == discCen &&
        other.incentive == incentive &&
        other.percent == percent;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        age.hashCode ^
        sex.hashCode ^
        date.hashCode ^
        type.hashCode ^
        remark.hashCode ^
        totalAmount.hashCode ^
        paidAmount.hashCode ^
        discDoc.hashCode ^
        discCen.hashCode ^
        incentive.hashCode ^
        percent.hashCode;
  }
}
