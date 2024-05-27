import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';
import 'di/app_injector.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EncryptedSharedPreferences.initialize('1997@HarishAkula');
  runApp( MaterialApp(home: AppInjector.instance.app));
}

