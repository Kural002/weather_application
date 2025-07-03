import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = '2e5202a07f069c35f22ee6779987a273';

  static Future<Map<String, dynamic>?> getWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'temp': data['main']['temp'],
        'feels_like': data['main']['feels_like'],
        'humidity': data['main']['humidity'],
        'wind_speed': data['wind']['speed'],
        'description': data['weather'][0]['description'],
        'timestamp': data['dt'],
        'timezone': data['timezone'],
      };
    }
    return null;
  }

  static Future<List<String>> getCitySuggestions(String query) async {
    final url =
        'http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => item['name'] as String).toList();
    }
    return [];
  }
}
