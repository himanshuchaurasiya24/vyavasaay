// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DoctorModel {
  final int? id;
  final String name;
  final int age;
  final String sex;
  final String phone;
  final String address;
  final int ultrasound;
  final int pathology;
  final int ecg;
  final int xray;
  DoctorModel({
    this.id,
    required this.name,
    required this.age,
    required this.sex,
    required this.phone,
    required this.address,
    required this.ultrasound,
    required this.pathology,
    required this.ecg,
    required this.xray,
  });

  DoctorModel copyWith({
    int? id,
    String? name,
    int? age,
    String? sex,
    String? phone,
    String? address,
    int? ultrasound,
    int? pathology,
    int? ecg,
    int? xray,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      ultrasound: ultrasound ?? this.ultrasound,
      pathology: pathology ?? this.pathology,
      ecg: ecg ?? this.ecg,
      xray: xray ?? this.xray,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'age': age,
      'sex': sex,
      'phone': phone,
      'address': address,
      'ultrasound': ultrasound,
      'pathology': pathology,
      'ecg': ecg,
      'xray': xray,
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      age: map['age'] as int,
      sex: map['sex'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      ultrasound: map['ultrasound'] as int,
      pathology: map['pathology'] as int,
      ecg: map['ecg'] as int,
      xray: map['xray'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorModel.fromJson(String source) =>
      DoctorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DoctorModel(id: $id, name: $name, age: $age, sex: $sex, phone: $phone, address: $address, ultrasound: $ultrasound, pathology: $pathology, ecg: $ecg, xray: $xray)';
  }

  @override
  bool operator ==(covariant DoctorModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.age == age &&
        other.sex == sex &&
        other.phone == phone &&
        other.address == address &&
        other.ultrasound == ultrasound &&
        other.pathology == pathology &&
        other.ecg == ecg &&
        other.xray == xray;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        age.hashCode ^
        sex.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        ultrasound.hashCode ^
        pathology.hashCode ^
        ecg.hashCode ^
        xray.hashCode;
  }
}
