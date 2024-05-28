import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import '../Utils/constant.dart';
import '../app/arch/bloc_provider.dart';
import '../model/weather.dart';
import '../repositories/weather_service.dart';


typedef BlocProvider<WeatherBloc> WeatherFactory();
class WeatherBloc extends BlocBase {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.mobile];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);

  Stream<bool> get isLoading => _isLoading;
  BehaviorSubject<Location> _locationData = BehaviorSubject();
  BehaviorSubject<Current> _currentData = BehaviorSubject();
  BehaviorSubject<Forecast> _forecastData = BehaviorSubject();

  Stream<Forecast> get forecastData => _forecastData;

  Stream<Current> get currentData => _currentData;

  Stream<Location> get locationData => _locationData;

  WeatherBloc() {
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // setListener();
  }
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;


  }

  void setListener(String latlng) {
    if(_connectionStatus[0].name!='none'){
      _isLoading.add(true);
      WeatherService().getWeatherReports(latlng).then((value) {
        _isLoading.add(false);
        EncryptedSharedPreferences.getInstance().setString(Constants.WEATHER, json.encode(value.data!.toJson()),notify: true);

        _locationData.add(value.data!.location!);
        _currentData.add(value.data!.current!);
        _forecastData.add(value.data!.forecast!);
      });
    }else{
      _isLoading.add(false);
      final data=  EncryptedSharedPreferences.getInstance().getString(Constants.WEATHER)!=null?json.decode(EncryptedSharedPreferences.getInstance().getString(Constants.WEATHER) ?? '{}'):null;
     Weather w=Weather.fromJson(data);
      _locationData.add(w.location!);
      _currentData.add(w.current!);
      _forecastData.add(w.forecast!);

    }

  }



}
