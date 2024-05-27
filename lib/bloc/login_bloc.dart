import 'package:rxdart/rxdart.dart';
import '../app/arch/bloc_provider.dart';


typedef BlocProvider<LoginBloc> LoginFactory();
class LoginBloc extends BlocBase {
  BehaviorSubject<bool> _isLoading =BehaviorSubject.seeded(false);
  Stream<bool> get isLoading=> _isLoading;
        HomeBloc(){  }

}

/*
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LoadAuthEvent>(_onLoadAuth);
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', event.username);
    await prefs.setString('password', event.password);
    emit(Authenticated(event.username, event.password));
  }

  void _onLoadAuth(LoadAuthEvent event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final password = prefs.getString('password');

    if (username != null && password != null) {
      emit(Authenticated(username, password));
    } else {
      emit(Unauthenticated());
    }
  }
}
*/
