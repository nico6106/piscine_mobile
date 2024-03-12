import 'package:flutter/material.dart';
import 'class_def.dart';
import 'decode_location.dart';
import 'get_weather.dart';

class TodayBody extends StatelessWidget {
  const TodayBody({
    super.key,
    required this.coord,
    this.city,
    this.weather,
  });

  final Coord coord;
  final DecodeCity? city;
  final Weather? weather;

  @override
  Widget build(BuildContext context) {
    // print('TodayBody');
    if (coord.latitude == 0) {
      return const Text('Please select a location');
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          if (city != null) ...[
            ShowLocationInformationBody(city: city!),
          ] else
            const Text('No location data'),
          if (weather != null) ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 24,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        '${weather!.today!.time![index].hour.toString()}:${weather!.today!.time![index].minute.toString()}0'),
                    Text('${weather!.today!.temperature![index].toString()}°C'),
                    Text(
                        '${weather!.today!.windSpeed10m![index].toString()} km/h'),
                  ],
                );
              },
            )
            // Text('${weather!.current!.windSpeed10m.toString()} km/h'),
          ] else
            const Text('No weather data'),
        ],
      ),
    );
  }
}



// class CurrentBody extends StatefulWidget {
//   const CurrentBody({super.key, required this.coord});

//   final Coord coord;

//   @override
//   State<CurrentBody> createState() => _CurrentBody();
// }

// class _CurrentBody extends State<CurrentBody> {

//   @override
//   Widget build(BuildContext context) {
//     if (widget.coord.latitude == 0) {
//       return const Text('Please select a location');
//     }
//     return Column(
//       children: [
//         if (city !=)
//         ShowLocationInformationBody(city: city),

        //           //show weather info
        //           Text('${weather.temperature.toString()} °C'),
        //           Text('${weather.windSpeed10m.toString()} km/h'),

        // FutureBuilder(
        //   future: Future.wait([
        //     fetchCityFromCoord(widget.coord),
        //     getCurrWeather(widget.coord),
        //   ]),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const CircularProgressIndicator();
        //     } else if (snapshot.hasError) {
        //       return Text('Error: ${snapshot.error}');
        //     } else {
        //       DecodeCity city = snapshot.data![0] as DecodeCity;
        //       CurrentWeather weather = snapshot.data![1] as CurrentWeather;
        //       return Column(
        //         children: [
        //           //show location infos
        //           ShowLocationInformationBody(city: city),

        //           //show weather info
        //           Text('${weather.temperature.toString()} °C'),
        //           Text('${weather.windSpeed10m.toString()} km/h'),
        //         ],
        //       );
        //     }
        //   },
        // ),
//       ],
//     );
//   }
// }

// class CurrentWeather {
//   final double? temperature;
//   final int? weatherCode;
//   final int? cloudCover;
//   final double? windSpeed10m;

//   const CurrentWeather({
//     this.temperature,
//     this.weatherCode,
//     this.cloudCover,
//     this.windSpeed10m,
//   });

//   factory CurrentWeather.fromJson(Map<String, dynamic> json) {
//     if (json['current'] == null) {
//       throw Exception('Unknown city');
//     }
//     json = json['current'];

//     return CurrentWeather(
//       temperature: json['temperature_2m'] as double?,
//       weatherCode: json['weather_code'] as int?,
//       cloudCover: json['cloud_cover'] as int?,
//       windSpeed10m: json['wind_speed_10m'] as double?,
//     );
//   }
// }

// Future<CurrentWeather> fetchCurrentWeather(Coord coord) async {
//   print('fetchCurrentWeather: coord=${coord.latitude}, ${coord.longitude}');
//   try {
//     final response = await http.get(Uri.parse(
//         'https://api.open-meteo.com/v1/forecast?latitude=${coord.latitude}&longitude=${coord.longitude}&current=temperature_2m,is_day,weather_code,cloud_cover,wind_speed_10m'));

//     if (response.statusCode == 200) {
//       try {
//         print(response.body);
//         return CurrentWeather.fromJson(jsonDecode(response.body));
//       } catch (e) {
//         print(e);
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
