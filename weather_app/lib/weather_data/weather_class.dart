class Weather {
  final String city;
  final String date;
  final int isDay;
  final num cloudCover;
  final num temperature;
  final num humidity;
  final num apparentTemperature;
  final num windSpeed;
  final List dailyDate;
  final List dailyMaxTemperatures;
  final List dailyPrecipitationPercentage;

  Weather({
    required this.city,
    required this.date,
    required this.isDay,
    required this.cloudCover,
    required this.temperature,
    required this.humidity,
    required this.apparentTemperature,
    required this.windSpeed,
    required this.dailyDate,
    required this.dailyMaxTemperatures,
    required this.dailyPrecipitationPercentage,
  });

  factory Weather.fromJson(Map<String, dynamic> jsonMap) {
    return switch (jsonMap) {
      {
        'timezone': String city,
        'current': {
          'time': String date,
          'is_day': int isDay,
          'temperature_2m': num temperature,
          'relative_humidity_2m': num humidity,
          'apparent_temperature': num apparentTemperature,
          'cloud_cover': num cloudCover,
          'wind_speed_10m': num windSpeed,
        },
        'daily': {
          'time': List dailyDate,
          'temperature_2m_max': List dailyMaxTemperatures,
          'precipitation_probability_max': List dailyPrecipitationPercentage,
        }
      } =>
        Weather(
          city: city,
          date: date,
          isDay: isDay,
          cloudCover: cloudCover,
          temperature: temperature,
          humidity: humidity,
          apparentTemperature: apparentTemperature,
          windSpeed: windSpeed,
          dailyDate: dailyDate,
          dailyMaxTemperatures: dailyMaxTemperatures,
          dailyPrecipitationPercentage: dailyPrecipitationPercentage,
        ),
      _ => throw const FormatException('Unexpected Json Format')
    };
  }
  Weather.nullWeather()
      : city = '',
        date = DateTime.now().toString(),
        isDay = 0,
        cloudCover = 0,
        temperature = 0,
        humidity = 0,
        apparentTemperature = 0,
        windSpeed = 0,
        dailyDate = [],
        dailyMaxTemperatures = [],
        dailyPrecipitationPercentage = [];
}
