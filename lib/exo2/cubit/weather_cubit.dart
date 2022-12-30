import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tp2/exo2/model/weather_model.dart';
import 'package:tp2/exo2/api/network.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  Future<void> getWeatherByCityName(String cityName) async {
    emit(WeatherLoading());

    try {
      final result = await Network.getWeather(cityName: cityName);
      emit(WeatherLoaded(result));
    } on Exception {
      emit(WeatherError("City not found !"));
    }
  }
}
