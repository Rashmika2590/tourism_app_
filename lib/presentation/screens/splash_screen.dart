import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/app/auth/auth_bloc.dart';
import 'package:tourism_app/presentation/screens/auth/login_screen.dart';
import 'package:tourism_app/presentation/screens/home_screen.dart'; // Placeholder
// import 'package:tourism_app/presentation/screens/profile_screen.dart'; // Or navigate to profile/home

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/splash';
  static Route route() => MaterialPageRoute(builder: (_) => const SplashScreen(), settings: RouteSettings(name: routeName));

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          // Replace HomeScreen.routeName with your actual home screen or profile screen route
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        } else if (state.status == AuthStatus.unauthenticated || state.status == AuthStatus.error) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
