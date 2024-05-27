import 'package:darwin_box/di/i_login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import '../../di/app_injector.dart';
import '../arch/bloc_provider.dart';

class AppBloc extends BlocBase{

  String? title;
  BehaviorSubject<void> _onRouteGenrate = BehaviorSubject();
  BehaviorSubject<Widget> _startPage = BehaviorSubject();

  Sink<void> get onRouteGenrate=> _onRouteGenrate;

  Stream<Widget> get startPage => _startPage;
  void setUpPlatform() {
  }
  void init() {
  }
  void onClick() async{
    _startPage.add(AppInjector.instance.loginPage());


  }

}