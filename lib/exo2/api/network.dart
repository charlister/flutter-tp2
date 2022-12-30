import 'dart:convert';

import 'package:http/http.dart';
import 'package:tp2/exo2/model/weather_model.dart';

class Network {
  static Future<WeatherForecastModel> getWeather({required String cityName}) async {
    var finalUrl = "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=408e832a2f1a2473ed7c36a836a29902&units=metric";

    final response = await get(Uri.parse(finalUrl));
    // print("URL: ${Uri.encodeFull(finalUrl)}");

    if (response.statusCode == 200) {
      // print("weather data: ${response.body}");
      return WeatherForecastModel.fromJson(json.decode(response.body));
    }
    else {
      throw Exception("Error getting weather forecast");
    }
  }
}