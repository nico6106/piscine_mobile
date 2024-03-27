import 'package:flutter/material.dart';
import 'class_def.dart';
import 'decode_location.dart';
import 'get_weather.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:intl/intl.dart';
// import 'package:fl_chart_app/presentation/widgets/legend_widget.dart';

class WeeklyBody extends StatelessWidget {
  const WeeklyBody({
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
    // print('WeeklyBody');
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
                      'Weekly temperatures',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height:
                          screenHeight * 0.35 > 200 ? screenHeight * 0.35 : 200,
                      // aspectRatio: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 8, left: 5, top: 8, bottom: 0),
                        child: LineChart(mainData()),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('— min', style: TextStyle(color: Colors.blue)),
                        Text('    '),
                        Text('— max', style: TextStyle(color: Colors.red))
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.01),
            // scroll infos
            Container(
              height: screenHeight * 0.20 > 110 ? screenHeight * 0.20 : 110,
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.2),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < 7; i++) ...[
                    OneDayWeatherElemWidget(weather: weather, i: i),
                    const SizedBox(width: 10),
                  ]
                ],
              ),
            ),

            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: 7,
            //   itemBuilder: (context, index) {
            //     return Wrap(
            //       direction: Axis.horizontal,
            //       spacing: 20,
            //       children: [
            //         const SizedBox(
            //           width: 0,
            //         ),
            //         Text(
            //             '${weather!.weekly!.time![index].year.toString()}-${weather!.weekly!.time![index].month.toString()}-${weather!.weekly!.time![index].day.toString()}'),
            //         Text('${weather!.weekly!.tempMin![index].toString()}°C'),
            //         Text('${weather!.weekly!.tempMax![index].toString()}°C'),
            //         DescribeWeather(
            //             weatherCode: weather!.weekly!.weatherCode![index]),
            //       ],
            //     );
            //   },
            // )
            // Text('${weather!.current!.windSpeed10m.toString()} km/h'),
          ] else
            const Text('No weather data'),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  LineChartData mainData() {
    double minXA = weather!.weekly!.tempMin!.reduce(min);
    double maxXA = weather!.weekly!.tempMin!.reduce(max);
    double minXB = weather!.weekly!.tempMax!.reduce(min);
    double maxXB = weather!.weekly!.tempMax!.reduce(max);

    double minY = (min(minXA, minXB) - 2.0).ceilToDouble();
    double maxY = (max(maxXA, maxXB) + 2.0).ceilToDouble();
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
            reservedSize: 25,
            interval: 1,
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
      // minX: 0,
      // maxX: 6,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < 7; i++) ...[
              FlSpot(i.toDouble(), weather!.weekly!.tempMin![i]),
            ]
          ],
          color: Colors.blue,
        ),
        LineChartBarData(
          spots: [
            for (int i = 0; i < 7; i++) ...[
              FlSpot(i.toDouble(), weather!.weekly!.tempMax![i]),
            ]
          ],
          color: Colors.red,
        )
      ],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      // fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    String text = "${value.toInt().toString()}°C";
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      // fontWeight: FontWeight.bold,
      fontSize: 12,
    );

    if (weather != null &&
        weather!.weekly != null &&
        weather!.weekly!.time != null) {
      int index = value.toInt();
      if (index >= 0 && index < weather!.weekly!.time!.length) {
        DateTime date = weather!.weekly!.time![index];
        String formattedDate = DateFormat('dd/MM').format(date);
        return Text(
          formattedDate,
          style: style,
          textAlign: TextAlign.center,
        );
      }
    }
    return const Text('');

    // print('bottom=$value');
    // String text = "${value.toInt().toString()}";
    // return Text(text, style: style, textAlign: TextAlign.left);
  }
}

class DescribeWeather extends StatelessWidget {
  const DescribeWeather({
    super.key,
    required this.weatherCode,
  });

  final int weatherCode;

  @override
  Widget build(BuildContext context) {
    try {
      return Text(weatherCodes[weatherCode]!);
    } catch (e) {
      return const Text('Unknown');
    }
    // return Text('$} ');
  }
}

class OneDayWeatherElemWidget extends StatelessWidget {
  const OneDayWeatherElemWidget({
    super.key,
    required this.weather,
    required this.i,
  });

  final Weather? weather;
  final int i;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    String formattedDate =
        DateFormat('dd/MM').format(weather!.weekly!.time![i]);

    return Column(
      children: [
        Text(
          formattedDate,
          style: const TextStyle(
            color: Colors.white,
            // fontSize: 25,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),
        // Text(weatherCodes[weather!.current!.weatherCode]!,
        //     style: const TextStyle(color: Colors.white)),
        // weatherIcon[weather!.current!.weatherCode]!,
        getWeatherIcon(weather!.weekly!.weatherCode![i], screenHeight * 0.05),
        SizedBox(height: screenHeight * 0.01),
        Text(
          '${weather!.weekly!.tempMax![i].toString()}°C max',
          style: const TextStyle(
            color: Colors.red,
            // fontSize: 25,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          '${weather!.weekly!.tempMin![i].toString()}°C min',
          style: const TextStyle(
            color: Colors.blue,
            // fontSize: 25,
          ),
        ),

        // SizedBox(height: screenHeight * 0.02),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Icon(
        //       Icons.air,
        //       color: Colors.blue,
        //       size: screenHeight * 0.02,
        //     ),
        //     Text(' ${weather!.today!.windSpeed10m![i].toString()} km/h',
        //         style: const TextStyle(color: Colors.white)),
        //   ],
        // ),
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
