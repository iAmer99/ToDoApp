import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print("onTransition $transition");
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent( bloc, event) {
    print("onEvent $event");
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase cubit, Change change) {
    print("Cubit is $cubit and the change is $change");
    super.onChange(cubit, change);
  }

  @override
  void onError(BlocBase cubit, Object error, StackTrace stackTrace) {
    print("Bloc Error is $error");
    super.onError(cubit, error, stackTrace);
  }
}
