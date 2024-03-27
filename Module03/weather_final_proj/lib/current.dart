import 'package:flutter/material.dart';
import 'class_def.dart';
import 'decode_location.dart';
import 'get_weather.dart';

class CurrentBody extends StatelessWidget {
  const CurrentBody({
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
    // print('CurrentBody');
    final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    if (coord.latitude == 0) {
      return const Text('Please select a location');
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: screenHeight * 0.05),
          if (city != null) ...[
            ShowLocationInformationBody(city: city!),
          ] else
            const Text('No location data'),
          SizedBox(height: screenHeight * 0.08),
          if (weather != null) ...[
            Text(
              '${weather!.current!.temperature.toString()} °C',
              style: const TextStyle(
                color: Colors.orange,
                // fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            SizedBox(height: screenHeight * 0.08),
            Text(weatherCodes[weather!.current!.weatherCode]!,
                style: const TextStyle(color: Colors.white)),
            // weatherIcon[weather!.current!.weatherCode]!,
            getWeatherIcon(weather!.current!.weatherCode!, screenHeight * 0.12),
            SizedBox(height: screenHeight * 0.08),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.air,
                  color: Colors.blue,
                ),
                Text('${weather!.current!.windSpeed10m.toString()} km/h',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),

            // SizedBox(height: screenHeight * 0.2),
          ] else
            const Text('No weather data'),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
