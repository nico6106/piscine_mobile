import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

// files
import 'app_bar.dart';
import 'bottom_bar.dart';
import 'body.dart';
import 'class_def.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> {
  final myController = TextEditingController();
  String local = '';
  bool _error = false;
  // double _longitude = 0;
  // double _latitude = 0;
  Coord coord = Coord(0, 0);

  late Future<List<GeoData>> futureGeoData;

  void setCity(String city) {
    setState(() {
      local = city;
    });
  }

  void setError(bool value, String explain) {
    setState(() {
      _error = value;
      if (explain != '') {
        local = explain;
      }
      // _showSearch = false;
    });
  }

  void setCoord(double longitude, double latitude) {
    setState(() {
      coord.longitude = longitude;
      coord.latitude = latitude;
      local = '$latitude $longitude';
    });
  }

  void setChoice(String choice) async {
    if (choice == 'city') {
      setState(() {
        _error = false;
      });

      if (myController.text.length > 2 && local == 'oula') {
        try {
          futureGeoData = fetchGeocoding(myController.text);
        } catch (e) {
          print('Error to get futureGeoData from fetchGeocoding');
        }
      }
    } else if (choice == 'gps') {
      // trying to get localisation
      _getCurrentLocation();
    } else {
      setState(() {
        local = '';
        _error = false;
      });
    }
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('position = $position');
      setState(() {
        coord.latitude = position.latitude;
        coord.longitude = position.longitude;

        local = '${position.latitude} ${position.longitude}';
        _error = false;
      });
      return position;
    } catch (e) {
      print('Error getting current location: $e');
      setState(() {
        local =
            'Geolocation is not available, please enable it in your App settings';
        _error = true;
      });
      return null;
    }
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: MyAppBar(
              myController: myController,
              setCity: setCity,
              setChoice: setChoice,
              setError: setError,
              setCoord: setCoord,
            ),
          ),
          body: TabBarView(
            children: [
              MyTabWidget(
                  title: 'Currently',
                  localisation: local,
                  isError: _error,
                  coord: coord),
              MyTabWidget(
                  title: 'Today',
                  localisation: local,
                  isError: _error,
                  coord: coord),
              MyTabWidget(
                  title: 'Weekly',
                  localisation: local,
                  isError: _error,
                  coord: coord),
            ],
          ),
          bottomNavigationBar: const MyBottonBarWidget(),
        ),
      ),
    );
  }
}
