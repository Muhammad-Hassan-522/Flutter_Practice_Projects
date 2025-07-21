import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';

import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWeather() async{
    try{
      String cityName = 'Lahore';
      final apiKey = openWeatherAPIKey;
      
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey',
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'Error: ${data['message']}';
      }
      
      return data;

    } catch(e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            }, 
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final data = snapshot.data!;

          final currWeather = data['list'][0];

          final currTemp = currWeather['main']['temp'] - 273.15; // temp was in K now in C
          final currSky = currWeather['weather'][0]['main'];
          final currPressure = currWeather['main']['pressure'];
          final currWindSpeed = currWeather['wind']['speed'];
          final currHumidity = currWeather['main']['humidity'];

          return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              '${currTemp.toStringAsFixed(1)}°C',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                            ),
                            const SizedBox(height: 16,),
                            Icon(
                              currSky == 'Clouds' || currSky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                              size: 64,
                            ),
                            const SizedBox(height: 16,),
                            Text(
                              currSky,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              // hourly forecast cards
              const Text(
                'Hourly Forecast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8,),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final hourlyForecast = data['list'][index + 1];
                    final hourlySky = data['list'][index + 1]['weather'][0]['main'];
                    final hourlyTemp = (hourlyForecast['main']['temp'] - 273.15).toStringAsFixed(1);
                    final hourlyTime = DateTime.parse(hourlyForecast['dt_txt']);
                
                    return HourlyForecastItem(
                      time: DateFormat.j().format(hourlyTime ),
                      icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                        ? Icons.cloud
                        : Icons.sunny, 
                      temperature: hourlyTemp,
                      );
                  },
                ),
              ),
              const SizedBox(height: 20,),
              // additional information
              const Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItem(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    value: currHumidity.toString(),
                  ),
                  AdditionalInfoItem(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    value: currWindSpeed.toString(),
                  ),
                  AdditionalInfoItem(
                    icon: Icons.beach_access,
                    label: 'Pressure',
                    value: currPressure.toString(),
                  ),
                ],
              ),
            ],
          ),
        );
        },
      ),
    );
  }
}