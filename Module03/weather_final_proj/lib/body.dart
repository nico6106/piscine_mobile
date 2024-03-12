import 'package:flutter/material.dart';
import 'decode_location.dart';
import 'today.dart';
import 'weekly.dart';
import 'current.dart';
import 'error.dart';
import 'class_def.dart';
import 'get_weather.dart';

class MyTabWidget extends StatelessWidget {
  const MyTabWidget({
    super.key,
    required this.title,
    required this.localisation,
    required this.coord,
    required this.isError,
    this.city,
    this.weather,
  });

  final String title;
  final String localisation;
  final Coord coord;
  final bool isError;
  final DecodeCity? city;
  final Weather? weather;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if ((!isError && constraints.minHeight > 40) ||
            constraints.minHeight > 80) {
          return ShowResultsWidget(
            title: title,
            localisation: localisation,
            isError: isError,
            coord: coord,
            city: city,
            weather: weather,
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class ShowResultsWidget extends StatelessWidget {
  const ShowResultsWidget({
    super.key,
    required this.title,
    required this.localisation,
    required this.coord,
    required this.isError,
    this.city,
    this.weather,
  });

  final String title;
  final String localisation;
  final Coord coord;
  final bool isError;
  final DecodeCity? city;
  final Weather? weather;

  @override
  Widget build(BuildContext context) {
    if (isError) {
      return ErrorBodyWidget(
          title: title, localisation: localisation, isError: isError);
    } else {
      if (coord.latitude == 0) {
        return const EmptyLocationWidget();
      }
      if (title == 'Currently') {
        return CurrentBody(
          coord: coord,
          city: city,
          weather: weather,
        );
      } else if (title == 'Today') {
        return TodayBody(
          coord: coord,
          city: city,
          weather: weather,
        );
      } else if (title == 'Weekly') {
        return WeeklyBody(
          coord: coord,
          city: city,
          weather: weather,
        );
      } else {
        return ErrorBodyWidget(
            title: title, localisation: localisation, isError: isError);
      }
    }
  }
}

class EmptyLocationWidget extends StatelessWidget {
  const EmptyLocationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Please select a location',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
