import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/views/details_page.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/views/favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();

  WeatherModel? _currentWeather;
  List<String> _favoriteLocations = [];

  Map<String, WeatherModel> _favoriteWeatherDetails = {};

  @override
  void initState() {
    super.initState();
    _loadFavoriteLocations();
    _getCurrentWeather();
  }

  Future<void> _loadFavoriteLocations() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteLocations = prefs.getStringList('favoriteLocations') ?? [];
    });
    await _getWeatherForFavorites();
  }

  Future<void> _getCurrentWeather() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          print('User denied location permission');
          return;
        }
      }

      final weather = await _weatherService.getWeatherByLocation();
      setState(() {
        _currentWeather = weather;
      });
    } catch (e) {
      print('Error getting current weather: $e');
    }
  }

  Future<void> _getWeatherForFavorites() async {
    Map<String, WeatherModel> tempDetails = {};
    for (String location in _favoriteLocations) {
      try {
        WeatherModel weather = await _weatherService.getWeather(location);
        tempDetails[location] = weather;
      } catch (e) {
        print('Error getting weather for $location: $e');
      }
    }
    setState(() {
      _favoriteWeatherDetails = tempDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
      ),
      body: Center(
        child: _currentWeather != null
            ? ListView(
                children: [
                  _buildcurrentWeatherItem(
                    _currentWeather!.cityName,
                    _currentWeather!,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Favorite Locations:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _favoriteLocations.length,
                    itemBuilder: (context, index) {
                      String location = _favoriteLocations[index];
                      return _favoriteWeatherDetails.containsKey(location)
                          ? _buildWeatherItem(
                              location, _favoriteWeatherDetails[location]!)
                          : ListTile(
                              title: Text(location),
                              subtitle:
                                  const Text('Weather data not available'),
                            );
                    },
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoritePage(),
            ),
          );
          _loadFavoriteLocations();
        },
        child: const Icon(Icons.favorite_border_outlined),
      ),
    );
  }

  Widget _buildcurrentWeatherItem(String location, WeatherModel weather) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(
                location: location,
              ),
            ),
          );
        },
        child: Card(
            elevation: 4,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.network(
                      'http://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
                      width: 100,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${weather.temperature.round()}°C',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      weather.description,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_upward),
                        Text(
                          '${weather.highTemp.round()}°C',
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 20),
                        const Icon(Icons.arrow_downward),
                        Text(
                          '${weather.lowTemp.round()}°C',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ))),
      ),
    );
  }

  Widget _buildWeatherItem(String location, WeatherModel weather) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(
                location: location,
              ),
            ),
          );
        },
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 20,
                            color: Colors.purple,
                          ),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${weather.temperature.round()}°C',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        weather.description,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Image.network(
                  'http://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
                  width: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
