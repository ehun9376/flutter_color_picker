import 'dart:convert';
import 'package:color_picker/helper/in_app_puchase_center.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends ChangeNotifier {
  List<DataModel> _dataModels = [];
  List<DataModel> get dataModels => _dataModels;
  set dataModels(newValue) {
    _dataModels = newValue;
    notifyListeners();
  }

  int _time = 0;
  int get life => _time;
  set life(newValue) {
    _time = newValue;

    notifyListeners();
  }

  IAPCenter? iapCenter;

  Future getData() async {
    var url =
        Uri.parse("http://anna.college/flutter/flutter_color_picker.json");
    var response = await http.get(url);
    debugPrint(response.body.toString());
    var json = jsonDecode(
        utf8.decode(response.body.toString().codeUnits))["canBuyType"];
    _dataModels = DataModel.fromListJson(json);

    iapCenter = IAPCenter(
        kIds: _dataModels.map((e) => e.id).toList(),
        buyComplete: (id) {
          saveData(
              addLife:
                  dataModels.firstWhere((element) => element.id == id).number);
        });
  }

  Future<void> saveData({int addLife = 0}) async {
    var loadData = await readData();
    loadData += addLife;
    life = loadData;

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('time', loadData);
  }

  Future<int> readData() async {
    final prefs = await SharedPreferences.getInstance();
    var getTime = prefs.getInt('time');
    getTime ??= 3;
    return getTime;
  }
}

class DataModel {
  String title = "";
  int number = 1;
  String id = "";

  DataModel({required this.title, required this.number, required this.id});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
        title: json["title"], number: json["number"], id: json["id"]);
  }

  static List<DataModel> fromListJson(List<dynamic> jsonList) {
    return jsonList.map((e) => DataModel.fromJson(e)).toList();
  }
}
