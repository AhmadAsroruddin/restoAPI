import 'package:flutter/material.dart';

import 'package:restaurant_api/database/database_helper.dart';
import 'package:restaurant_api/models/favorite.dart';
import '../provider/db_provider.dart';

class DBProvider extends ChangeNotifier {
  List<Favorite> _favorite = [];
  late DatabaseHelper _dbHelper;

  List<Favorite> get favorite => _favorite;

  DBProvider() {
    _dbHelper = DatabaseHelper();
    getAllData();
  }

  void getAllData() async {
    _favorite = await _dbHelper.getFavorite();
    notifyListeners();
  }

  Future<void> addFavorite(Favorite fav) async {
    await _dbHelper.insert(fav);
    getAllData();
  }

  Future<void> delete(String id) async {
    await _dbHelper.delete(id);
    getAllData();
  }
}
