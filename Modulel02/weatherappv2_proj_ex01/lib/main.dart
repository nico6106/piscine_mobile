import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

// files
import 'app_bar.dart';
import 'bottom_bar.dart';

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
  int _choice = 0;
  bool _error = false;
  bool _showSearch = false;

  late Future<GeoData> futureGeoData;

  void setCity(String city) {
    setState(() {
      local = city;
    });
  }

  void setShowSearch(bool value) {
    setState(() {
      _showSearch = value;
    });
  }

  void setChoice(String choice) async {
    setState(() {
      if (choice == 'city') {
        _choice = 1;
        _error = false;
        print('choice set');
        if (myController.text.isEmpty) {
          _showSearch = false;
        } else {
          _showSearch = true;
        }
        if (myController.text.length > 2) {
          futureGeoData = fetchGeocoding(myController.text);
          print('after geodata');
          print(futureGeoData);
        }
      } else if (choice == 'gps') {
        _choice = 2;
        _showSearch = false;

        // trying to get localisation
        _getCurrentLocation();
      } else {
        _choice = 0;
        local = '';
        _showSearch = false;
        _error = false;
      }
    });
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('position = $position');
      setState(() {
        var latitude = position.latitude;
        var longitude = position.longitude;

        local = '$latitude $longitude';
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
    // Clean up the controller when the widget is disposed.
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
              setShowSearch: setShowSearch,
            ),
          ),
          body: _showSearch
              ? const SearchBarResults()
              : TabBarView(
                  children: [
                    MyTabWidget(
                        title: 'Currently',
                        localisation: local,
                        isError: _error),
                    MyTabWidget(
                        title: 'Today', localisation: local, isError: _error),
                    MyTabWidget(
                        title: 'Weekly', localisation: local, isError: _error),
                  ],
                ),
          bottomNavigationBar: const MyBottonBarWidget(),
        ),
      ),
    );
  }
}

class MyTabWidget extends StatelessWidget {
  const MyTabWidget(
      {super.key,
      required this.title,
      required this.localisation,
      required this.isError});

  final String title;
  final String localisation;
  final bool isError;
  // final TextEditingController myController;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if ((!isError && constraints.minHeight > 40) ||
            constraints.minHeight > 60) {
          return ShowResultsWidget(
            title: title,
            localisation: localisation,
            isError: isError,
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class ShowResultsWidget extends StatelessWidget {
  const ShowResultsWidget({
    super.key,
    required this.title,
    required this.localisation,
    required this.isError,
  });

  final String title;
  final String localisation;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(
          child: Text(
            localisation,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isError ? Colors.red : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}