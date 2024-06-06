// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PatientModel {
  int? id;
  String name;
  int age;
  String sex;
  String date;
  String type;
  String remark;
  int technician;
  int refById;
  String refBy;
  int totalAmount;
  int paidAmount;
  int discDoc;
  int discCen;
  int incentive;
  int percent;
  PatientModel({
    this.id,
    required this.name,
    required this.age,
    required this.sex,
    required this.date,
    required this.type,
    required this.remark,
    required this.technician,
    required this.refById,
    required this.refBy,
    required this.totalAmount,
    required this.paidAmount,
    required this.discDoc,
    required this.discCen,
    required this.incentive,
    required this.percent,
  });

  PatientModel copyWith({
    int? id,
    String? name,
    int? age,
    String? sex,
    String? date,
    String? type,
    String? remark,
    int? technician,
    int? refById,
    String? refBy,
    int? totalAmount,
    int? paidAmount,
    int? discDoc,
    int? discCen,
    int? incentive,
    int? percent,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      date: date ?? this.date,
      type: type ?? this.type,
      remark: remark ?? this.remark,
      technician: technician ?? this.technician,
      refById: refById ?? this.refById,
      refBy: refBy ?? this.refBy,
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
      'id': id,
      'name': name,
      'age': age,
      'sex': sex,
      'date': date,
      'type': type,
      'remark': remark,
      'technician': technician,
      'refById': refById,
      'refBy': refBy,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'discDoc': discDoc,
      'discCen': discCen,
      'incentive': incentive,
      'percent': percent,
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      age: map['age'] as int,
      sex: map['sex'] as String,
      date: map['date'] as String,
      type: map['type'] as String,
      remark: map['remark'] as String,
      technician: map['technician'] as int,
      refById: map['refById'] as int,
      refBy: map['refBy'] as String,
      totalAmount: map['totalAmount'] as int,
      paidAmount: map['paidAmount'] as int,
      discDoc: map['discDoc'] as int,
      discCen: map['discCen'] as int,
      incentive: map['incentive'] as int,
      percent: map['percent'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientModel.fromJson(String source) =>
      PatientModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PatientModel(id: $id, name: $name, age: $age, sex: $sex, date: $date, type: $type, remark: $remark, technician: $technician, refById: $refById, refBy: $refBy, totalAmount: $totalAmount, paidAmount: $paidAmount, discDoc: $discDoc, discCen: $discCen, incentive: $incentive, percent: $percent)';
  }

  @override
  bool operator ==(covariant PatientModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.age == age &&
        other.sex == sex &&
        other.date == date &&
        other.type == type &&
        other.remark == remark &&
        other.technician == technician &&
        other.refById == refById &&
        other.refBy == refBy &&
        other.totalAmount == totalAmount &&
        other.paidAmount == paidAmount &&
        other.discDoc == discDoc &&
        other.discCen == discCen &&
        other.incentive == incentive &&
        other.percent == percent;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        age.hashCode ^
        sex.hashCode ^
        date.hashCode ^
        type.hashCode ^
        remark.hashCode ^
        technician.hashCode ^
        refById.hashCode ^
        refBy.hashCode ^
        totalAmount.hashCode ^
        paidAmount.hashCode ^
        discDoc.hashCode ^
        discCen.hashCode ^
        incentive.hashCode ^
        percent.hashCode;
  }
}
