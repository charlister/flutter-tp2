import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget getWeatherIcon({required String weatherDescription, required Color color, required double size}) {
  Icon result;
  switch(weatherDescription) {
    case "Clear":
      result = Icon(FontAwesomeIcons.sun, color: color, size: size,);
      break;
    case "Clouds":
      result = Icon(FontAwesomeIcons.cloud, color: color, size: size,);
      break;
    case "Rain":
      result = Icon(FontAwesomeIcons.cloudRain, color: color, size: size,);
      break;
    case "Snow":
      result = Icon(FontAwesomeIcons.snowman, color: color, size: size,);
      break;
    default:
      result = Icon(FontAwesomeIcons.sun, color: color, size: size,);
      break;
  }
  return result;
}