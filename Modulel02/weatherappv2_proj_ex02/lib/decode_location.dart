import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'class_def.dart';

class DecodeCity {
  // final double? latitude;
  // final double? longitude;
  final String? city;
  final String? state;
  final String? country;

  const DecodeCity({
    // this.latitude,
    // this.longitude,
    this.city,
    this.state,
    this.country,
  });

  factory DecodeCity.fromJson(Map<String, dynamic> json) {
    if (json['address'] == null) {
      throw Exception('Unknown city 1');
    }
    json = json['address'];
    print('having json');

    return DecodeCity(
      // latitude: double.parse(json['lat']) as double?,
      // longitude: double.parse(json['lon']) as double?,
      city: json['city'] as String?,
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
        print(e);
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
