import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/app/auth/auth_bloc.dart';
import 'package:tourism_app/presentation/screens/profile_screen.dart';
import 'package:tourism_app/presentation/screens/short_stay/short_stay_search_screen.dart';
import 'package:tourism_app/presentation/screens/long_stay/long_stay_search_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';
  static Route route() => MaterialPageRoute(builder: (_) => const HomeScreen(), settings: RouteSettings(name: routeName));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
            },
          ),
        ],
      ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Home Screen - Content to be added'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(ShortStaySearchScreen.routeName);
                      },
                      child: const Text('Find Short Stays'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(LongStaySearchScreen.routeName);
                      },
                      child: const Text('Find Long Stays'),
                    ),
                  ],
                )
              ),
    );
  }
}
