
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tp2/exo2/cubit/weather_cubit.dart';
import 'package:tp2/exo2/model/weather_model.dart';
import 'package:tp2/exo2/widget/weather_icone.dart';

class WeatherPage extends StatelessWidget {
  late TextField searchField;
  late Size screenSize;

  WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    searchField = buildSearchField(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Météo"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherInitial) {
              print("initial");
              return Container(
                margin: EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 0),
                child: paddingFor(searchField, 10, 0, 10, 0),
              );
            }
            else if (state is WeatherLoading) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                child: Column(
                  children: [
                    paddingFor(searchField, 10, 0, 10, 0),
                    Container(
                      margin: EdgeInsets.only(top: screenSize.height/3),
                      alignment: AlignmentDirectional.center,
                      child: const SpinKitFadingCircle(
                        color: Colors.blue,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              );
            }
            else if (state is WeatherLoaded) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                child: Column(
                  children: [
                    paddingFor(searchField, 10, 0, 10, 0),
                    searchResults(context, state),
                  ],
                )
              );
            }
            else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
                child: Column(
                  children: [
                    paddingFor(searchField, 10, 0, 10, 0),
                    Container(
                      margin: EdgeInsets.only(top: screenSize.height/3),
                      alignment: AlignmentDirectional.center,
                      child: const Text(
                        "Error",
                      ),
                    ),
                  ],
                )
              );
            }
          },
        ),
      ),
    );
  }

  Padding paddingFor(Widget widget, double l, double t, double r, double b) {
    return Padding(
      padding: EdgeInsets.fromLTRB(l, t, r, b),
      child: widget,
    );
  }

  TextField buildSearchField(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
        labelText: 'Ville',
        hintText: 'Saisir la ville',
      ),
      onSubmitted: (value) {
        BlocProvider.of<WeatherCubit>(context).getWeatherByCityName(value);
      },
    );
  }

  Text getPlace(WeatherLoaded state) {
    City city = state.weatherForecastModel.city!;
    String cityInfo = '${city.name}, ${city.country}';
    return Text(
        cityInfo,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
    );
  }

  Text getDate(WeatherLoaded state, int index, [String format = "EEEE"]) {
    DateTime? date = DateTime.tryParse("${state.weatherForecastModel.list![index].dtTxt}");
    final DateFormat formatter = DateFormat(format);
    String dateText;
    if (date == null) {
      dateText = "None";
    }
    else {
      dateText = formatter.format(date);
    }
    return Text(
      dateText,
    );
  }

  Row getTempInfo(WeatherLoaded state) {
    num? celsiusTemp = state.weatherForecastModel.list![0].main!.temp;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${celsiusTemp?.toInt()}°C",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 0),
        ),
        Text(
          state.weatherForecastModel.list![0].weather![0].description!.toUpperCase(),
        ),
      ],
    );
  }

  Row getDetailsTempInfo(WeatherLoaded state) {
    num? celsiusTemp = state.weatherForecastModel.list![0].main!.temp;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              "${state.weatherForecastModel.list![0].wind!.speed} m/s"
            ),
            const Icon(FontAwesomeIcons.wind)
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
        ),
        Column(
          children: [
            Text(
              "${state.weatherForecastModel.list![0].main!.humidity} %"
            ),
            const Icon(FontAwesomeIcons.solidFaceSmileBeam)
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
        ),
        Column(
          children: [
            Text(
                "${celsiusTemp?.toInt()}°C"
            ),
            const Icon(FontAwesomeIcons.temperatureFull)
          ],
        ),
      ],
    );
  }

  DateTime? convertToDateTime(WeatherLoaded state, int index) {
    DateTime? date = DateTime.tryParse("${state.weatherForecastModel.list![index].dtTxt}");
    return date;
  }

  List tempInterval(WeatherLoaded state, int index) {
    List result = <num>[-999, 999];
    DateTime? firstDateTime = DateTime.tryParse("${state.weatherForecastModel.list![index].dtTxt}");
    DateTime otherDateTime;
    for (int i = index+1; i < state.weatherForecastModel.list!.length; i++) {
      otherDateTime = DateTime.tryParse("${state.weatherForecastModel.list![i].dtTxt}")!;
      if (firstDateTime?.day != otherDateTime.day) {
        break;
      }
      if(result[0]==-999) {
        result[0] = state.weatherForecastModel.list![i].main!.temp;
        result[1] = state.weatherForecastModel.list![i].main!.temp;
      }
      else if (result[0] > state.weatherForecastModel.list![i].main!.temp) {
        result[0] = state.weatherForecastModel.list![i].main!.temp;
      }
      else if (result[1] < state.weatherForecastModel.list![i].main!.temp) {
        result[1] = state.weatherForecastModel.list![i].main!.temp;
      }
    }
    return result;
  }

  int getNextDayIndex(WeatherLoaded state, int currentDayIndex) {
    DateTime? firstDateTime = DateTime.tryParse("${state.weatherForecastModel.list![currentDayIndex].dtTxt}");
    DateTime otherDateTime;
    for (int i = currentDayIndex+1; i < state.weatherForecastModel.list!.length; i++) {
      otherDateTime = DateTime.tryParse("${state.weatherForecastModel.list![i].dtTxt}")!;
      if (firstDateTime?.day != otherDateTime.day) {
        return i;
      }
    }
    return 0;
  }

  List<Container> generateInfoForNextDays(WeatherLoaded state) {
    List<Container> results = [];
    int nextDayIndex = getNextDayIndex(state, 0);
    while(nextDayIndex != 0) {
      results.add(prevision(state, nextDayIndex));
      nextDayIndex = getNextDayIndex(state, nextDayIndex);
    }
    return results;
  }

  Container prevision(WeatherLoaded state, int index) {
    List interval = tempInterval(state, index);
    return Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      height: 200,
      width: 200,
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          getDate(state, index),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height:75,
                width: 75,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(37.5)
                ),
                child: getWeatherIcon(weatherDescription: "${state.weatherForecastModel.list![index].weather![0].main}", color: Colors.blue, size: 37.5),
              ),
              Column(
                children: [
                  Text("${interval[0].toInt().toString()}°C"),
                  Text("${interval[1].toInt().toString()}°C"),
                  Text("Hum:${state.weatherForecastModel.list![index].main!.humidity} %"),
                  Text("Win:${state.weatherForecastModel.list![index].wind!.speed} m/s"),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Column previsions(WeatherLoaded state) {
    return Column(
      children: [
        Container(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: generateInfoForNextDays(state),
          ),
        ),
      ],
    );
  }

  Column searchResults(BuildContext context, WeatherLoaded state) {
    return Column(
      children: [
        Center(
          child: Column(
            children: [
              paddingFor(getPlace(state), 0, 20, 0, 0),
              getDate(state, 0, 'EEEE, MMM d, y'),
              paddingFor(getWeatherIcon(weatherDescription: "${state.weatherForecastModel.list![0].weather![0].main}", color: Colors.blue, size: 200), 0, 20, 0, 0),
              paddingFor(getTempInfo(state), 0, 10, 0, 10),
              paddingFor(getDetailsTempInfo(state), 0, 10, 0, 10),
              paddingFor(const Text("5-DAY WEATHER FORECAST"), 10, 10, 10, 10),
              paddingFor(previsions(state), 10, 10, 10, 10),
            ],
          ),
        ),
      ],
    );
  }
}