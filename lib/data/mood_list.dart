import 'package:flutter/material.dart';
import '../models/mood.dart';

final List<Mood> moodList = [
  Mood(name: 'Happy', icon: 'assets/icons/happy.png', color: const Color(0xFFFFD700)),
  Mood(name: 'Sad', icon: 'assets/icons/sad.png', color: const Color(0xFF1E90FF)),
  Mood(name: 'Excited', icon: 'assets/icons/excited.png', color: const Color(0xFFFF4500)),
  Mood(name: 'Anxious', icon: 'assets/icons/angry.png', color: const Color(0xFF8A2BE2)),
  // Add more moods as needed
];