import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAppBar extends StatelessWidget {
  const MyAppBar(
      {super.key,
      required this.myController,
      required this.setCity,
      required this.setChoice,
      required this.setShowSearch});

  final TextEditingController myController;
  final Function(String) setCity;
  final Function(String) setChoice;
  final Function(bool) setShowSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: myController,
              onChanged: (value) {
                setCity(value);
                setChoice('city');
              },
              decoration: const InputDecoration(
                  // border: OutlineInputBorder(),
                  hintText: 'Localisation',
                  prefixIcon: Icon(Icons.search)),
            ),
          ),
          GestureDetector(
            onTap: () => {setChoice('gps')},
            child: const Icon(
              Icons.near_me,
              semanticLabel: 'Near me',
              size: 40.0,
            ),
          )
        ],
      ),
    );
  }
}

class SearchBarResults extends StatelessWidget {
  const SearchBarResults({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> suggestions = ['Brazil', 'Paris', 'France', 'Montélimar'];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(title: Text(suggestion));
      },
    );
  }

  // Widget buildSuggestions(BuildContext context) {
  //   List<String> suggestions = ['Brazil', 'Paris', 'France', 'Montélimar'];

  //   return ListView.builder(itemCount: suggestions.length,itemBuilder:
  //   (context, index) {
  //     final suggestion = suggestions[index];
  //     return ListTile();
  //   },);
  // }
}

class GeoData {
  final int id;
  final String city;
  final String latitude;
  final String longitude;
  final String country;
  final String block;

  const GeoData({
    required this.id,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.block,
  });

  factory GeoData.fromJson(Map<String, dynamic> json) {
    // Map<String, dynamic> results = json['results'];
    print('json: $json');
    print(json['name']);
    print(json['latitude']);
    print(json['longitude']);
    print(json['country']);
    print(json['admin1']);

    // List<dynamic> results = json['results'] as List<dynamic>;
    // Map<String, dynamic> firstResult = results.first;

    // return GeoData(
    //   id: firstResult["id"] as int,
    //   city: firstResult["city"] as String,
    //   latitude: firstResult["latitude"] as String,
    //   longitude: firstResult["longitude"] as String,
    //   country: firstResult["country"] as String,
    //   block: firstResult["block"] as String,
    // );

    return switch (json) {
      {
        'name': String city,
        'id': int id,
        'latitude': String latitude,
        'longitude': String longitude,
        'country': String country,
        'admin1': String block,
      } =>
        GeoData(
          id: id,
          city: city,
          latitude: latitude,
          longitude: longitude,
          country: country,
          block: block,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

List<GeoData> parseGeocoding(dynamic responseBody) {
  List responseResults = responseBody['results'];

  List<GeoData> allResults = [];
  GeoData tmp;
  print('start parseGeocoding2');
  print(responseResults);

  for (var elem in responseResults) {
    print('elem = $elem');
    tmp = GeoData.fromJson(elem);
    print('tmp = $tmp');
    allResults.add(tmp);
  }
  return allResults;
  // final parsed =
  //     (jsonDecode(responseResults) as List).cast<Map<String, dynamic>>();

  // return parsed.map<GeoData>((json) => GeoData.fromJson(json)).toList();
}

Future<List<GeoData>> fetchGeocoding(String value) async {
  print('Trying to get info from geocoding');
  final response = await http.get(Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$value&count=10&language=en&format=json'));

  if (response.statusCode == 200) {
    try {
      return parseGeocoding(jsonDecode(response.body));
      // return GeoData.fromJson(
      //     jsonDecode(response.body) as Map<String, dynamic>);
    } catch (e) {
      print('error = $e');
      throw Exception('Failed to parse information');
    }
  } else {
    throw Exception('Failed to load album');
  }
}
