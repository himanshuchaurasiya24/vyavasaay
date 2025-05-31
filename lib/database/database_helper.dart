import 'dart:io';

import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vyavasaay/model/doctor_model.dart';
import 'package:vyavasaay/model/login_history_model.dart';
import 'package:vyavasaay/model/patient_model.dart';
import 'package:vyavasaay/model/user_model.dart';

Database? _database;

class DatabaseHelper {
  final databaseName = 'vyavasaay.db';
  String userTable = 'userTable';
  String doctorTable = 'doctorTable';
  String patientTable = 'patientTable';
  String loginHistoryTable = 'loginHistory';
  String loginHistoryQuery = '''
CREATE TABLE IF NOT EXISTS loginHistory(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  personId INTEGER,
  name TEXT,
  loginTime TEXT,
  type TEXT,
  logoutTime TEXT
)
''';
  String userQuery = '''CREATE TABLE IF NOT EXISTS userTable(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE,
    accountType TEXT,
    phoneNumber TEXT,
    password TEXT
  )''';

  String doctorQuery = '''
CREATE TABLE IF NOT EXISTS doctorTable(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  age INTEGER,
  sex TEXT,
  phone TEXT,
  address TEXT,
  ultrasound INTEGER,
  pathology INTEGER,
  ecg INTEGER,
  xray INTEGER
)''';
  String patientQuery = '''
CREATE TABLE IF NOT EXISTS patientTable(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  age INTEGER,
  sex TEXT,
  date TEXT,
  type TEXT,
  remark TEXT,
  technician INTEGER,
  totalAmount INTEGER,
  paidAmount INTEGER,
  discDoc INTEGER,
  discCen INTEGER,
  incentive INTEGER,
  percent INTEGER,
  refById INTEGER,
  refBy TEXT
)
''';

  Future<Database> initDB() async {
    DatabaseFactory databaseFactoryy;
    String path = '';
    if (!kIsWeb && Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactoryy = databaseFactoryFfi;
      final Directory directoryy = await getApplicationSupportDirectory();
      await databaseFactoryy.setDatabasesPath(directoryy.path);
      path = join(
        await databaseFactoryy.getDatabasesPath(),
        databaseName,
      );
    } else {
      databaseFactoryy = databaseFactory;
      path = join(
        await databaseFactoryy.getDatabasesPath(),
        databaseName,
      );
    }

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(doctorQuery);
        await db.execute(userQuery);
        await db.execute(patientQuery);
        await db.execute(loginHistoryQuery);
      },
    );
    return _database!;
  }

  // Incentive Generation;
  Future<List<int>> getAllDoctorId() async {
    List<int> idList = [];
    final db = await initDB();
    final res = await db.query(
      doctorTable,
    );
    final model = res.map((e) => DoctorModel.fromMap(e)).toList();
    for (int i = 0; i < model.length; i++) {
      idList.add(model[i].id!);
    }
    return idList;
  }

  // Login history
  Future<int> updateStatusOfLogin({required LoginHistoryModel model}) async {
    final db = await initDB();
    final res = await db.update(
      loginHistoryTable,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return res;
  }

  Future<LoginHistoryModel> getLoginInfo({required int personId}) async {
    final db = await initDB();
    final res = await db.query(loginHistoryTable,
        where: 'personId LIKE ?', whereArgs: [personId], orderBy: 'id DESC');
    return res.map((e) => LoginHistoryModel.fromMap(e)).toList().first;
  }

  Future<List<LoginHistoryModel>> getAllLoginHistory() async {
    final db = await initDB();
    final res = await db.query(loginHistoryTable, orderBy: 'id DESC');
    return res.map((e) => LoginHistoryModel.fromMap(e)).toList();
  }

  Future<int> addToLoginHistory({required LoginHistoryModel model}) async {
    final db = await initDB();
    final res = await db.insert(loginHistoryTable, model.toMap());
    return res;
  }

  Future<List<LoginHistoryModel>> searchLoginHistoryByName(
      {required String name}) async {
    final db = await initDB();
    final res = await db.query(
      loginHistoryTable,
      where: 'name LIKE ? OR type LIKE ?',
      whereArgs: ['%$name%', '%$name%'],
      orderBy: 'id DESC',
    );
    return res.map((e) => LoginHistoryModel.fromMap(e)).toList();
  }

  Future<List<LoginHistoryModel>> searchLoginHistoryById(
      {required int personId}) async {
    final db = await initDB();
    final res = await db.query(
      loginHistoryTable,
      where: 'personId Like ?',
      whereArgs: [personId],
      orderBy: 'id DESC',
    );
    return res.map((e) => LoginHistoryModel.fromMap(e)).toList();
  }

  //Patient
  Future<List<PatientModel>> getPatientListByDoctorIdAndMonth(
      {required int id, required String month}) async {
    final db = await initDB();
    var res = await db.rawQuery(
        "SELECT * FROM patientTable WHERE refById LIKE ? AND date LIKE ? ORDER BY name ASC",
        ['%$id', '%$month']);
    return res.map((e) {
      return PatientModel.fromMap(e);
    }).toList();
  }

  Future<List<PatientModel>> getPatientListofTechnician(
      {required int technicianId}) async {
    final db = await initDB();
    final List<Map<String, Object?>> res = await db.query(
      patientTable,
      where: 'technician = ?',
      whereArgs: [technicianId],
      orderBy: 'id DESC',
    );
    return res.map((e) {
      return PatientModel.fromMap(e);
    }).toList();
  }

  Future<List<PatientModel>> getPatientListByTechnicianIdAndType(
      {required int id, required String type}) async {
    final db = await initDB();
    var res = await db.rawQuery(
        "SELECT * FROM patientTable WHERE technician LIKE ? AND type LIKE ? ORDER BY name ASC",
        ['%$id%', '%$type%']);
    return res.map((e) {
      return PatientModel.fromMap(e);
    }).toList();
  }

  Future<List<PatientModel>> getPatientListByTechnicianIdAndMonth(
      {required int id, required String month}) async {
    final db = await initDB();
    var res = await db.rawQuery(
        "SELECT * FROM patientTable WHERE technician LIKE ? AND date LIKE ? ORDER BY name ASC",
        ['%$id%', '%$month%']);
    return res.map((e) {
      return PatientModel.fromMap(e);
    }).toList();
  }

  Future<List<PatientModel>> getPatientListByTechnicianIdMonthAndType(
      {required int id, required String month, required String type}) async {
    final db = await initDB();
    var res = await db.rawQuery(
        "SELECT * FROM patientTable WHERE technician LIKE ? AND date LIKE ? AND type LIKE ? ORDER BY name ASC",
        ['%$id%', '%$month%', '%$type%']);
    return res.map((e) {
      return PatientModel.fromMap(e);
    }).toList();
  }

  Future<List<PatientModel>> getAllPatientList() async {
    final db = await initDB();
    final List<Map<String, Object?>> res = await db.query(
      patientTable,
      orderBy: 'id DESC',
    );
    return res.map((e) {
      return PatientModel.fromMap(e);
    }).toList();
  }

  Future<List<PatientModel>> getAllPatientListByMonth(
      {required String month}) async {
    final db = await initDB();
    var res = await db.rawQuery(
        "SELECT * FROM patientTable WHERE date LIKE ? ORDER BY name ASC",
        ['%$month%']);
    return res.map((e) {
      return PatientModel.fromMap(e);
    }).toList();
  }

  Future<List<PatientModel>> getAllPatientListByType(
      {required String type}) async {
    final db = await initDB();
    var res = await db.rawQuery(
        "SELECT * FROM patientTable WHERE type LIKE ? ORDER BY name ASC",
        ['%$type%']);
    return res.map((e) {
      return PatientModel.fromMap(e);
    }).toList();
  }

  Future<List<PatientModel>> getAllPatientListByTypeAndMonth(
      {required String type, required String month}) async {
    final db = await initDB();
    var res = await db.rawQuery(
        "SELECT * FROM patientTable WHERE type LIKE ? AND date LIKE ? ORDER BY name ASC",
        ['%$type%', '%$month%']);
    return res.map((e) {
      return PatientModel.fromMap(e);
    }).toList();
  }

  Future<int> addPatient({required PatientModel model}) async {
    final db = await initDB();
    final res = await db.insert(
      patientTable,
      model.toMap(),
    );
    return res;
  }

// add doctor name in ref by to enable search in patient histoy page
  Future<List<PatientModel>> searchPatient({required String data}) async {
    final db = await initDB();
    final List<Map<String, Object?>> result = await db.query(
      patientTable,
      where:
          'name LIKE ? OR type LIKE ? OR refBy LIKE ? OR refById LIKE ? OR technician LIKE ? OR date LIKE ?',
      whereArgs: [
        '%$data%',
        '%$data%',
        '%$data%',
        '%$data%',
        '%$data%',
        '%$data%',
      ],
      orderBy: 'id DESC',
    );
    return result.map((e) {
      return PatientModel.fromMap(e);
    }).toList();
  }

  Future<int> updatePatient({required PatientModel model}) async {
    final db = await initDB();
    return await db.update(
      patientTable,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<int> deletePatient({required int id}) async {
    final db = await initDB();
    final res = await db.delete(patientTable, where: 'id = ?', whereArgs: [id]);
    return res;
  }

  // doctor
  Future<List<DoctorModel>> getDoctorList() async {
    final db = await initDB();
    final List<Map<String, Object?>> res =
        await db.query(doctorTable, orderBy: 'name ASC');
    return res.map((e) => DoctorModel.fromMap(e)).toList();
  }

  Future<int> addDoctor({required DoctorModel model}) async {
    final db = await initDB();
    final res = await db.insert(doctorTable, model.toMap());

    return res;
  }

  Future<int> updateDoctor({required DoctorModel model}) async {
    final db = await initDB();
    return await db.update(
      doctorTable,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<int> deleteDoctor({required int id}) async {
    final db = await initDB();

    final res = await db.delete(doctorTable, where: 'id = ?', whereArgs: [id]);
    await db.delete(patientTable, where: 'refById = ?', whereArgs: [id]);

    return res;
  }

  Future<DoctorModel> searchDoctorById({required int id}) async {
    final db = await initDB();
    final res = await db.query(
      doctorTable,
      where: 'id = ?',
      whereArgs: [id],
      orderBy: 'name DESC',
    );
    return res.map((e) => DoctorModel.fromMap(e)).toList().first;
  }

  Future<List<DoctorModel>> searchDoctor({required String data}) async {
    final db = await initDB();
    final List<Map<String, Object?>> result = await db.query(doctorTable,
        where: 'name LIKE ? OR address LIKE ?',
        whereArgs: ['%$data%', '%$data%'],
        orderBy: 'name ASC');
    return result.map((e) {
      return DoctorModel.fromMap(e);
    }).toList();
  }

// User
  Future<int> deleteAccount({required int userId}) async {
    final db = await initDB();
    final res =
        await db.delete(userTable, where: 'id = ?', whereArgs: [userId]);
    await db.delete(patientTable, where: 'technician = ?', whereArgs: [userId]);
    return res;
  }

  Future<String> getAccountName({required int id}) async {
    final db = await initDB();
    final res = await db.query(userTable,
        where: 'id = ?', whereArgs: [id], orderBy: 'id ASC');
    if (res.isEmpty) {
      return 'null';
    }
    return res.map((e) => UserModel.fromMap(e)).toList().first.name;
  }

  Future<List<UserModel>> getAllAdminAccount() async {
    final db = await initDB();
    final res = await db
        .query(userTable, where: 'accountType = ?', whereArgs: ['Admin']);
    return res.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<List<UserModel>> getAllTechnicianAccount() async {
    final db = await initDB();
    final res = await db
        .query(userTable, where: 'accountType = ?', whereArgs: ['Technician']);
    return res.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<int> getAdminAccountLength() async {
    final db = await initDB();
    final res = await db
        .query(userTable, where: 'accountType = ?', whereArgs: ['Admin']);
    return res.map((e) => UserModel.fromMap(e)).toList().length;
  }

  Future<int> createAccount({required UserModel model}) async {
    final db = await initDB();
    final res = await db.insert(
      userTable,
      model.toMap(),
    );
    return res;
  }

  Future<int> updateAccount({required UserModel model}) async {
    final db = await initDB();
    return await db.update(
      userTable,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  Future<bool> authAccount({
    required String name,
    required String password,
    required String loginType,
  }) async {
    final db = await initDB();
    var res = await db.query(
      userTable,
      where: 'name = ? AND password = ? AND accountType = ?',
      whereArgs: [name, password, loginType],
      orderBy: 'id DESC',
    );
    if (res.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserModel?> getAccount({required String name}) async {
    final db = await initDB();
    var res = await db.query(
      userTable,
      where: 'name = ?',
      whereArgs: [name],
      orderBy: 'name ASC',
    );
    return res.isNotEmpty ? UserModel.fromMap(res.first) : null;
  }

  Future<List<UserModel>> getAllAccount() async {
    final db = await initDB();
    final List<Map<String, Object?>> result = await db.query(
      userTable,
      orderBy: 'id DESC',
    );
    return result.map((e) => UserModel.fromMap(e)).toList();
  }

// Delete Everything
  Future<void> deleteEverything() async {
    final db = await initDB();
    await db.rawDelete('DELETE FROM $userTable');
    await db.rawDelete('DELETE FROM $doctorTable');
    await db.rawDelete('DELETE FROM $patientTable');
    await db.rawDelete('DELETE FROM $loginHistoryTable').then((value) async {
      await db.delete(
        "SQLITE_SEQUENCE",
        where: "NAME = ?",
        whereArgs: [userTable],
      );
      await db.delete(
        "SQLITE_SEQUENCE",
        where: "NAME = ?",
        whereArgs: [doctorTable],
      );
      await db.delete(
        "SQLITE_SEQUENCE",
        where: "NAME = ?",
        whereArgs: [patientTable],
      );
      await db.delete(
        "SQLITE_SEQUENCE",
        where: "NAME = ?",
        whereArgs: [loginHistoryTable],
      ).then((value) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.clear();
      });
    });
  }
}
