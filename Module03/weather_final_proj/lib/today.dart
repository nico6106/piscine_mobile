import 'package:flutter/material.dart';
import 'class_def.dart';
import 'decode_location.dart';
import 'get_weather.dart';
import 'package:fl_chart/fl_chart.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;
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
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Today temperatures',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height:
                          screenHeight * 0.35 > 200 ? screenHeight * 0.35 : 200,
                      // aspectRatio: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 8, left: 5, top: 8, bottom: 5),
                        child: LineChart(mainData()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //space
            SizedBox(height: screenHeight * 0.02),
            // scroll infos
            Container(
              height: screenHeight * 0.22 > 110 ? screenHeight * 0.22 : 110,
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.2),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < 24; i++) ...[
                    SingleTodayElemWidget(weather: weather, i: i),
                  ]
                ],
              ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       for (int i = 0; i < 24; i++) ...[
              //         SingleTodayElemWidget(weather: weather, i: i),
              //       ]
              //     ],
              //   ),
              // ),
            )
          ] else
            const Text('No weather data'),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text = "${value.toInt().toString()}°C";
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text = "${value.toInt().toString()}:00";
    if (text == '23:00') {
      text = '';
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    double minY = weather!.today!.temperature![0];
    double maxY = weather!.today!.temperature![0];
    for (int i = 1; i < 24; i++) {
      if (minY > weather!.today!.temperature![i]) {
        minY = weather!.today!.temperature![i];
      }
      if (maxY < weather!.today!.temperature![i]) {
        maxY = weather!.today!.temperature![i];
      }
    }
    minY = (minY - 2.0).ceilToDouble();
    maxY = (maxY + 2.0).ceilToDouble();
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        // horizontalInterval: 3,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.blueGrey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.blueGrey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            // interval: 3,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 34,
          ),
        ),
      ),
      minX: 0,
      maxX: 23,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < 24; i++) ...[
              FlSpot(i.toDouble(), weather!.today!.temperature![i]),
            ]
          ],
        )
      ],
    );
  }
}

class SingleTodayElemWidget extends StatelessWidget {
  const SingleTodayElemWidget({
    super.key,
    required this.weather,
    required this.i,
  });

  final Weather? weather;
  final int i;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Text(
          '${weather!.today!.time![i].hour.toString()}:00',
          style: const TextStyle(
            color: Colors.white,
            // fontSize: 25,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        // Text(weatherCodes[weather!.current!.weatherCode]!,
        //     style: const TextStyle(color: Colors.white)),
        // weatherIcon[weather!.current!.weatherCode]!,
        getWeatherIcon(weather!.today!.weatherCode![i], screenHeight * 0.05),
        Text(
          '${weather!.today!.temperature![i].toString()}°C',
          style: const TextStyle(
            color: Colors.orange,
            // fontSize: 25,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.air,
              color: Colors.blue,
              size: screenHeight * 0.02,
            ),
            Text(' ${weather!.today!.windSpeed10m![i].toString()} km/h',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ],
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
