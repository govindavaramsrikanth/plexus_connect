import 'package:flutter/material.dart';
import 'package:plexus_connect/plexus_connect.dart';

void main() {
  runApp(const PlexusApp());
}

/// Entry widget of the app
class PlexusApp extends StatelessWidget {
  const PlexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plexus Animation Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PlexusHomeScreen(),
    );
  }
}

/// The home screen that displays the animated Plexus widget
class PlexusHomeScreen extends StatelessWidget {
  const PlexusHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set background color if needed
      // backgroundColor: Colors.black,
      body: const PlexusAnimation(
        pointCount: 30, // Number of animated points
        maxDistance: 150, // Maximum distance for line connections
        animationSpeed: 0.03, // Wave animation speed
        allowTouchInteraction: true, // Enable user touch interaction
        pointColor: Colors.redAccent, // Color of each point
        lineStartColor: Colors.green, // Gradient start color for lines
        lineEndColor: Colors.purple, // Gradient end color for lines
      ),
    );
  }
}
