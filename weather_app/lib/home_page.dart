import 'package:flutter/material.dart';
import 'package:weather_app/weather_data/weather_class.dart';
import 'package:weather_app/weather_data/weather_service.dart';
import 'package:weather_app/widgets.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage(
      {super.key, required this.changeColor, required this.colorSelected});
  final void Function(int) changeColor;
  final Color colorSelected;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();
  Weather? _weather;
  String? _errorMessage;

  //method to fetch the weather
  Future<void> _fetchWeather() async {
    try {
      final cityCoordinates = await _weatherService.getCityCoordinates();
      final latitude = cityCoordinates.latitude;
      final longitude = cityCoordinates.longitude;

      final weather = await _weatherService.getWeather(
        latitude: latitude,
        longitude: longitude,
      );
      setState(() {
        _weather = weather;
        _errorMessage = null;
      });
      //ignore: unused_catch_clause
    } on Exception catch (e) {
      setState(() {
        _weather = Weather.nullWeather();
        _errorMessage = 'Connection failed. Please try again';
      });
    }
  }

  void _retryFecthWeather() {
    setState(() {
      _fetchWeather();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return _weather == null
        ? CustomCircularProgressiveIndicator()
        : _errorMessage != null
            ? CustomAlertDialog(retryFetchTemperature: _retryFecthWeather)
            : BuildBody(weather: _weather!);
  }
}

class CustomCircularProgressiveIndicator extends StatelessWidget {
  const CustomCircularProgressiveIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.retryFetchTemperature,
  });
  final void Function() retryFetchTemperature;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AlertDialog(
        backgroundColor: Colors.white,
        content: Text(
          'Please check your internet connection',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        contentPadding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
        ),
        actions: [
          TextButton(
            onPressed: () {
              retryFetchTemperature();
            },
            child: Text(
              'Retry',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
