import 'package:intl/intl.dart';

class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final String iconCode;
  final double highTemp;
  final double lowTemp;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int visibility;
  final String sunriseTime;
  final String sunsetTime;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.highTemp,
    required this.lowTemp,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.sunriseTime,
    required this.sunsetTime,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      highTemp: json['main']['temp_max'].toDouble(),
      lowTemp: json['main']['temp_min'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure'],
      visibility: json['visibility'],
      sunriseTime: _timestampToTime(json['sys']['sunrise']),
      sunsetTime: _timestampToTime(json['sys']['sunset']),
    );
  }

  static String _timestampToTime(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final timeFormat = DateFormat('hh:mm a');
    return timeFormat.format(dateTime);
  }
}
