import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/app/auth/auth_bloc.dart';
import 'package:tourism_app/presentation/screens/auth/login_screen.dart';
import 'package:tourism_app/presentation/screens/auth/signup_screen.dart';
import 'package:tourism_app/presentation/screens/profile_screen.dart';
import 'package:tourism_app/presentation/screens/splash_screen.dart';
import 'package:tourism_app/presentation/screens/home_screen.dart'; // Placeholder for home
import 'package:tourism_app/data/services/dummy_data_service.dart';
import 'package:tourism_app/presentation/screens/short_stay/short_stay_search_screen.dart';
import 'package:tourism_app/presentation/screens/short_stay/my_short_stays_screen.dart';
import 'package:tourism_app/presentation/screens/long_stay/long_stay_search_screen.dart';
import 'package:tourism_app/presentation/screens/long_stay/my_long_stays_screen.dart'; // New import
import 'package:firebase_auth/firebase_auth.dart'; // Added for AuthBloc in main

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DummyDataService _dummyDataService = DummyDataService(); // Instantiate service

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider( // Or just RepositoryProvider if only one
      providers: [
        RepositoryProvider.value(value: _dummyDataService),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(firebaseAuth: FirebaseAuth.instance) // Assuming FirebaseAuth is passed or default
                             ..add(AuthAppStarted()),
        child: MaterialApp(
          title: 'Tourism App',
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => const SplashScreen(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            SignupScreen.routeName: (context) => const SignupScreen(),
            ProfileScreen.routeName: (context) => const ProfileScreen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            ShortStaySearchScreen.routeName: (context) => const ShortStaySearchScreen(),
            MyShortStaysScreen.routeName: (context) => const MyShortStaysScreen(),
            LongStaySearchScreen.routeName: (context) => const LongStaySearchScreen(),
            MyLongStaysScreen.routeName: (context) => const MyLongStaysScreen(), // Add this
            // Define other routes here
          },
        ),
        // Optionally, define a home widget based on initial auth state if not using splash
        // home: BlocBuilder<AuthBloc, AuthState>(
        //   builder: (context, state) {
        //     if (state.status == AuthStatus.authenticated) {
        //       return ProfileScreen(); // Or HomeScreen
        //     }
        //     return LoginScreen();
        //   },
        // ),
      ),
    );
  }
}
