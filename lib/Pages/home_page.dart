import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weather_app/sevices/weather_services.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String city = 'Chennai';
  Map<String, dynamic>? weather;
  bool _fontLoaded = true; // Track font loading status

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFonts();
    fetchWeather();
    
  }

  Future<void> _initializeFonts() async {
    try {
      // Preload the Poppins font by requesting it once
      await GoogleFonts.getFont('Poppins');
    } catch (e) {
      setState(() {
        _fontLoaded = false;
      });
    }
  }

  void fetchWeather() async {
    final result = await WeatherService.getWeather(city);
    setState(() {
      weather = result;
    });
  }

  TextStyle _getTextStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.white,
  }) {
    if (_fontLoaded) {
      return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    } else {
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: 'Roboto',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade800,
            Colors.blue.shade300,
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TypeAheadField<String>(
                  suggestionsCallback: (pattern) async {
                    return WeatherService.getCitySuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(
                        suggestion,
                        style: _getTextStyle(color: Colors.black),
                      ),
                    );
                  },
                  onSelected: (suggestion) {
                    city = suggestion;
                    _controller.text = suggestion;
                    fetchWeather();
                  },
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      
                      style: _getTextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                        hintText:  'Search City' ,
                        
                        labelStyle: _getTextStyle(color: Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                if (weather != null)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            city,
                            style: _getTextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${weather!['temp']}°C',
                            style: _getTextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            weather!['description'],
                            style: _getTextStyle(
                              fontSize: 20,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Lottie.asset(
                            getWeatherAnimation(weather!['description']),
                            height: 180,
                            width: 180,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                _buildWeatherDetail(
                                  'Feels Like',
                                  '${weather!['feels_like']}°C',
                                  Icons.thermostat,
                                ),
                                const Divider(
                                  color: Colors.white54,
                                  height: 20,
                                ),
                                _buildWeatherDetail(
                                  'Humidity',
                                  '${weather!['humidity']}%',
                                  Icons.water_drop,
                                ),
                                const Divider(
                                  color: Colors.white54,
                                  height: 20,
                                ),
                                _buildWeatherDetail(
                                  'Wind Speed',
                                  '${weather!['wind_speed']} m/s',
                                  Icons.air,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Time : ${formatCityTime(
                              weather!['timestamp'],
                              weather!['timezone'],
                            )}',
                            style: _getTextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (weather == null)
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: _getTextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: _getTextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

String getWeatherAnimation(String description) {
  description = description.toLowerCase();
  if (description.contains('clear')) {
    return 'assets/animations/sun.json';
  } else if (description.contains('cloud')) {
    return 'assets/animations/cloud.json';
  } else if (description.contains('rain')) {
    return 'assets/animations/rain.json';
  } else if (description.contains('thunderstorm')) {
    return 'assets/animations/storm.json';
  } else if (description.contains('snow')) {
    return 'assets/animations/snow.json';
  } else if (description.contains('mist') || description.contains('fog')) {
    return 'assets/animations/fog.json';
  } else {
    return 'assets/animations/cloud.json';
  }
}

String formatCityTime(int timestamp, int timezoneOffset) {
  final cityTime = DateTime.fromMillisecondsSinceEpoch(
    (timestamp + timezoneOffset) * 1000,
    isUtc: true,
  );
  return DateFormat.yMMMd().add_jm().format(cityTime);
}
