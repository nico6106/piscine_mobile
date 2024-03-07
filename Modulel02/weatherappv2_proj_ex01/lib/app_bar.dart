import 'package:flutter/material.dart';
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
    required this.data,
  });

  final List<GeoData> data;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final suggestion = data[index];
        return ListTile(
          title: Row(
            children: [
              Text(
                suggestion.city,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(', '),
              if (suggestion.admin1 != null) ...[
                Text(suggestion.admin1!),
                const Text(', '),
              ],
              Text(suggestion.country)
            ],
          ),
        );
      },
    );
  }
}

class GeoData {
  final int id;
  final String city;
  final double latitude;
  final double longitude;
  final String country;
  final String? admin1;

  const GeoData({
    required this.id,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.country,
    this.admin1,
  });

  factory GeoData.fromJson(Map<String, dynamic> json) {
    return GeoData(
      id: json['id'] as int,
      city: json['name'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      country: json['country'] as String,
      admin1: json['admin1'] as String?,
    );
  }
}

List<GeoData> parseGeocoding(dynamic responseBody) {
  List responseResults = responseBody['results'];
  List<GeoData> allResults = [];
  GeoData tmp;

  for (var elem in responseResults) {
    tmp = GeoData.fromJson(elem);
    allResults.add(tmp);
  }
  return allResults;
}

Future<List<GeoData>> fetchGeocoding(String value) async {
  final response = await http.get(Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$value&count=10&language=en&format=json'));

  if (response.statusCode == 200) {
    try {
      return parseGeocoding(jsonDecode(response.body));
    } catch (e) {
      // print('error = $e');
      throw Exception('Failed to parse information');
    }
  } else {
    throw Exception('Failed to load album');
  }
}
