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
            Text('${weather!.current!.temperature.toString()} °C'),
            Text('${weather!.current!.windSpeed10m.toString()} km/h'),
          ] else
            const Text('No weather data'),
        ],
      ),
    );
  }
}
