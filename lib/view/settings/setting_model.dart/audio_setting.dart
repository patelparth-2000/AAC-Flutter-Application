import 'package:sqflite/sqflite.dart';

class AudioSettingModel {
  int? rowNumber; // Primary Key
  String? whatToSpeak;
  bool? speakAction;
  String? updateDate;

  AudioSettingModel({
    this.rowNumber,
    this.whatToSpeak,
    this.speakAction,
    this.updateDate,
  });

  Map<String, dynamic> toMap({bool forUpdate = false}) {
    // return {
    //   'row_number': rowNumber,
    //   'what_to_speak': whatToSpeak,
    //   'speak_action': speakAction == true ? 1 : 0,
    //   'update_date': updateDate,
    // };

    final map = {
      'row_number': rowNumber,
      'what_to_speak': whatToSpeak,
      'speak_action': speakAction == true ? 1 : 0,
      'update_date': updateDate,
    };

    if (forUpdate) {
      map.removeWhere((key, value) => value == null);
    }

    return map;
  }

  factory AudioSettingModel.fromMap(Map<String, dynamic> map) {
    return AudioSettingModel(
      rowNumber: map['row_number'],
      whatToSpeak: map['what_to_speak'],
      speakAction: map['speak_action'] == 1,
      updateDate: map['update_date'],
    );
  }
}

class AudioSettingDatabase {
  final Database db;
  AudioSettingDatabase(this.db);

  Future<int> insertAudioSetting(AudioSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String();
    return await db.insert(
      'audio_setting',
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateAudioSetting(
      int rowNumber, AudioSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String();
    Map<String, dynamic> updateFields = setting.toMap(forUpdate: true);
    updateFields.removeWhere((key, value) => value == null);
    return await db.update(
      'audio_setting',
      updateFields,
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );
  }

  Future<AudioSettingModel?> getAudioSetting(int rowNumber) async {
    final List<Map<String, dynamic>> result = await db.query(
      'audio_setting',
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );

    if (result.isNotEmpty) {
      return AudioSettingModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<AudioSettingModel>> getAllAudioSettings() async {
    final List<Map<String, dynamic>> result = await db.query('audio_setting');
    return result.map((map) => AudioSettingModel.fromMap(map)).toList();
  }
}
