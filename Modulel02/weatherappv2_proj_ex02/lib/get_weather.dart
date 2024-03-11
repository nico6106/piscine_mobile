import 'class_def.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrentWeather {
  final double? temperature;
  final int? weatherCode;
  final int? cloudCover;
  final double? windSpeed10m;

  const CurrentWeather({
    this.temperature,
    this.weatherCode,
    this.cloudCover,
    this.windSpeed10m,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: json['temperature_2m'] as double?,
      weatherCode: json['weather_code'] as int?,
      cloudCover: json['cloud_cover'] as int?,
      windSpeed10m: json['wind_speed_10m'] as double?,
    );
  }
}

class TodayWeather {
  final List<DateTime>? time;
  final List<double>? temperature;
  final List<int>? weatherCode;
  final List<double>? windSpeed10m;

  const TodayWeather({
    this.time,
    this.temperature,
    this.weatherCode,
    this.windSpeed10m,
  });

  factory TodayWeather.fromJson(Map<String, dynamic> json) {
    // print('TodayWeather $json');
    return TodayWeather(
      time: (json['time'] as List<dynamic>).map((e) => DateTime.fromMillisecondsSinceEpoch(e * 1000)).toList(),
      temperature: (json['temperature_2m'] as List<dynamic>).map((e) => e as double).toList(),
      weatherCode: (json['weather_code'] as List<dynamic>).map((e) => e as int).toList(),
      windSpeed10m: (json['wind_speed_10m'] as List<dynamic>).map((e) => e as double).toList(),
    );
  }
}

class WeeklyWeather {
  final List<DateTime>? time;
  final List<double>? tempMax;
  final List<double>? tempMin;
  final List<int>? weatherCode;
  final List<double>? precipitationSum;

  const WeeklyWeather({
    this.time,
    this.tempMax,
    this.tempMin,
    this.weatherCode,
    this.precipitationSum,
  });

  factory WeeklyWeather.fromJson(Map<String, dynamic> json) {
    return WeeklyWeather(
      time: (json['time'] as List<dynamic>).map((e) => DateTime.fromMillisecondsSinceEpoch(e * 1000)).toList(),
      tempMax: (json['temperature_2m_max'] as List<dynamic>).map((e) => e as double).toList(),
      tempMin: (json['temperature_2m_min'] as List<dynamic>).map((e) => e as double).toList(),
      weatherCode: (json['weather_code'] as List<dynamic>).map((e) => e as int).toList(),
      precipitationSum: (json['precipitation_sum'] as List<dynamic>).map((e) => e as double).toList(),
    );
  }
}

class Weather {
  final double? latitude;
  final double? longitude;
  final CurrentWeather? current;
  final TodayWeather? today;
  final WeeklyWeather? weekly;

  const Weather({
    this.latitude,
    this.longitude,
    this.current,
    this.today,
    this.weekly,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    if (json['current'] == null) {
      throw Exception('Unknown city');
    }
    dynamic jsonCurr = json['current'];
    dynamic jsonToday = json['hourly'];
    dynamic jsonWeekly = json['daily'];

    CurrentWeather currWeather = CurrentWeather.fromJson((jsonCurr));
    // print('here 2');
    TodayWeather todayWeather = TodayWeather.fromJson((jsonToday));
    // print('here 3');
    WeeklyWeather weeklyWeather = WeeklyWeather.fromJson((jsonWeekly));
    // print('here 4');

    return Weather(
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      current: currWeather as CurrentWeather?,
      today: todayWeather as TodayWeather?,
      weekly: weeklyWeather as WeeklyWeather?,
    );
  }
}

Future<Weather> fetchWeather(Coord coord) async {
  print('fetchCurrentWeather: coord=${coord.latitude}, ${coord.longitude}');
  try {
    final response = await http.get(Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${coord.latitude}&longitude=${coord.longitude}&current=temperature_2m,precipitation,weather_code,wind_speed_10m&hourly=temperature_2m,precipitation,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum&timeformat=unixtime&timezone=Europe%2FBerlin'));

    if (response.statusCode == 200) {
      try {
        // print(response.body);
        return Weather.fromJson(jsonDecode(response.body));
      } catch (e) {
        print(e);
        // return List<GeoData>.empty();
        throw Exception('Unknown city');
      }
    } else {
      throw Exception('Error with provider');
    }
  } catch (e) {
    if (e is SocketException) {
      throw Exception('Please check internet connexion');
    } else {
      rethrow;
    }
  }
}

final Map<int, String> weatherCodes = {
  0: 'Clear sky',
  1: 'Mainly clear',
  2: 'Partly cloudy',
  3: 'Overcast',
  45: 'Fog',
  48: 'Depositing rime fog',
  51: 'Light drizzle',
  53: 'Moderate drizzle',
  55: 'Dense intensity drizzle',
  56: 'Light Freezing Drizzle',
  57: 'Freezing Drizzle: dense intensity',
  61: 'Slight rain',
  63: 'Moderate rain',
  65: 'Heavy intensity rain',
  66: 'Freezing Rain: Light',
  67: 'Freezing Rain: heavy intensity',
  71: 'Slight Snow fall',
  73: 'Moderate Snow fall',
  75: 'Heavy intensity snow fall',
  77: 'Snow grains',
  80: 'Slight rain showers',
  81: 'Moderate rain showers',
  82: 'Violent rain showers',
  95: 'Thunderstorm: Slight or moderate',
  96: 'Thunderstorm with slight hail',
  99: 'Thunderstorm with heavy hail',
};
