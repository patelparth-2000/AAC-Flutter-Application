import 'package:sqflite/sqflite.dart';

class KeyboardSettingModel {
  int? rowNumber; // Primary Key
  String? layout;
  bool? highlightVowels;
  bool? prediction;
  bool? predictionWithPictures;
  bool? nextWord;
  bool? currentWord;
  bool? phoneticMatch;
  String? enlargeSpeed;
  String? updateDate;

  KeyboardSettingModel({
    this.rowNumber,
    this.layout,
    this.highlightVowels,
    this.prediction,
    this.predictionWithPictures,
    this.nextWord,
    this.currentWord,
    this.phoneticMatch,
    this.enlargeSpeed,
    this.updateDate,
  });

  Map<String, dynamic> toMap({bool forUpdate = false}) {
    // return {
    //   'row_number': rowNumber,
    //   'layout': layout,
    //   'highlight_vowels': highlightVowels == true ? 1 : 0,
    //   'prediction': prediction == true ? 1 : 0,
    //   'prediction_with_pictures': predictionWithPictures == true ? 1 : 0,
    //   'next_word': nextWord == true ? 1 : 0,
    //   'current_word': currentWord == true ? 1 : 0,
    //   'phonetic_match': phoneticMatch == true ? 1 : 0,
    //   'enlarge_speed': enlargeSpeed,
    //   'update_date': updateDate,
    // };

    final map = {
      'row_number': rowNumber,
      'layout': layout,
      'highlight_vowels': highlightVowels == true ? 1 : 0,
      'prediction': prediction == true ? 1 : 0,
      'prediction_with_pictures': predictionWithPictures == true ? 1 : 0,
      'next_word': nextWord == true ? 1 : 0,
      'current_word': currentWord == true ? 1 : 0,
      'phonetic_match': phoneticMatch == true ? 1 : 0,
      'enlarge_speed': enlargeSpeed,
      'update_date': updateDate,
    };

    if (forUpdate) {
    map.removeWhere((key, value) => value == null);
  }

  return map;
  }

  factory KeyboardSettingModel.fromMap(Map<String, dynamic> map) {
    return KeyboardSettingModel(
      rowNumber: map['row_number'],
      layout: map['layout'],
      highlightVowels: map['highlight_vowels'] == 1,
      prediction: map['prediction'] == 1,
      predictionWithPictures: map['prediction_with_pictures'] == 1,
      nextWord: map['next_word'] == 1,
      currentWord: map['current_word'] == 1,
      phoneticMatch: map['phonetic_match'] == 1,
      enlargeSpeed: map['enlarge_speed'],
      updateDate: map['update_date'],
    );
  }
}

class KeyboardSettingDatabase {
  final Database db;
  KeyboardSettingDatabase(this.db);

  Future<int> insertKeyboardSetting(KeyboardSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String();
    return await db.insert(
      'keyboard_setting',
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateKeyboardSetting(int rowNumber, KeyboardSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String();
    Map<String, dynamic> updateFields = setting.toMap(forUpdate: true);
    updateFields.removeWhere((key, value) => value == null);
    return await db.update(
      'keyboard_setting',
      updateFields,
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );
  }

  Future<KeyboardSettingModel?> getKeyboardSetting(int rowNumber) async {
    final List<Map<String, dynamic>> result = await db.query(
      'keyboard_setting',
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );

    if (result.isNotEmpty) {
      return KeyboardSettingModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<KeyboardSettingModel>> getAllKeyboardSettings() async {
    final List<Map<String, dynamic>> result = await db.query('keyboard_setting');
    return result.map((map) => KeyboardSettingModel.fromMap(map)).toList();
  }
}
