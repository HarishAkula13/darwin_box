
import 'package:injector/injector.dart';
import '../app/arch/bloc_provider.dart';
import '../app/bloc/app_bloc.dart';
import '../app_page.dart';
import '../di/i_login_page.dart';
class AppInjector{
  static final AppInjector instance=AppInjector._internal();
  final container=Injector.appInstance;

  //App
  BlocProvider<AppBloc> get app => container.get();

  AppInjector._internal() {
    container.registerDependency<BlocProvider<AppBloc>>(() {
      return BlocProvider(child: AppPage(), bloc: AppBloc());
    });
    registerLogin();

  }
}