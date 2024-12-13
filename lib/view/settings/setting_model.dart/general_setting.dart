import 'package:sqflite/sqflite.dart';

class GeneralSettingModel {
  int? rowNumber; // Primary Key
  bool? shareMassage;
  String? shareMassageType;
  String? password;
  bool? isPassword;
  bool? autoClearMassageBox;
  String? updateDate;

  GeneralSettingModel({
    this.rowNumber,
    this.shareMassage,
    this.shareMassageType,
    this.password,
    this.isPassword,
    this.autoClearMassageBox,
    this.updateDate,
  });

  Map<String, dynamic> toMap({bool forUpdate = false}) {
    // return {
    //   'row_number': rowNumber,
    //   'share_massage': shareMassage == true ? 1 : 0,
    //   'share_massage_type': shareMassageType,
    //   'password': password,
    //   'is_password': isPassword == true ? 1 : 0,
    //   'auto_clear_massage_box': autoClearMassageBox == true ? 1 : 0,
    //   'update_date': updateDate,
    // };

    
    final map = {
     'row_number': rowNumber,
      'share_massage': shareMassage == true ? 1 : 0,
      'share_massage_type': shareMassageType,
      'password': password,
      'is_password': isPassword == true ? 1 : 0,
      'auto_clear_massage_box': autoClearMassageBox == true ? 1 : 0,
      'update_date': updateDate,
    };

    if (forUpdate) {
    map.removeWhere((key, value) => value == null);
    }

  return map;
  }

  factory GeneralSettingModel.fromMap(Map<String, dynamic> map) {
    return GeneralSettingModel(
      rowNumber: map['row_number'],
      shareMassage: map['share_massage'] == 1,
      shareMassageType: map['share_massage_type'],
      password: map['password'],
      isPassword: map['is_password'] == 1,
      autoClearMassageBox: map['auto_clear_massage_box'] == 1,
      updateDate: map['update_date'],
    );
  }
}

class GeneralSettingDatabase {
  final Database db;

  GeneralSettingDatabase(this.db);

  Future<int> insertGeneralSetting(GeneralSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String();
    return await db.insert(
      'general_setting',
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateGeneralSetting(
      int rowNumber, GeneralSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String();
    Map<String, dynamic> updateFields = setting.toMap(forUpdate: true);
    updateFields.removeWhere((key, value) => value == null);
    return await db.update(
      'general_setting',
      updateFields,
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );
  }

  Future<GeneralSettingModel?> getGeneralSetting(int rowNumber) async {
    final List<Map<String, dynamic>> result = await db.query(
      'general_setting',
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );

    if (result.isNotEmpty) {
      return GeneralSettingModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<GeneralSettingModel>> getAllGeneralSettings() async {
    final List<Map<String, dynamic>> result = await db.query('general_setting');
    return result.map((map) => GeneralSettingModel.fromMap(map)).toList();
  }
}
