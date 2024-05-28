import 'package:rxdart/rxdart.dart';
import '../app/arch/bloc_provider.dart';


typedef BlocProvider<LoginBloc> LoginFactory();
class LoginBloc extends BlocBase {
  BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  Stream<bool> get isLoading=> _isLoading;
        HomeBloc(){  }

}

