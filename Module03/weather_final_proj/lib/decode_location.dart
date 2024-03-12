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
    String cityName = '';
    String country = '';

    //city
    if (city.city != null) {
      cityName = '${city.city}';
    } else if (city.town != null) {
      cityName = '${city.town}';
    } else if (city.village != null) {
      cityName = '${city.village}';
    } else if (city.hamlet != null) {
      cityName = '${city.hamlet}';
    }
    // state and country
    if (city.state != null && city.country != null) {
      country = '${city.state}, ${city.country}';
    } else if (city.country != null) {
      country = '${city.country}';
    } else {
      country = 'Unknown';
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          cityName,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Text(
          country,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
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
      throw Exception('Unknown city');
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
  // print('fetchCityFromCoord: coord=${coord.latitude}, ${coord.longitude}');
  try {
    final response = await http.get(Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?lat=${coord.latitude}&lon=${coord.longitude}&format=json'));

    if (response.statusCode == 200) {
      try {
        // print(response.body);
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
      throw Exception(
          'The service connexion is lost, please check your internet connection or try again later');
    } else {
      rethrow;
    }
  }
}
