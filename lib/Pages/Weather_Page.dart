import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/Weather_model.dart';
import 'package:weather_app/sevices/weather_services.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherServices('2e5202a07f069c35f22ee6779987a273');

  Weather? _weather;

  // fetch weather method
  _fetchWeather() async {
    //get current city
    String cityName = await _weatherService.getCurrentCity();
    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  //weather animation
  String weatherAnimation(String ? mainCondition) {
    if(mainCondition == null)  return 'Assets/sunny.json';

    switch(mainCondition.toLowerCase()){
      case 'clouds':
      return 'Assets/sunny.json';
      default:
      return 'Assets/cloud.json';
      

    }
  }

  //init state

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //city name 
            Text(_weather?.cityName ?? "loading..."),

            // animation 
            Lottie.asset(weatherAnimation(_weather?.mainCondition??"")),
            //temperature 
            Text('${_weather?.temperature.round()} °C'),
            //weather condition
            Text(_weather?.mainCondition??""),  
          ],
        ),
      ),
    );
  }
}
