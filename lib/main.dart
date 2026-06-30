import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_app_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('projects_box');
  await Hive.openBox('tasks_box');

  final prefs = await SharedPreferences.getInstance();


  final bool showOnboarding = prefs.getBool('show_onboarding') ?? true;

  final String? savedEmail = prefs.getString('user_email');
  final bool isLoggedIn = (savedEmail != null && savedEmail.isNotEmpty);

  
  String initialRoute;
  if (showOnboarding) {
    initialRoute = '/onboarding'; 
  } else if (isLoggedIn) {
    initialRoute = '/projects'; 
  } else {
    initialRoute = '/login';
  }

  runApp(MyApp(
    initialRoute: initialRoute,
    isLoggedIn: isLoggedIn,
  ));
}
