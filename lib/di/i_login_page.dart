
import '../app/arch/bloc_provider.dart';
import '../bloc/login_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../pages/login_page.dart';
import '../pages/weather_page.dart';
import 'app_injector.dart';

extension HomeExtension on AppInjector {
  LoginFactory get  loginPage => container.get();
  WeatherFactory get  weatherPage => container.get();

  registerLogin(){
    container.registerDependency<LoginFactory>((){
      return()=> BlocProvider<LoginBloc>(bloc: LoginBloc(), child:  LoginScreen());
    });
    container.registerDependency<WeatherFactory>((){
      return()=> BlocProvider<WeatherBloc>(bloc: WeatherBloc(), child:  WeatherPage());
    });
  }

}