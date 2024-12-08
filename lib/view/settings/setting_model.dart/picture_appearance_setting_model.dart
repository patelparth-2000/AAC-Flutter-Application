import 'package:sqflite/sqflite.dart';

class PictureAppearanceSettingModel {
  int? rowNumber; // Primary Key
  bool? massageBox;
  bool? pictureMassageBox;
  String? picturePerScreen;
  int? picturePerScreenCount;
  String? textSize;
  String? textPosition;
  bool? sideNavigationBar;
  String? sideNavigationBarPosition;
  String? sideNavigationBarButton;
  String? colorCoding;
  String? updateDate;

  PictureAppearanceSettingModel({
    this.rowNumber,
    this.massageBox,
    this.pictureMassageBox,
    this.picturePerScreen,
    this.picturePerScreenCount,
    this.textSize,
    this.textPosition,
    this.sideNavigationBar,
    this.sideNavigationBarPosition,
    this.sideNavigationBarButton,
    this.colorCoding,
    this.updateDate,
  });

  // Convert model to a Map for database operations
  Map<String, dynamic> toMap({bool forUpdate = false}) {
    // return {
    //   'row_number': rowNumber,
    //   'massage_box': massageBox == true ? 1 : 0,
    //   'picture_massage_box': pictureMassageBox == true ? 1 : 0,
    //   'picture_per_screen': picturePerScreen,
    //   'picture_per_screen_count': picturePerScreenCount,
    //   'text_size': textSize,
    //   'text_position': textPosition,
    //   'side_navigation_bar': sideNavigationBar == true ? 1 : 0,
    //   'side_navigation_bar_position': sideNavigationBarPosition,
    //   'side_navigation_bar_button': sideNavigationBarButton,
    //   'color_coding': colorCoding,
    //   'update_date': updateDate,
    // };

    final map = {
      'row_number': rowNumber,
      'massage_box': massageBox == true ? 1 : 0,
      'picture_massage_box': pictureMassageBox == true ? 1 : 0,
      'picture_per_screen': picturePerScreen,
      'picture_per_screen_count': picturePerScreenCount,
      'text_size': textSize,
      'text_position': textPosition,
      'side_navigation_bar': sideNavigationBar == true ? 1 : 0,
      'side_navigation_bar_position': sideNavigationBarPosition,
      'side_navigation_bar_button': sideNavigationBarButton,
      'color_coding': colorCoding,
      'update_date': updateDate,
    };

    if (forUpdate) {
      map.removeWhere((key, value) => value == null);
    }

    return map;
  }

  // Create a model instance from a database Map
  factory PictureAppearanceSettingModel.fromMap(Map<String, dynamic> map) {
    return PictureAppearanceSettingModel(
      rowNumber: map['row_number'],
      massageBox: map['massage_box'] == 1,
      pictureMassageBox: map['picture_massage_box'] == 1,
      picturePerScreen: map['picture_per_screen'],
      picturePerScreenCount: map['picture_per_screen_count'],
      textSize: map['text_size'],
      textPosition: map['text_position'],
      sideNavigationBar: map['side_navigation_bar'] == 1,
      sideNavigationBarPosition: map['side_navigation_bar_position'],
      sideNavigationBarButton: map['side_navigation_bar_button'],
      colorCoding: map['color_coding'],
      updateDate: map['update_date'],
    );
  }
}

class PictureAppearanceSettingDatabase {
  final Database db;
  PictureAppearanceSettingDatabase(this.db);

  /// Insert new data into the `picture_appearance_setting` table
  Future<int> insertPictureAppearanceSetting(
      PictureAppearanceSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String(); // Set update_date
    return await db.insert(
      'picture_appearance_setting',
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if exists
    );
  }

  Future<int> updatePictureAppearanceSetting(
      int rowNumber, PictureAppearanceSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String();
    Map<String, dynamic> updateFields = setting.toMap(forUpdate: true);

    updateFields.removeWhere((key, value) => value == null);
    return await db.update(
      'picture_appearance_setting',
      updateFields,
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );
  }

  /// Fetch data by `row_number`
  Future<PictureAppearanceSettingModel?> getPictureAppearanceSetting(
      int rowNumber) async {
    final List<Map<String, dynamic>> result = await db.query(
      'picture_appearance_setting',
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );

    if (result.isNotEmpty) {
      return PictureAppearanceSettingModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<PictureAppearanceSettingModel>>
      getAllPictureAppearanceSettings() async {
    final List<Map<String, dynamic>> result =
        await db.query('picture_appearance_setting');
    return result
        .map((map) => PictureAppearanceSettingModel.fromMap(map))
        .toList();
  }
}
