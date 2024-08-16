import 'package:flutter/material.dart';
import 'package:practice/model/hobbies_model.dart';
import 'package:practice/services/hobbies_services.dart';

class HobbiesViewModel extends ChangeNotifier {
  final HobbiesService hobbiesService = HobbiesService();

  // List of all hobbies
  List<HobbiesModel> _hobbiesList = [];
  List<HobbiesModel> get hobbiesList => _hobbiesList;
  set hobbiesList(List<HobbiesModel> value) {
    _hobbiesList = value;
    notifyListeners();
  }

  // List of selected hobbies
  final List<HobbiesModel> _selectedHobbies = [];
  List<HobbiesModel> get selectedHobbies => _selectedHobbies;
  // Add a hobby to the selected list
  void addSelectedHobby(HobbiesModel hobby) {
    if (!_selectedHobbies.contains(hobby)) {
      _selectedHobbies.add(hobby);
      notifyListeners();
    }
  }

  // // Method to add or update a selected hobby with its level
  // void addOrUpdateSelectedHobby(HobbiesModel hobby, HobbiesModel? level) {
  //   _selectedHobbiesWithLevels[hobby] = level;
  //   notifyListeners();
  // }

  // Remove a hobby from the selected list
  // void removeSelectedHobby(HobbiesModel hobby) {
  //   if (_selectedHobbies.contains(hobby)) {
  //     _selectedHobbies.remove(hobby);
  //     notifyListeners();
  //   }
  // }

  // Loading state for hobbies
  bool _hobbiesLoading = false;
  bool get hobbiesLoading => _hobbiesLoading;
  set hobbiesLoading(bool value) {
    _hobbiesLoading = value;
    notifyListeners();
  }

  // Load hobbies
  Future loadHobbies() async {
    hobbiesLoading = true;
    await _loadHobbies();
    hobbiesLoading = false;
  }

  Future _loadHobbies() async {
    try {
      List<HobbiesModel>? result = await hobbiesService.getAllHobbies();
      hobbiesList = result!;
    } catch (e) {
      throw Exception(e);
    }
  }

  // List of all hobbies levels
  List<HobbiesModel> _hobbiesLevelList = [];
  List<HobbiesModel> get hobbiesLevelList => _hobbiesLevelList;
  set hobbiesLevelList(List<HobbiesModel> value) {
    _hobbiesLevelList = value;
    notifyListeners();
  }

  // Loading state for hobbies levels
  bool _hobbiesLevelLoading = false;
  bool get hobbiesLevelLoading => _hobbiesLevelLoading;
  set hobbiesLevelLoading(bool value) {
    _hobbiesLevelLoading = value;
    notifyListeners();
  }

  HobbiesModel? _selectedHobby;
  HobbiesModel? get selectedHobby => _selectedHobby;

  // Method to set selected hobby
  // void setSelectedHobby(HobbiesModel? hobby) {
  //   _selectedHobby = hobby;
  //   notifyListeners();
  // }

  // HobbiesModel? _selectedLevel;
  // HobbiesModel? get selectedLevel => _selectedLevel;

  // // Method to set selected level
  // void setSelectedLevel(HobbiesModel? level) {
  //   _selectedLevel = level;
  //   notifyListeners();
  // }

  // Map to track selected levels for each hobby
  final List<Map<HobbiesModel, HobbiesModel?>> _selectedHobbiesWithLevels = [];
  List<Map<HobbiesModel, HobbiesModel?>> get selectedHobbiesWithLevels =>
      _selectedHobbiesWithLevels;

  // Method to set or update the selected level for a hobby
  void setSelectedLevel(HobbiesModel? hobby, HobbiesModel? level) {
    // If hobby is null, we don't want to proceed
    if (hobby == null) return;

    // Find the index of the map with the given hobby
    int index =
        _selectedHobbiesWithLevels.indexWhere((map) => map.containsKey(hobby));

    if (index != -1) {
      // If the hobby already exists, update its level
      _selectedHobbiesWithLevels[index][hobby] = level;
    } else {
      // If the hobby doesn't exist, add a new map entry
      _selectedHobbiesWithLevels.add({hobby: level});
    }

    notifyListeners();
  }

  void clearSelectedLevel(HobbiesModel? hobby) {
    // If hobby is null, we don't want to proceed
    if (hobby == null) return;
    if (_selectedHobbies.contains(hobby)) {
      _selectedHobbies.remove(hobby);
    }

    // Find the index of the map with the given hobby
    int index =
        _selectedHobbiesWithLevels.indexWhere((map) => map.containsKey(hobby));

    if (index != -1) {
      // If the hobby exists, remove the map from the list
      _selectedHobbiesWithLevels.removeAt(index);
    }
    notifyListeners();
  }

  // Load hobbies levels
  Future loadHobbiesLevels() async {
    hobbiesLevelLoading = true;
    await _loadHobbiesLevels();
    hobbiesLevelLoading = false;
  }

  Future _loadHobbiesLevels() async {
    try {
      List<HobbiesModel>? result = await hobbiesService.getAllHobbiesLevels();
      hobbiesLevelList = result!;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Method to submit the data
  Future<void> submitSelectedData() async {
    try {
      print(_selectedHobbiesWithLevels);
    } catch (e) {
      print(e);
    }
  }
}
