import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    super.key,
    required this.myController,
    required this.setChoice,
    required this.setError,
    required this.setCoord,
  });

  final TextEditingController myController;
  final Function(String) setChoice;
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

class SearchBarInputWidget extends StatefulWidget {
  const SearchBarInputWidget({
    super.key,
    required this.myController,
    required this.setChoice,
    required this.setError,
    required this.setCoord,
  });

  final TextEditingController myController;
  final Function(String p1) setChoice;
  final Function(bool value, String reason) setError;
  final Function(double p1, double p2) setCoord;

  @override
  State<SearchBarInputWidget> createState() => _SearchBarInputWidget();
}

class _SearchBarInputWidget extends State<SearchBarInputWidget> {
  // const SearchBarInputWidget({
  //   super.key,
  //   required this.myController,
  //   required this.setChoice,
  //   required this.setError,
  //   required this.setCoord,
  // });

  // final TextEditingController myController;
  // final Function(String p1) setChoice;
  // final Function(bool value, String reason) setError;
  // final Function(double p1, double p2) setCoord;

  bool selectTile = false;
  TextEditingController textEditingController = TextEditingController();

  void setSelectTile(bool value) {
    setState(() {
      selectTile = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? searchingWithQuery;
    late Iterable<GeoData> lastOptions = <GeoData>[];

    String displayStringForOption(GeoData option) {
      if (option.city != null &&
          option.admin1 != null &&
          option.country != null) {
        return '${option.city}, ${option.admin1}, ${option.country}';
      } else if (option.city != null && option.country != null) {
        return '${option.city}, ${option.country}';
      } else if (option.city != null) {
        return '${option.city}';
      } else if (option.country != null) {
        return '${option.country}';
      } else {
        return 'Cannot show location';
      }
    }

    // myonFieldSubmitted(String value) {
    //   // Ajoutez ici le code que vous souhaitez exécuter lorsque le champ de texte est soumis
    //   print('myonFieldSubmitted: value=$value');
    //   // Ajoutez un retour explicite
    // }

    return Autocomplete<GeoData>(
      fieldViewBuilder: (BuildContext context, TextEditingController controller,
          FocusNode focusNode, Function onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            // print('TextFormField.onFieldSubmitted: value=$value');
            setSelectTile(true);
            onFieldSubmitted();
            // myonFieldSubmitted(value);
            controller.clear();
          },
          onChanged: (String value) {
            // print('TextFormField.onChanged: value=$value');
          },
          onTap: () {
            // print('TextFormField.onTap');
            if (selectTile == true) {
              controller.clear();
            }
            setSelectTile(false);
          },
          decoration: const InputDecoration(
              hintText: 'Search location', prefixIcon: Icon(Icons.search)),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) async {
        searchingWithQuery = textEditingValue.text;
        // print('OptionsBuilder: searchingWithQuery=$searchingWithQuery');

        if (searchingWithQuery == '') {
          setSelectTile(false);
        }

        if (selectTile == true) {
          return <GeoData>[];
        }

        try {
          final Iterable<GeoData> futureGeoData =
              await fetchGeocoding(searchingWithQuery!);

          //check if city is correct
          // if (searchingWithQuery != null &&
          //     searchingWithQuery!.length > 1 &&
          //     futureGeoData.isEmpty) {
          //   setError(
          //       true, 'Could not find any results for the supplied address');
          // } else if (searchingWithQuery != null &&
          //     searchingWithQuery!.length > 1 &&
          //     futureGeoData.isNotEmpty) {
          //   setError(false, '');
          // }

          // selectTile = false;

          // If another search happened after this one, throw away these options.
          // Use the previous options intead and wait for the newer request to
          // finish.
          if (searchingWithQuery != textEditingValue.text) {
            return lastOptions;
          }

          lastOptions = futureGeoData;
          return futureGeoData;
        } catch (e) {
          widget.setError(true, e.toString());
          return <GeoData>[];
        }
      },
      onSelected: (GeoData selection) {
        // debugPrint('You just selected ${displayStringForOption(selection)}');
        widget.setError(false, '');
        widget.setCoord(selection.longitude, selection.latitude);
        // Clear the text field when a city is selected
        textEditingController.clear();
        // onFieldSubmitted();
      },
      displayStringForOption: displayStringForOption,
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
            child: SearchBarResults(
          data: options,
          onSelected: onSelected,
          textEditingController: textEditingController,
          setSelectTile: setSelectTile,
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
    required this.textEditingController,
    required this.setSelectTile,
  });

  final Iterable<GeoData> data;
  final Function onSelected;
  final TextEditingController textEditingController;
  final Function setSelectTile;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        // final suggestion = data[index];
        final suggestion = data.elementAt(index);
        return Scrollbar(
          child: ListTile(
            onTap: () => {
              // print('ListTile.onTap: suggestion=${suggestion.city}'),
              setSelectTile(true),
              onSelected(suggestion),
              textEditingController.clear(),
            },
            title: Wrap(
              children: [
                const Icon(
                  Icons.location_city,
                  semanticLabel: 'City',
                ),
                const SizedBox(width: 8),
                if (suggestion.city != null) ...[
                  Text(
                    suggestion.city!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(', '),
                ],
                if (suggestion.admin1 != null) ...[
                  Text(suggestion.admin1!),
                  const Text(', '),
                ],
                if (suggestion.country != null) ...[
                  Text(suggestion.country!),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class GeoData {
  final int id;
  final String? city;
  final double latitude;
  final double longitude;
  final String? country;
  final String? admin1;

  const GeoData({
    required this.id,
    this.city,
    required this.latitude,
    required this.longitude,
    this.country,
    this.admin1,
  });

  factory GeoData.fromJson(Map<String, dynamic> json) {
    // print(json);
    return GeoData(
      id: json['id'] as int,
      city: json['name'] as String?,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      country: json['country'] as String?,
      admin1: json['admin1'] as String?,
    );
  }
}

List<GeoData> parseGeocoding(dynamic responseBody) {
  if (responseBody['results'] == null) {
    throw 'Could not find any results for the supplied address';
    // return [];
  }
  List responseResults = responseBody['results'];
  List<GeoData> allResults = [];
  GeoData tmp;

  // print(responseBody);
  // print(responseResults);

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

  try {
    final response = await http.get(Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=$value&count=10&language=en&format=json'));

    // print('fetchGeocoding: value=$value');
    // print(response.statusCode);
    // print(response.body);

    if (response.statusCode == 200) {
      try {
        return parseGeocoding(jsonDecode(response.body));
      } catch (e) {
        // print(e);
        rethrow;
        throw Exception('Unknown city');
      }
    } else {
      throw Exception('Error with provider');
    }
  } catch (e) {
    if (e is SocketException) {
      throw ('The service connexion is lost, please check your internet connection or try again later');
    } else {
      rethrow;
    }
  }
}
