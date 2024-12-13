import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/mood_provider.dart';

class MoodDisplayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);
    final selectedMood = moodProvider.selectedMood;
    final currentLocation = moodProvider.currentLocation;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Mood'),
        backgroundColor: selectedMood?.color,
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation!,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('currentMood'),
                  position: currentLocation,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    HSLColor.fromColor(selectedMood!.color).hue,
                  ),
                ),
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(selectedMood.icon, height: 100),
                  SizedBox(height: 16),
                  Text(
                    'You are feeling ${selectedMood.name}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: selectedMood.color),
                  ),
                  SizedBox(height: 16),
                  if (selectedMood.note != null && selectedMood.note!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Note: ${selectedMood.note}',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}