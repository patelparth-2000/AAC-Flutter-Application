// ignore_for_file: avoid_print

import 'package:avaz_app/model/language_modal.dart' as language;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../view/settings/setting_model/account_setting_model.dart';
import '../view/settings/setting_model/audio_setting.dart';
import '../view/settings/setting_model/general_setting.dart';
import '../view/settings/setting_model/keyboard_setting.dart';
import '../view/settings/setting_model/picture_appearance_setting_model.dart';
import '../view/settings/setting_model/picture_behaviour_setting_model.dart';
import '../view/settings/setting_model/touch_setting.dart';

class DataBaseService {
  static Database? _db;
  static final DataBaseService instance = DataBaseService._constructor();

  DataBaseService._constructor();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    // createSettingTables();
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getApplicationCacheDirectory();
    final databasePath = join(databaseDirPath.path, "aac_voice.db");
    print("Database path ==> $databasePath");

    final database = await openDatabase(
      databasePath,
      version: 1,
    );

    return database;
  }

  Future<void> createSettingTables() async {
    final db = await database;

    // List of all SQL CREATE TABLE statements
    const tableCreationQueries = [
      '''
      CREATE TABLE IF NOT EXISTS account_setting (
        row_number INTEGER PRIMARY KEY AUTOINCREMENT,
        number TEXT,
        subscription_detail TEXT,
        expire_date DATE,
        delete_account INTEGER,
        upload_crash BOOLEAN,
        subscription_type TEXT,
        subscription_price TEXT,
        update_date DATE
      )
    ''',
      '''
      CREATE TABLE IF NOT EXISTS picture_appearance_setting (
        row_number INTEGER PRIMARY KEY AUTOINCREMENT,
        massage_box BOOLEAN,
        picture_massage_box BOOLEAN,
        picture_per_screen TEXT,
        picture_per_screen_count INTEGER,
        text_size TEXT,
        text_position TEXT,
        side_navigation_bar BOOLEAN,
        side_navigation_bar_position TEXT,
        side_navigation_bar_button TEXT,
        color_coding TEXT,
        update_date DATE
      )
    ''',
      '''
      CREATE TABLE IF NOT EXISTS picture_behaviour_setting (
        row_number INTEGER PRIMARY KEY AUTOINCREMENT,
        word_on_selection TEXT,
        vocabulary_home TEXT,
        auto_home_each_time BOOLEAN,
        action_to_navigation BOOLEAN,
        grammar BOOLEAN,
        grammar_picture_grid BOOLEAN,
        update_date DATE
      )
    ''',
      '''
      CREATE TABLE IF NOT EXISTS keyboard_setting (
        row_number INTEGER PRIMARY KEY AUTOINCREMENT,
        layout TEXT,
        highlight_vowels BOOLEAN,
        prediction BOOLEAN,
        prediction_with_pictures BOOLEAN,
        next_word BOOLEAN,
        current_word BOOLEAN,
        phonetic_match BOOLEAN,
        enlarge_speed TEXT,
        update_date DATE
      )
    ''',
      '''
      CREATE TABLE IF NOT EXISTS audio_setting (
        row_number INTEGER PRIMARY KEY AUTOINCREMENT,
        what_to_speak TEXT,
        speak_action BOOLEAN,
        update_date DATE
      )
    ''',
      '''
      CREATE TABLE IF NOT EXISTS general_setting (
        row_number INTEGER PRIMARY KEY AUTOINCREMENT,
        share_massage BOOLEAN,
        share_massage_type TEXT,
        password TEXT,
        is_password BOOLEAN,
        auto_clear_massage_box BOOLEAN,
        update_date DATE
      )
    ''',
      '''
      CREATE TABLE IF NOT EXISTS touch_setting (
        row_number INTEGER PRIMARY KEY AUTOINCREMENT,
        enable_touch BOOLEAN,
        hold_duration BOOLEAN,
        duration_limit TEXT,
        ignore_repeat BOOLEAN,
        ignore_limit TEXT,
        border_color TEXT,
        border_thickness TEXT,
        border_radius TEXT,
        update_date DATE
      )
    '''
    ];

    for (String query in tableCreationQueries) {
      await db.execute(query);
    }

    print("All tables created successfully!");

    // Helper function to check if a table is empty
    Future<bool> isTableEmpty(String tableName) async {
      final result =
          await db.rawQuery('SELECT COUNT(*) AS count FROM $tableName');
      final count = Sqflite.firstIntValue(result) ?? 0;
      return count == 0;
    }

    if (await isTableEmpty('account_setting')) {
      accountSettingInsert(AccountSettingModel(
          number: "+911234567890",
          subscriptionDetail: "free trial",
          expireDate: null,
          deleteAccount: 0,
          uploadCrash: true,
          subscriptionType: null,
          subscriptionPrice: null));
    }

    if (await isTableEmpty('picture_appearance_setting')) {
      pictureAppearanceSettingInsert(PictureAppearanceSettingModel(
          massageBox: true,
          pictureMassageBox: true,
          picturePerScreen: "small_(40_pictures)",
          picturePerScreenCount: 40,
          textSize: "large",
          textPosition: "above",
          sideNavigationBar: true,
          sideNavigationBarPosition: "right",
          sideNavigationBarButton:
              "go_back,home,quick,next_page,previous_page,search_words",
          colorCoding: "colour_code_background"));
    }

    if (await isTableEmpty('picture_behaviour_setting')) {
      pictureBehaviourSettingInsert(PictureBehaviourSettingModel(
          wordOnSelection: "enlarge_at_normal_speed",
          vocabularyHome: "root_screen",
          autoHomeEachTime: false,
          actionToNavigation: true,
          grammar: true,
          grammarPictureGrid: true));
    }

    if (await isTableEmpty('keyboard_setting')) {
      keyboardSettingInsert(KeyboardSettingModel(
          layout: "english_(qwe)",
          highlightVowels: false,
          prediction: true,
          predictionWithPictures: true,
          nextWord: true,
          currentWord: true,
          phoneticMatch: true,
          enlargeSpeed: "don't_enlarge"));
    }

    if (await isTableEmpty('audio_setting')) {
      audioSettingInsert(AudioSettingModel(
          whatToSpeak: "speak_everything", speakAction: true));
    }

    if (await isTableEmpty('general_setting')) {
      generalSettingInsert(GeneralSettingModel(
          shareMassage: true,
          shareMassageType: "image",
          password: null,
          isPassword: false,
          autoClearMassageBox: false));
    }

    if (await isTableEmpty('touch_setting')) {
      touchSettingInsert(TouchSettingModel(
          enableTouch: false,
          holdDuration: false,
          durationLimit: "1.0",
          ignoreRepeat: false,
          ignoreLimit: "1.0",
          borderColor: "pink",
          borderThickness: "5",
          borderRadius: "5"));
    }

    print("All tables created and default data inserted if necessary!");
  }

  Future<void> createTablesFromApiData({
    required String tableName,
    required String uniqueType,
    required String uniqueId,
    required Map<String, dynamic> apiData,
  }) async {
    final db = await database;

    // Ensure the table name is valid by wrapping it in double quotes
    final safeTableName = '"$tableName"';

    // Check if the table exists
    final tableExists = await _checkIfTableExists(db, tableName);

    if (tableExists) {
      // Get the current columns of the table
      final currentColumns = await _getTableColumns(db, tableName);

      // Get the new columns (API keys that are not in the current table)
      final newColumns =
          apiData.keys.where((key) => !currentColumns.contains(key)).toList();

      // If there are new columns, add them to the table
      if (newColumns.isNotEmpty) {
        for (String column in newColumns) {
          final alterTableQuery =
              'ALTER TABLE $safeTableName ADD COLUMN $column TEXT';
          await db.execute(alterTableQuery);
          print('Added column $column to table $safeTableName');
        }
      } else {
        print('No new columns to add.');
      }
    } else {
      // If the table doesn't exist, create it with the API keys as columns
      final columns = apiData.keys
          .map((key) =>
              '$key TEXT') // Assuming all values are TEXT (can be adjusted)
          .join(', ');

      final createTableQuery = '''
    CREATE TABLE IF NOT EXISTS $safeTableName (
      row_number INTEGER PRIMARY KEY AUTOINCREMENT,
      $columns
    )
  ''';

      // Execute the query
      await db.execute(createTableQuery);
      print('Table $safeTableName created with columns: $columns');
    }

    // Insert the data into the table
    await insertDataIntoTable(
        tableName: tableName,
        data: apiData,
        uniqueId: uniqueId,
        uniqueType: uniqueType);
  }

  // Check if the table exists in the database
  Future<bool> _checkIfTableExists(Database db, String tableName) async {
    final safeTableName = '"$tableName"';
    final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name=$safeTableName");
    return result.isNotEmpty;
  }

  Future<bool> checkIfTableExistsOrNot(String tableName) async {
    final db = await database;
    final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
    return result.isNotEmpty;
  }

  // Get the columns of an existing table
  Future<List<String>> _getTableColumns(Database db, String tableName) async {
    final safeTableName = '"$tableName"';
    final result = await db.rawQuery('PRAGMA table_info($safeTableName)');
    return result.map((row) => row['name'].toString()).toList();
  }

  // Insert API data into the table
  Future<void> insertDataIntoTable({
    required String tableName,
    required Map<String, dynamic> data,
    required String uniqueType,
    required String uniqueId,
  }) async {
    final db = await database;

    // Check if the data already exists based on the unique column
    final safeTableName = '"$tableName"';
    final existingData = await db.query(
      safeTableName,
      where: '$uniqueType = ? AND $uniqueId = ?',
      whereArgs: [data[uniqueType], data[uniqueId]],
    );

    if (existingData.isEmpty) {
      // Insert data into table if it doesn't exist
      await db.insert(safeTableName, data);
      await deleteNullData(tableName: safeTableName);
      // print('Data inserted into $tableName: $data');
    } else {
      print('Data already exists in $tableName, skipping insert.');
    }
  }

  Future<void> deleteNullData({required String tableName}) async {
    final db = await database;
    await db.execute("DELETE FROM $tableName WHERE id IS NULL");
  }

  Future<int> insertDataIntoTableManual({
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;
    final tableExists = await _checkIfTableExists(db, tableName);
    int? id;
    if (tableExists) {
      final safeTableName = '"$tableName"';
      // Get the current columns of the table
      final currentColumns = await _getTableColumns(db, tableName);

      // Get the new columns (API keys that are not in the current table)
      final newColumns =
          data.keys.where((key) => !currentColumns.contains(key)).toList();

      // If there are new columns, add them to the table
      if (newColumns.isNotEmpty) {
        for (String column in newColumns) {
          final alterTableQuery =
              'ALTER TABLE $safeTableName ADD COLUMN $column TEXT';
          await db.execute(alterTableQuery);
          print('Added column $column to table $safeTableName');
        }
      } else {
        print('No new columns to add.');
      }
      id = await db.insert("'$tableName'", data);
    } else {
      final columns = data.keys
          .map((key) =>
              '$key TEXT') // Assuming all values are TEXT (can be adjusted)
          .join(', ');

      final createTableQuery = '''
      CREATE TABLE IF NOT EXISTS $tableName (
        row_number INTEGER PRIMARY KEY AUTOINCREMENT,
        $columns
      )
    ''';
      // Execute the query
      await db.execute(createTableQuery);
      print('Table $tableName created with columns: $columns');
      id = await db.insert(tableName, data);
    }
    return id;
  }

  Future<dynamic> getCategoryTable() async {
    final db = await database;
    final result = await db.rawQuery("SELECT * FROM category_table");
    return result;
  }

  Future<int> updateCategoryTable(
      {required int rowID, required String id}) async {
    final db = await database;

    // Define the values to update
    final updatedValues = {
      'id': id, // Update only the 'id' column
    };

    // Perform the update operation
    final result = await db.update(
      'category_table', // Table name
      updatedValues, // Updated values
      where: 'row_number = ?', // Condition for updating
      whereArgs: [rowID], // Arguments for the condition
    );

    return result; // Returns the number of rows affected
  }

  Future<dynamic> getTablesData(String tableName) async {
    final db = await database;
    final tableExists = await _checkIfTableExists(db, tableName);
    if (tableExists) {
      final result = await db.rawQuery("SELECT * FROM '$tableName'");
      return result;
    }
    return [];
  }

  Future<dynamic> getTablesSubCategoryData(String tableName) async {
    try {
      final db = await database;
      final tableExists = await _checkIfTableExists(db, tableName);
      if (tableExists) {
        print("SELECT * FROM $tableName WHERE type = 'sub_categories'");
        final result = await db
            .rawQuery("SELECT * FROM $tableName WHERE type = 'sub_categories'");
        return result;
      } else {
        return [];
      }
    } catch (e) {
      debugPrint("Database query failed for table: $tableName. Error: $e");
      return [];
    }
  }

  Future<List<language.Data>> getLangData() async {
    try {
      final db = await database;
      final tableExists = await _checkIfTableExists(db, "language_data_add");
      if (tableExists) {
        final result = await db.rawQuery("SELECT * FROM language_data_add");
        print(result);
        return result.map((data) => language.Data.fromJson(data)).toList();
      } else {
        return [];
      }
    } catch (e) {
      debugPrint(
          "Database query failed for table: 'language_data_add'. Error: $e");
      return [];
    }
  }

  Future<dynamic> getFavoritesTable() async {
    final db = await database;
    final result = await db.rawQuery("SELECT * FROM favourite_table");
    return result;
  }

  Future<dynamic> deleteItem(int id, String? tableName) async {
    final db = await database;
    String tableName0 = tableName ?? "favourite_table";
    final result = await db.rawQuery('''
    UPDATE $tableName0
    SET delete_status = 1
    WHERE id = $id;
    ''');
    return result;
  }

  Future<dynamic> renameItem(int id, String name) async {
    final db = await database;
    String tableName0 = "favourite_table";
    final result = await db.rawQuery('''
    UPDATE $tableName0
    SET name = ?
    WHERE id = ?;
  ''', [name, id]);
    return result;
  }

  Future<int?> getLastAddedItemId(String tableName) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT MAX(row_number) 
    FROM $tableName 
    LIMIT 1;
  ''');

    print("datat =====> ${result.first['MAX(row_number)']}");

    // Safely parse the result as int
    return result.isNotEmpty
        ? int.tryParse(result.first['MAX(row_number)'].toString())
        : null;
  }

  //  Future<int?> getLastAddedItemId(String tableName) async {
  //   final db = await database;
  //   final result = await db.rawQuery('''
  //   SELECT row_number
  //   FROM $tableName
  //   ORDER BY id DESC
  //   LIMIT 1;
  // ''');

  //   print(result);

  //   // Safely parse the result as int
  //   return result.isNotEmpty
  //       ? int.tryParse(result.first['id'].toString())
  //       : null;
  // }

  Future<dynamic> directoryPath() async {
    final db = await database;
    final result = await db.rawQuery("SELECT * FROM directory_path");
    String path = result.first["path"].toString();
    return path;
  }

  // Account Setting
  void accountSettingInsert(AccountSettingModel accountSetting) async {
    final db = await database;
    final accountDb = AccountSettingDatabase(db);

    final newAccount = accountSetting;

    await accountDb.insertAccountSetting(newAccount);
    print("New account setting added!");
  }

  void accountSettingUpdate(AccountSettingModel accountSetting) async {
    final db = await database;
    final accountDb = AccountSettingDatabase(db);
    final updateFields = accountSetting;

    await accountDb.updateAccountSetting(1, updateFields);
    print("Account setting updated!");
  }

  Future<AccountSettingModel?> accountSettingFetch() async {
    final db = await database;
    final accountDb = AccountSettingDatabase(db);
    final account = await accountDb.getAccountSetting(1);
    // if (account != null) {
    //   print(
    //       "Account Setting: ${account.subscriptionType}, ${account.subscriptionPrice}");
    // }

    // final allAccounts = await accountDb.getAllAccountSettings();
    // for (var acc in allAccounts) {
    //   print(acc.toMap());
    // }
    return account;
  }

  // Picture Appearance Setting
  void pictureAppearanceSettingInsert(
      PictureAppearanceSettingModel pictureAppearanceSetting) async {
    final db = await database;
    final accountDb = PictureAppearanceSettingDatabase(db);
    final newPictureAppearance = pictureAppearanceSetting;
    await accountDb.insertPictureAppearanceSetting(newPictureAppearance);
    print("New Picture Appearance setting added!");
  }

  void pictureAppearanceSettingUpdate(
      PictureAppearanceSettingModel pictureAppearanceSetting) async {
    final db = await database;
    final pictureAppearanceDb = PictureAppearanceSettingDatabase(db);
    final updateFields = pictureAppearanceSetting;

    await pictureAppearanceDb.updatePictureAppearanceSetting(1, updateFields);
    print("Picture Appearance setting updated!");
  }

  Future<PictureAppearanceSettingModel?> pictureAppearanceSettingFetch() async {
    final db = await database;
    final pictureAppearanceDb = PictureAppearanceSettingDatabase(db);
    final pictureAppearance =
        await pictureAppearanceDb.getPictureAppearanceSetting(1);
    return pictureAppearance;
  }

  // Picture Behaviour Setting
  void pictureBehaviourSettingInsert(
      PictureBehaviourSettingModel pictureBehaviourSetting) async {
    final db = await database;
    final pictureBehaviourDb = PictureBehaviourSettingDatabase(db);
    final newPictureBehaviour = pictureBehaviourSetting;
    await pictureBehaviourDb.insertPictureBehaviourSetting(newPictureBehaviour);
    print("New Picture Behaviour setting added!");
  }

  void pictureBehaviourSettingUpdate(
      PictureBehaviourSettingModel pictureBehaviourSetting) async {
    final db = await database;
    final pictureBehaviourDb = PictureBehaviourSettingDatabase(db);
    final updateFields = pictureBehaviourSetting;

    await pictureBehaviourDb.updatePictureBehaviourSetting(1, updateFields);
    print("Picture Behaviour setting updated!");
  }

  Future<PictureBehaviourSettingModel?> pictureBehaviourSettingFetch() async {
    final db = await database;
    final pictureBehaviourDb = PictureBehaviourSettingDatabase(db);
    final pictureBehaviour =
        await pictureBehaviourDb.getPictureBehaviourSetting(1);
    return pictureBehaviour;
  }

  // Keyboard Setting
  void keyboardSettingInsert(KeyboardSettingModel keyboardSetting) async {
    final db = await database;
    final keyboardDb = KeyboardSettingDatabase(db);
    final newKeyboard = keyboardSetting;
    await keyboardDb.insertKeyboardSetting(newKeyboard);
    print("New Keyboard setting added!");
  }

  void keyboardSettingUpdate(KeyboardSettingModel keyboardSetting) async {
    final db = await database;
    final keyboardDb = KeyboardSettingDatabase(db);
    final updateFields = keyboardSetting;

    await keyboardDb.updateKeyboardSetting(1, updateFields);
    print("Keyboard setting updated!");
  }

  Future<KeyboardSettingModel?> keyboardSettingFetch() async {
    final db = await database;
    final keyboardDb = KeyboardSettingDatabase(db);
    final keyboard = await keyboardDb.getKeyboardSetting(1);
    return keyboard;
  }

  // Audio Setting
  void audioSettingInsert(AudioSettingModel audioSetting) async {
    final db = await database;
    final audioDb = AudioSettingDatabase(db);
    final newAudio = audioSetting;
    await audioDb.insertAudioSetting(newAudio);
    print("New Audio setting added!");
  }

  void audioSettingUpdate(AudioSettingModel audioSetting) async {
    final db = await database;
    final audioDb = AudioSettingDatabase(db);
    final updateFields = audioSetting;

    await audioDb.updateAudioSetting(1, updateFields);
    print("Audio setting updated!");
  }

  Future<AudioSettingModel?> audioSettingFetch() async {
    final db = await database;
    final audioDb = AudioSettingDatabase(db);
    final audio = await audioDb.getAudioSetting(1);
    return audio;
  }

  // General Setting
  void generalSettingInsert(GeneralSettingModel generalSetting) async {
    final db = await database;
    final generalDb = GeneralSettingDatabase(db);
    final newGeneral = generalSetting;
    await generalDb.insertGeneralSetting(newGeneral);
    print("New General setting added!");
  }

  void generalSettingUpdate(GeneralSettingModel generalSetting) async {
    final db = await database;
    final generalDb = GeneralSettingDatabase(db);
    final updateFields = generalSetting;

    await generalDb.updateGeneralSetting(1, updateFields);
    print("General setting updated!");
  }

  Future<GeneralSettingModel?> generalSettingFetch() async {
    final db = await database;
    final generalDb = GeneralSettingDatabase(db);
    final general = await generalDb.getGeneralSetting(1);
    return general;
  }

  // Touch Setting
  void touchSettingInsert(TouchSettingModel touchSetting) async {
    final db = await database;
    final touchDb = TouchSettingDatabase(db);
    final newTouch = touchSetting;
    await touchDb.insertTouchSetting(newTouch);
    print("New Touch setting added!");
  }

  void touchSettingUpdate(TouchSettingModel touchSetting) async {
    final db = await database;
    final touchDb = TouchSettingDatabase(db);
    final updateFields = touchSetting;

    await touchDb.updateTouchSetting(1, updateFields);
    print("Touch setting updated!");
  }

  Future<TouchSettingModel?> touchSettingFetch() async {
    final db = await database;
    final touchDb = TouchSettingDatabase(db);
    final touch = await touchDb.getTouchSetting(1);
    return touch;
  }
}

/* Future<bool> checkFileExists(String filePath) async {
    File file = File(filePath);
    bool fileExists = await file.exists();
    return fileExists;
  } */
