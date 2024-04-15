import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    super.key,
    required this.myController,
    required this.setCity,
    required this.setChoice,
    required this.setShowSearch,
    required this.setError,
    required this.setCoord,
  });

  final TextEditingController myController;
  final Function(String) setCity;
  final Function(String) setChoice;
  final Function(bool) setShowSearch;
  final Function(bool value, String reason) setError;
  final Function(double p1, double p2) setCoord;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: SearchBarInputWidget(
              myController: myController,
              setCity: setCity,
              setChoice: setChoice,
              setError: setError,
              setCoord: setCoord,
            ),
          ),
          GestureDetector(
            onTap: () => {setChoice('gps')},
            child: const Icon(
              Icons.near_me,
              semanticLabel: 'Near me',
              size: 40.0,
            ),
          )
        ],
      ),
    );
  }
}

class SearchBarInputWidget extends StatelessWidget {
  const SearchBarInputWidget({
    super.key,
    required this.myController,
    required this.setCity,
    required this.setChoice,
    required this.setError,
    required this.setCoord,
  });

  final TextEditingController myController;
  final Function(String p1) setCity;
  final Function(String p1) setChoice;
  final Function(bool value, String reason) setError;
  final Function(double p1, double p2) setCoord;

  @override
  Widget build(BuildContext context) {
    String? searchingWithQuery;
    late Iterable<GeoData> lastOptions = <GeoData>[];

    String displayStringForOption(GeoData option) {
      if (option.admin1 != null) {
        return '${option.city}, ${option.admin1}, ${option.country}';
      } else {
        return '${option.city}, ${option.country}';
      }
    }

    return Autocomplete<GeoData>(
      fieldViewBuilder: (BuildContext context, TextEditingController controller,
          FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          decoration: const InputDecoration(
              hintText: 'Search location', prefixIcon: Icon(Icons.search)),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) async {
        searchingWithQuery = textEditingValue.text;

        try {
          final Iterable<GeoData> futureGeoData =
              await fetchGeocoding(searchingWithQuery!);

          // If another search happened after this one, throw away these options.
          // Use the previous options intead and wait for the newer request to
          // finish.
          if (searchingWithQuery != textEditingValue.text) {
            return lastOptions;
          }

          lastOptions = futureGeoData;
          return futureGeoData;
        } catch (e) {
          setError(true, e.toString());
          return <GeoData>[];
        }
      },
      onSelected: (GeoData selection) {
        // debugPrint('You just selected ${displayStringForOption(selection)}');
        setError(false, '');
        setCoord(selection.longitude, selection.latitude);
      },
      displayStringForOption: displayStringForOption,
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
            child: SearchBarResults(
          data: options,
          onSelected: onSelected,
        ));
      },
    );
  }
}

class SearchBarResults extends StatelessWidget {
  const SearchBarResults({
    super.key,
    required this.data,
    required this.onSelected,
  });

  final Iterable<GeoData> data;
  final Function onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        // final suggestion = data[index];
        final suggestion = data.elementAt(index);
        return ListTile(
          onTap: () => onSelected(suggestion),
          title: Wrap(
            children: [
              const Icon(
                Icons.location_city,
                semanticLabel: 'City',
              ),
              const SizedBox(width: 8),
              Text(
                suggestion.city,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(', '),
              if (suggestion.admin1 != null) ...[
                Text(suggestion.admin1!),
                const Text(', '),
              ],
              Text(suggestion.country),
            ],
          ),
        );
      },
    );
  }
}

class GeoData {
  final int id;
  final String city;
  final double latitude;
  final double longitude;
  final String country;
  final String? admin1;

  const GeoData({
    required this.id,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.country,
    this.admin1,
  });

  factory GeoData.fromJson(Map<String, dynamic> json) {
    return GeoData(
      id: json['id'] as int,
      city: json['name'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      country: json['country'] as String,
      admin1: json['admin1'] as String?,
    );
  }
}

List<GeoData> parseGeocoding(dynamic responseBody) {
  if (responseBody['results'] == null) {
    // throw 'Could not find any results for the supplied address';
    return [];
  }
  List responseResults = responseBody['results'];
  List<GeoData> allResults = [];
  GeoData tmp;

  for (var elem in responseResults) {
    tmp = GeoData.fromJson(elem);
    allResults.add(tmp);
  }
  return allResults;
}

Future<List<GeoData>> fetchGeocoding(String value) async {
  if (value.isEmpty || value.length < 2) {
    return List<GeoData>.empty();
  }

  // print('fetchGeocoding: value=$value');

  try {
    final response = await http.get(Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=$value&count=5&language=en&format=json'));

    if (response.statusCode == 200) {
      try {
        return parseGeocoding(jsonDecode(response.body));
      } catch (e) {
        // return List<GeoData>.empty();
        return List<GeoData>.empty();
        // throw Exception('Error parsing datas');
      }
    } else {
      throw Exception('Error with provider');
    }
  } catch (e) {
    if (e is SocketException) {
      throw Exception('Socket');
    } else {
      rethrow;
    }
  }
}
