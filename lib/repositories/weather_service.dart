
import '../model/base_response/requestResponse.dart';
import '../model/weather.dart';
import 'base_apiservice.dart';
import 'endpoint.dart';

class WeatherService extends BaseAPIService {
  WeatherService();

  Future<RequestResponse<Weather>> getWeatherReports(String latlng) async {
    return make(RequestType.GET, EndPoints.weather_details,
        params: {"key": EndPoints.key, "q": latlng})
        .then((result) {
      if (result.data != null) {
        final weather = Weather.fromJson((result.data));
        return RequestResponse(data: weather);
      } else {
        return RequestResponse(error: result.error);
      }
    });
  }
}
