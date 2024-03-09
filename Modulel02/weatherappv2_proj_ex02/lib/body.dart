import 'package:flutter/material.dart';
import 'current.dart';
import 'error.dart';
import 'class_def.dart';

class MyTabWidget extends StatelessWidget {
  const MyTabWidget(
      {super.key,
      required this.title,
      required this.localisation,
      required this.coord,
      required this.isError});

  final String title;
  final String localisation;
  final Coord coord;
  final bool isError;

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
  });

  final String title;
  final String localisation;
  final Coord coord;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    if (isError) {
      return ErrorBodyWidget(
          title: title, localisation: localisation, isError: isError);
    } else {
      if (title == 'Currently') {
        return CurrentBody(coord: coord);
      } else {
        return ErrorBodyWidget(
            title: title, localisation: localisation, isError: isError);
      }
    }
  }
}
