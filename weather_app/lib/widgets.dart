import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/weather_data/weather_class.dart';
import 'package:intl/intl.dart'; //provides extensive date & time handling cababilities

class BuildPopupMenu extends StatelessWidget {
  const BuildPopupMenu(
      {super.key, required this.changeColor, required this.colorSelected});
  final void Function(int) changeColor;
  final Color colorSelected;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        color: Theme.of(context).colorScheme.primary,
        onSelected: (value) => changeColor(value),
        tooltip: 'Select Color',
        icon: Icon(Icons.menu),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        position: PopupMenuPosition.under,
        itemBuilder: (BuildContext context) {
          return List.generate(ColorSelection.values.length, (int index) {
            return PopupMenuItem(
              enabled: colorSelected == ColorSelection.values[index].color
                  ? false
                  : true,
              value: index,
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(
                    Icons.opacity,
                    color: ColorSelection.values[index].color,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      ColorSelection.values[index].label,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }
}

//HomePage body
class BuildBody extends StatelessWidget {
  BuildBody({
    super.key,
    required this.weather,
  });
  final Weather weather;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 16),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            //Currwnt City
            _buildCity(),
            //today's Date
            _buildDate(context),
            SizedBox(height: 16),
            //main condition
            _buildMainCondition(context),
            //temperature
            _buildMainTemperature(context),
            //daily summary
            _buildDailySummary(context),
            SizedBox(height: 16),
            _buildWeatherCharacteristics(context),
            SizedBox(height: 8),
            _buildWeeklyForecast(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCity() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        weather.city.replaceAll('Africa/', ''),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    ));
  }

  //Used the intl package to format Date
  //to get weekday, date and month abbreviated
  String dateFormater(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat formatter = DateFormat('EEEE, d MMM');
    return formatter.format(dateTime);
  }

  Widget _buildDate(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final date = dateFormater(weather.date);

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(16)),
        child: Text(
          date,
          style: TextStyle(color: colorScheme.onPrimary, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildMainCondition(BuildContext context) {
    int cloudCoverValue = weather.cloudCover.toInt();
    String cloudCover = '';
    //one way to write it using else-if statements
    // if (0 <= cloudCoverValue && cloudCoverValue < 10) {
    //   cloudCover = 'Clear Skies';
    // } else if (10 <= cloudCoverValue && cloudCoverValue < 50) {
    //   cloudCover = 'Scattered Clouds';
    // } else if (50 <= cloudCoverValue && cloudCoverValue < 90) {
    //   cloudCover = 'Broken Clouds';
    // } else {
    //   cloudCover = 'Overcast';
    // }
    //
    //onother way using switch statements where any cloudCoverValue is tranctated by 10
    // switch (cloudCoverValue ~/ 10) {
    //   case 0:
    //     cloudCover = 'Clear Skies';
    //   case 1:
    //   case 2:
    //   case 3:
    //   case 4:
    //     cloudCover = 'Scattered Clouds';
    //   case 5:
    //   case 6:
    //   case 7:
    //   case 8:
    //   case 9:
    //     cloudCover = 'Broken Clouds';
    //   default:
    //     cloudCover = 'Overcast';
    // }
    //
    //onather way is using nested ternery operators
    cloudCover = (cloudCoverValue < 10)
        ? 'Clear Skies'
        : (cloudCoverValue < 50)
            ? 'Scattered Clouds'
            : (cloudCoverValue < 90)
                ? 'Broken Clouds'
                : 'Overcast';
    //now thats clear and consice
    return Center(
      child: Text(
        cloudCover,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }

  Widget _buildMainTemperature(BuildContext context) {
    return Center(
      child: Text(
        '${weather.temperature.round()}°',
        style: TextStyle(fontSize: 240),
        textHeightBehavior: TextHeightBehavior(
            applyHeightToFirstAscent: false, applyHeightToLastDescent: false),
      ),
    );
  }

  Widget _buildDailySummary(BuildContext context) {
    final currentTemerature = weather.temperature.round();
    final apparentTemperature = weather.apparentTemperature.round();
    final feeling = apparentTemperature < 10
        ? 'cold'
        : apparentTemperature < 20
            ? 'cool'
            : apparentTemperature < 30
                ? 'warm'
                : 'hot';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily Summary',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        SizedBox(height: 8),
        Text(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            'Now it feels like $apparentTemperature°, actually $currentTemerature°. '
            'It feels $feeling out here. '
            'Today, the temperature is felt '
            'in the range of $currentTemerature° to $apparentTemperature°.',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18)),
      ],
    );
  }

  Widget _buildWeatherCharacteristics(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final weatherCharacteristics = [
      {'character': 'wind', 'value': '${weather.windSpeed.round()} km/h'},
      {'character': 'Humidity', 'value': '${weather.humidity}%'},
      {'character': 'Visibility', 'value': null}
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
          color: colorScheme.primary, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (int index) {
          return Column(
            children: [
              switch (index) {
                0 => Icon(Icons.air, color: colorScheme.onPrimary, size: 56),
                1 => Icon(Icons.water_drop_outlined,
                    color: colorScheme.onPrimary, size: 56),
                2 => Icon(Icons.remove_red_eye_outlined,
                    color: colorScheme.onPrimary, size: 56),
                _ => Icon(Icons.error_outline,
                    color: colorScheme.onPrimary, size: 56),
              },
              SizedBox(height: 8),
              Text(weatherCharacteristics[index]['value'] ?? '',
                  style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w500)),
              Text(weatherCharacteristics[index]['character'] ?? '',
                  style: TextStyle(color: colorScheme.onPrimary, fontSize: 16)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildWeeklyForecast(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Weekly Forecast',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            IconButton(
              icon: Icon(Icons.arrow_right_alt_outlined, size: 40),
              onPressed: () {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: Duration(seconds: 1),
                  curve: Curves.easeIn,
                );
              },
            ),
          ],
        ),
        SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 4,
          child: NotificationListener<ScrollNotification>(
            child: GridView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: weather.dailyDate.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1),
                itemBuilder: (BuildContext context, int index) {
                  //daily temperature
                  final maxTemperature =
                      weather.dailyMaxTemperatures[index] as num;
                  //daily date
                  final String date =
                      dailyDateFormat(date: weather.dailyDate[index]);
                  //daily icon
                  final icon = getForecastIcon(
                      weather.dailyPrecipitationPercentage[index]);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: colorScheme.primary, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${maxTemperature.round()}°',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToLastDescent: false),
                          ),
                          Icon(icon, size: 30),
                          Text(
                            date,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }
  //method to get the daily forcast date

  String dailyDateFormat({required String date}) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat formatter = DateFormat('dMMM');
    return formatter.format(dateTime);
  }

  IconData getForecastIcon(int precipitaionPercentage) {
    if (precipitaionPercentage == 0) {
      if (weather.isDay == 0) {
        return Icons.dark_mode;
      }
      return Icons.wb_sunny;
    } else if (precipitaionPercentage <= 30) {
      return Icons.wb_cloudy;
    } else if (precipitaionPercentage <= 60) {
      return Icons.cloudy_snowing;
    } else {
      return Icons.thunderstorm;
    }
  }
}
