import 'dart:convert';
import 'package:flutter/services.dart'; // Required for loading assets
import 'package:practice/model/hobbies_model.dart';

class HobbiesService {
  Future<List<HobbiesModel>?> getAllHobbies() async {
    try {
      final String response =
          await rootBundle.loadString('assets/dummy_hobby.json');

      final Map<String, dynamic> responseData = json.decode(response);

      List<dynamic> hobbiesJson = responseData['gamesList'];

      List<HobbiesModel> hobbiesList = hobbiesJson.map((hobby) {
        return HobbiesModel.fromJson(hobby);
      }).toList();

      return hobbiesList;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<HobbiesModel>?> getAllHobbiesLevels() async {
    try {
      final String response =
          await rootBundle.loadString('assets/dummy_level.json');

      final Map<String, dynamic> responseData = json.decode(response);

      List<dynamic> hobbiesJson = responseData['gameslevel'];

      List<HobbiesModel> hobbiesList = hobbiesJson.map((hobby) {
        return HobbiesModel.fromJson(hobby);
      }).toList();

      return hobbiesList;
    } catch (e) {
      throw Exception(e);
    }
  }
}
