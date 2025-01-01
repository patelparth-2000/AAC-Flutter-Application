import 'package:sqflite/sqflite.dart';

class AccountSettingModel {
  int? rowNumber; // Primary Key
  String? number;
  String? subscriptionDetail;
  String? expireDate;
  int? deleteAccount;
  bool? uploadCrash;
  String? subscriptionType;
  String? subscriptionPrice;
  String? updateDate;

  AccountSettingModel({
    this.rowNumber,
    this.number,
    this.subscriptionDetail,
    this.expireDate,
    this.deleteAccount,
    this.uploadCrash,
    this.subscriptionType,
    this.subscriptionPrice,
    this.updateDate,
  });

  // Convert model to a Map for database operations
  Map<String, dynamic> toMap({bool forUpdate = false}) {
    // return {
    //   'row_number': rowNumber,
    //   'number': number,
    //   'subscription_detail': subscriptionDetail,
    //   'expire_date': expireDate,
    //   'delete_account': deleteAccount,
    //   'upload_crash': uploadCrash == true ? 1 : 0,
    //   'subscription_type': subscriptionType,
    //   'subscription_price': subscriptionPrice,
    //   'update_date': updateDate,
    // };

    final map = {
      'row_number': rowNumber,
      'number': number,
      'subscription_detail': subscriptionDetail,
      'expire_date': expireDate,
      'delete_account': deleteAccount,
      'upload_crash': uploadCrash == true ? 1 : 0,
      'subscription_type': subscriptionType,
      'subscription_price': subscriptionPrice,
      'update_date': updateDate,
    };

    if (forUpdate) {
      map.removeWhere((key, value) => value == null);
    }

    return map;
  }

  // Create a model instance from a database Map
  factory AccountSettingModel.fromMap(Map<String, dynamic> map) {
    return AccountSettingModel(
      rowNumber: map['row_number'],
      number: map['number'],
      subscriptionDetail: map['subscription_detail'],
      expireDate: map['expire_date'],
      deleteAccount: map['delete_account'],
      uploadCrash: map['upload_crash'] == 1,
      subscriptionType: map['subscription_type'],
      subscriptionPrice: map['subscription_price'],
      updateDate: map['update_date'],
    );
  }
}

class AccountSettingDatabase {
  final Database db;
  AccountSettingDatabase(this.db);

  /// Insert new data into the `account_setting` table
  Future<int> insertAccountSetting(AccountSettingModel accountSetting) async {
    accountSetting.updateDate =
        DateTime.now().toIso8601String(); // Set update_date
    return await db.insert(
      'account_setting',
      accountSetting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if exists
    );
  }

  Future<int> updateAccountSetting(
      int rowNumber, AccountSettingModel setting) async {
    setting.updateDate = DateTime.now().toIso8601String();
    Map<String, dynamic> updateFields = setting.toMap(forUpdate: true);

    updateFields.removeWhere((key, value) => value == null);
    return await db.update(
      'account_setting',
      updateFields,
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );
  }

  /// Fetch data by `row_number`
  Future<AccountSettingModel?> getAccountSetting(int rowNumber) async {
    final List<Map<String, dynamic>> result = await db.query(
      'account_setting',
      where: 'row_number = ?',
      whereArgs: [rowNumber],
    );

    if (result.isNotEmpty) {
      return AccountSettingModel.fromMap(result.first);
    }
    return null;
  }

  Future<List<AccountSettingModel>> getAllAccountSettings() async {
    final List<Map<String, dynamic>> result = await db.query('account_setting');
    return result.map((map) => AccountSettingModel.fromMap(map)).toList();
  }
}
