import 'package:sqflite/sqflite.dart';

class TouchSettingModel {
  int? rowNumber; // Primary Key
  bool? enableTouch;
  String? updateDate;

  TouchSettingModel({
    this.rowNumber,
    this.enableTouch,
    this.updateDate,
  });

  Map<String, dynamic> toMap({bool forUpdate = false}) {
    // return {
    //   'row_number': rowNumber,
    //   'enable_touch': enableTouch == true ? 1 : 0,
    //   'update_date': updateDate,
    // };

    final map = {
      'row_number': rowNumber,
      'enable_touch': enableTouch == true ? 1 : 0,
      'update_date': updateDate,
    };

    if (forUpdate) {
    map.removeWhere((key, value) => value == null);
  }

  return map;
  }

  factory TouchSettingModel.fromMap(Map<String, dynamic> map) {
    return TouchSettingModel(
      rowNumber: map['row_number'],
      enableTouch: map['enable_touch'] == 1,
      updateDate: map['update_date'],
    );
  }
}

class TouchSettingDatabase {
  final Database db;
  TouchSettingDatabase(this.db);

  Future<int> insertTouchSetting(TouchSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String();
    return await db.insert(
      'touch_setting',
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateTouchSetting(int rowNumber, TouchSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String();
    Map<String, dynamic> updateFields = setting.toMap(forUpdate: true);
    updateFields.removeWhere((key, value) => value == null);
    return await db.update(
      'touch_setting',
      updateFields,
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );
  }

  Future<TouchSettingModel?> getTouchSetting(int rowNumber) async {
    final List<Map<String, dynamic>> result = await db.query(
      'touch_setting',
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );

    if (result.isNotEmpty) {
      return TouchSettingModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<TouchSettingModel>> getAllTouchSettings() async {
    final List<Map<String, dynamic>> result = await db.query('touch_setting');
    return result.map((map) => TouchSettingModel.fromMap(map)).toList();
  }
}
