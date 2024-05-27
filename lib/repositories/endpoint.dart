class EndPoint {
  final String base;
  final String path;

  EndPoint({required this.base, required this.path});
}
class EndPoints {
  static String _weather = "api.weatherapi.com";
  static String key = "76c968f97c9644a983f83955242405";
  static String get _base1 {
    return _weather;
  }

  static EndPoint get weather_details => _getEndPointWithProfile('/v1/forecast.json');
//http://api.weatherapi.com/v1/forecast.json?key=76c968f97c9644a983f83955242405&q=17.4435,78.3772
  static EndPoint _getEndPointWithProfile(String path) {
    return EndPoint(base: _base1, path: path);
  }


}