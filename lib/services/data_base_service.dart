import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseService {
  static Database? _db;
  static final DataBaseService instance = DataBaseService._constructor();
  DataBaseService._constructor();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
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

  // Create table dynamically based on API data
  Future<void> createTablesFromApiData({
    required String tableName,
    required Map<String, dynamic> apiData,
  }) async {
    final db = await database;

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
              'ALTER TABLE $tableName ADD COLUMN $column TEXT';
          await db.execute(alterTableQuery);
          print('Added column $column to table $tableName');
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
      CREATE TABLE IF NOT EXISTS $tableName (
        row_number INTEGER PRIMARY KEY AUTOINCREMENT,
        $columns
      )
    ''';

      // Execute the query
      await db.execute(createTableQuery);
      print('Table $tableName created with columns: $columns');
    }

    // Insert the data into the table
    await insertDataIntoTable(tableName: tableName, data: apiData);
  }

// Check if the table exists in the database
  Future<bool> _checkIfTableExists(Database db, String tableName) async {
    final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
    return result.isNotEmpty;
  }

// Get the columns of an existing table
  Future<List<String>> _getTableColumns(Database db, String tableName) async {
    final result = await db.rawQuery('PRAGMA table_info($tableName)');
    return result.map((row) => row['name'].toString()).toList();
  }

  // Insert API data into the table
  Future<void> insertDataIntoTable({
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;

    // Insert data into table
    await db.insert(tableName, data);
    print('Data inserted into $tableName: $data');
  }
}
