import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  
  sl.registerLazySingleton(() => ApiClient());
}
