import 'dart:developer';

import 'package:italian_happiness_index/dbHelper/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    return db.collection(USER_COLLECTION);
  }
}