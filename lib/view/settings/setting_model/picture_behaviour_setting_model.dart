import 'package:sqflite/sqflite.dart';

class PictureBehaviourSettingModel {
  int? rowNumber; // Primary Key
  String? wordOnSelection;
  String? vocabularyHome;
  bool? autoHomeEachTime;
  bool? actionToNavigation;
  bool? grammar;
  bool? grammarPictureGrid;
  String? updateDate;

  PictureBehaviourSettingModel({
    this.rowNumber,
    this.wordOnSelection,
    this.vocabularyHome,
    this.autoHomeEachTime,
    this.actionToNavigation,
    this.grammar,
    this.grammarPictureGrid,
    this.updateDate,
  });

  // Convert model to a Map for database operations
  Map<String, dynamic> toMap({bool forUpdate = false}) {

    // return {
    //   'row_number': rowNumber,
    //   'word_on_selection': wordOnSelection,
    //   'vocabulary_home': vocabularyHome,
    //   'auto_home_each_time': autoHomeEachTime == true ? 1 : 0,
    //   'action_to_navigation': actionToNavigation == true ? 1 : 0,
    //   'grammar': grammar == true ? 1 : 0,
    //   'grammar_picture_grid': grammarPictureGrid == true ? 1 : 0,
    //   'update_date': updateDate,
    // };

    final map = {
      'row_number': rowNumber,
      'word_on_selection': wordOnSelection,
      'vocabulary_home': vocabularyHome,
      'auto_home_each_time': autoHomeEachTime == true ? 1 : 0,
      'action_to_navigation': actionToNavigation == true ? 1 : 0,
      'grammar': grammar == true ? 1 : 0,
      'grammar_picture_grid': grammarPictureGrid == true ? 1 : 0,
      'update_date': updateDate,
    };

    if (forUpdate) {
    map.removeWhere((key, value) => value == null);
    }

  return map;
  }

  // Create a model instance from a database Map
  factory PictureBehaviourSettingModel.fromMap(Map<String, dynamic> map) {
    return PictureBehaviourSettingModel(
      rowNumber: map['row_number'],
      wordOnSelection: map['word_on_selection'],
      vocabularyHome: map['vocabulary_home'],
      autoHomeEachTime: map['auto_home_each_time'] == 1,
      actionToNavigation: map['action_to_navigation'] == 1,
      grammar: map['grammar'] == 1,
      grammarPictureGrid: map['grammar_picture_grid'] == 1,
      updateDate: map['update_date'],
    );
  }
}

class PictureBehaviourSettingDatabase {
  final Database db;
  PictureBehaviourSettingDatabase(this.db);

  Future<int> insertPictureBehaviourSetting(
      PictureBehaviourSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String(); // Set update_date
    return await db.insert(
      'picture_behaviour_setting',
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updatePictureBehaviourSetting(
      int rowNumber, PictureBehaviourSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String();
    Map<String, dynamic> updateFields = setting.toMap(forUpdate: true);
    updateFields.removeWhere((key, value) => value == null);
    return await db.update(
      'picture_behaviour_setting',
      updateFields,
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );
  }

  Future<PictureBehaviourSettingModel?> getPictureBehaviourSetting(
      int rowNumber) async {
    final List<Map<String, dynamic>> result = await db.query(
      'picture_behaviour_setting',
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );

    if (result.isNotEmpty) {
      return PictureBehaviourSettingModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<PictureBehaviourSettingModel>>
      getAllPictureBehaviourSettings() async {
    final List<Map<String, dynamic>> result =
        await db.query('picture_behaviour_setting');
    return result
        .map((map) => PictureBehaviourSettingModel.fromMap(map))
        .toList();
  }
}
