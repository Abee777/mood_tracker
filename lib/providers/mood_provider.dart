import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/mood.dart';
import '../data/mood_list.dart';

class MoodProvider with ChangeNotifier {
  Mood? _selectedMood;
  LatLng? _currentLocation;

  List<Mood> get moods => moodList;

  Mood? get selectedMood => _selectedMood;
  LatLng? get currentLocation => _currentLocation;

  void selectMood(Mood mood) {
    _selectedMood = mood;
    notifyListeners();
  }

  void setCurrentLocation(LatLng location) {
    _currentLocation = location;
    notifyListeners();
  }
}