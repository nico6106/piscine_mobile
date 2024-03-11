import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'class_def.dart';

class ShowLocationInformationBody extends StatelessWidget {
  const ShowLocationInformationBody({super.key, required this.city});

  final DecodeCity city;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        if (city.city != null) ...[
          Text(city.city ?? 'Unknown'),
        ] else if (city.town != null) ...[
          Text(city.town ?? 'Unknown'),
        ] else if (city.village != null) ...[
          Text(city.village ?? 'Unknown'),
        ] else if (city.hamlet != null) ...[
          Text(city.hamlet ?? 'Unknown'),
        ],
        Text(city.state ?? 'Unknown'),
        Text(city.country ?? 'Unknown'),
      ],
    );
  }
}

class DecodeCity {
  final String? city;
  final String? town;
  final String? village;
  final String? hamlet;
  final String? state;
  final String? country;

  const DecodeCity({
    this.city,
    this.town,
    this.village,
    this.hamlet,
    this.state,
    this.country,
  });

  factory DecodeCity.fromJson(Map<String, dynamic> json) {
    if (json['address'] == null) {
      throw Exception('Unknown city 1');
    }
    json = json['address'];
    // print('having json');

    return DecodeCity(
      city: json['city'] as String?,
      town: json['town'] as String?,
      village: json['village'] as String?,
      hamlet: json['hamlet'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
    );
  }
}

Future<DecodeCity> fetchCityFromCoord(Coord coord) async {
  print('fetchCityFromCoord: coord=${coord.latitude}, ${coord.longitude}');
  try {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${coord.latitude}&lon=${coord.longitude}&format=json'));

    if (response.statusCode == 200) {
      try {
        print(response.body);
        return DecodeCity.fromJson(jsonDecode(response.body));
      } catch (e) {
        // print('error fetchCityFromCoord: coord(long=${coord.longitude}, lat=${coord.latitude})');
        // print('https://nominatim.openstreetmap.org/reverse?lat=${coord.latitude}&lon=${coord.longitude}&format=json');
        // print(e);
        // return List<GeoData>.empty();
        throw Exception('Unknown city');
      }
    } else {
      throw Exception('Error with provider');
    }
  } catch (e) {
    if (e is SocketException) {
      throw Exception('Please check internet connexion');
    } else {
      rethrow;
    }
  }
}
