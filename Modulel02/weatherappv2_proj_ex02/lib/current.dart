import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'class_def.dart';
import 'decode_location.dart';

class CurrentBody extends StatefulWidget {
  const CurrentBody({super.key, required this.coord});

  final Coord coord;

  @override
  State<CurrentBody> createState() => _CurrentBody();
}

class _CurrentBody extends State<CurrentBody> {
  DecodeCity? city;

  Future<DecodeCity> decodeCity(Coord coordinates) async {
    return await fetchCityFromCoord(coordinates);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: decodeCity(widget.coord),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Column(
            children: [
              Text(snapshot.data?.city ?? 'Unknown'),
              Text(snapshot.data?.state ?? 'Unknown'),
              Text(snapshot.data?.country ?? 'Unknown'),
              Text('oula, coord=${widget.coord.latitude}'),
            ],
          );
        }
      },
    );
  }
}

// Future<> fetchCurrentWeather(String value) async {
//   if (value.isEmpty) {
//     return List<GeoData>.empty();
//   }

//   // print('fetchGeocoding: value=$value');

//   try {
//     final response = await http.get(Uri.parse(
//         'https://geocoding-api.open-meteo.com/v1/search?name=$value&count=5&language=en&format=json'));

//     if (response.statusCode == 200) {
//       try {
//         return parseGeocoding(jsonDecode(response.body));
//       } catch (e) {
//         // return List<GeoData>.empty();
//         throw Exception('Unknown city');
//       }
//     } else {
//       throw Exception('Error with provider');
//     }
//   } catch (e) {
//     if (e is SocketException) {
//       throw Exception('Please check internet connexion');
//     } else {
//       rethrow;
//     }
//   }
// }

// https://api.open-meteo.com/v1/forecast?latitude=48.8534&longitude=2.3488&current=temperature_2m,apparent_temperature,is_day,precipitation,rain,showers,weather_code,cloud_cover,wind_speed_10m,wind_direction_10m&timezone=Europe%2FBerlin
