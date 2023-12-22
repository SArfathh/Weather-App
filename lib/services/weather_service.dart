import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  static const String apiKey = '7c82561e50a7cd89676487d3354270be';
  static const String apiUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> getWeatherForecast(
      double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$apiUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  Future<WeatherModel> getWeatherByLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      final response = await http.get(
        Uri.parse(
            '$apiUrl?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return WeatherModel.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to get device location: $e');
    }
  }

  Future<WeatherModel> getWeather(String city) async {
    final response = await http.get(
      Uri.parse('$apiUrl?q=$city&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
