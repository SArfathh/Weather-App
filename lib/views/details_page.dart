import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/models/weather_model.dart';

class DetailsPage extends StatefulWidget {
  final String location;
  const DetailsPage({required this.location});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  WeatherModel? _weatherDetails;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      var weather = await WeatherService().getWeather(widget.location);
      setState(() {
        _weatherDetails = weather;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location),
      ),
      body: _weatherDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          _weatherDetails!.description,
                          style: const TextStyle(fontSize: 24),
                        ),
                        Container(
                          width: 200,
                          height: 200,
                          child: Image.network(
                            'http://openweathermap.org/img/wn/${_weatherDetails!.iconCode}@2x.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          '${_weatherDetails!.temperature.round()}°C',
                          style: const TextStyle(
                            fontSize: 48,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_upward),
                            Text(
                              '${_weatherDetails!.highTemp.round()}°C',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 20),
                            const Icon(Icons.arrow_downward),
                            Text(
                              '${_weatherDetails!.lowTemp.round()}°C',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.air,
                                    color: Colors.purple, size: 30),
                                Text(
                                  '${_weatherDetails!.windSpeed} m/s',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.opacity,
                                    color: Colors.purple, size: 30),
                                Text(
                                  ' ${_weatherDetails!.humidity}%',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.cloud,
                                    color: Colors.purple, size: 30),
                                Text(
                                  ' ${_weatherDetails!.pressure} hPa',
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  ' Sunrise',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const Icon(Icons.wb_sunny,
                                    color: Colors.orange, size: 30),
                                Text(
                                  _weatherDetails!.sunriseTime,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  ' Sunset',
                                  style: TextStyle(fontSize: 18),
                                ),
                                const Icon(Icons.brightness_3,
                                    color: Colors.indigo, size: 30),
                                Text(
                                  _weatherDetails!.sunsetTime,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
