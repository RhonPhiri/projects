import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'weather_class.dart';

class WeatherService {
  //fetch weather
  static String baseURL = 'https://api.open-meteo.com/v1/forecast?';
  static String urlParameters =
      'current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,cloud_cover,wind_speed_10m&daily=temperature_2m_max,precipitation_probability_max&timezone=auto';

  //fetch weather data
  Future<Weather> getWeather(
      {required double latitude, required double longitude}) async {
    final uri =
        '${baseURL}latitude=$latitude&longitude=$longitude&$urlParameters';
    final parsedUri = Uri.parse(uri);

    final response = await http.get(parsedUri);
    final jsonString = response.body;
    final jsonMap = jsonDecode(jsonString);
    return Weather.fromJson(jsonMap);
  }

  Future<({double latitude, double longitude})> getCityCoordinates() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best));

    final ({double latitude, double longitude}) coordinatinates = (
      latitude: position.latitude,
      longitude: position.longitude,
    );

    return coordinatinates;
  }
}
