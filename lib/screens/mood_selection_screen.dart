import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/mood.dart';
import '../providers/mood_provider.dart';
import 'mood_display_screen.dart';
import '../widgets/note_dialog.dart';

class MoodSelectionScreen extends StatefulWidget {
  @override
  _MoodSelectionScreenState createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      markers.add(Marker(
        markerId: MarkerId('currentLocation'),
        position: currentPosition!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);
    final List<Mood> moods = moodProvider.moods;

    return Scaffold(
      appBar: AppBar(
        title: Text('How are you feeling?'),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            child: currentPosition == null
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: currentPosition!,
                      zoom: 15,
                    ),
                    markers: markers,
                  ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: moods.length,
              itemBuilder: (context, index) {
                final mood = moods[index];
                return GestureDetector(
                  onTap: () async {
                    String? note = await showDialog<String>(
                      context: context,
                      builder: (context) => NoteDialog(),
                    );

                    final updatedMood = Mood(
                      name: mood.name,
                      icon: mood.icon,
                      color: mood.color,
                      note: note,
                    );
                    Provider.of<MoodProvider>(context, listen: false).selectMood(updatedMood);
                    
                    // Update marker on the map
                    setState(() {
                      markers.clear();
                      markers.add(Marker(
                        markerId: MarkerId('currentMood'),
                        position: currentPosition!,
                        icon: BitmapDescriptor.defaultMarkerWithHue(_getHueFromColor(mood.color)),
                      ));
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MoodDisplayScreen()),
                    );
                  },
                  child: Card(
                    color: mood.color.withOpacity(0.2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(mood.icon, height: 50),
                        SizedBox(height: 8),
                        Text(mood.name, style: TextStyle(color: mood.color)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  double _getHueFromColor(Color color) {
    HSLColor hslColor = HSLColor.fromColor(color);
    return hslColor.hue;
  }
}