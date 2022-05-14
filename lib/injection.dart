import 'package:injectable/injectable.dart';
import 'package:note_app_ddd/injection.config.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

@injectableInit
void configureInjection(String env) {
  $initGetIt(getIt, environment: env);
}
