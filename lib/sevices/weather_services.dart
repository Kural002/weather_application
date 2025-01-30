import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/Weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherServices(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final reponse = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metrics'));

    if (reponse.statusCode == 200) {
      return Weather.fromJson(jsonDecode(reponse.body));
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> getCurrentCity() async {
    var testLatitude = 37.7749;
    var testLongitude = -122.4194;
    //get permission from user
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //convert the location into a list of placemark object
    List<Placemark> placemark = await placemarkFromCoordinates(
      testLatitude,
      testLongitude,
    );

    //extract the city name from the first placemark
    String? city = placemark[0].locality;
    return city ?? "";
  }
}
