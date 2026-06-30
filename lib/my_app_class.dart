import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/sign_up_screen.dart';
import 'features/onBordingScreen/onBording_screens.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/projects/presentation/bloc/projects_cubit.dart';
import 'features/projects/presentation/bloc/tasks_cubit.dart';
import 'features/projects/presentation/screens/projects_screen.dart';

class MyApp extends StatelessWidget {
  final String initialRoute;
  final bool isLoggedIn;

  const MyApp({Key? key, required this.initialRoute, required this.isLoggedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProjectsCubit>(
          create: (context) => ProjectsCubit(),
        ),
        BlocProvider<TasksCubit>(
          create: (context) => TasksCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Project Management App',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          primaryColor: Colors.blue,
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF121212),
          cardTheme: const CardTheme(
            color: Color(0xFF1E1E1E),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF121212),
            elevation: 0,
          ),
        ),
        initialRoute: initialRoute,
        routes: {
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/projects': (context) => const ProjectsScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
