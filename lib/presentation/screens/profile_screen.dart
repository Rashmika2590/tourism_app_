import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/app/auth/auth_bloc.dart'; // Adjust import path
import 'package:tourism_app/presentation/screens/short_stay/my_short_stays_screen.dart'; // New import

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const String routeName = '/profile';
  static Route route() => MaterialPageRoute(builder: (_) => const ProfileScreen(), settings: RouteSettings(name: routeName));

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (authState.status == AuthStatus.authenticated)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(AuthSignOutRequested());
              },
            )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile Screen'),
            if (authState.status == AuthStatus.authenticated) ...[
              Text('User ID: ${authState.user?.uid}'),
              Text('Email: ${authState.user?.email ?? 'N/A'}'),
              Text('Display Name: ${authState.user?.displayName ?? 'N/A'}'),
              Text('Anonymous: ${authState.user?.isAnonymous}'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(MyShortStaysScreen.routeName);
                        },
                        child: const Text('My Short Stay Bookings'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(MyLongStaysScreen.routeName);
                        },
                        child: const Text('My Long Stay Bookings'),
                      ),
            ] else if (authState.status == AuthStatus.unauthenticated) ...[
              Text('Not logged in.'),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'), // Assuming LoginScreen.routeName is '/login'
                child: Text('Go to Login'),
              )
            ] else if (authState.status == AuthStatus.loading) ...[
               CircularProgressIndicator(),
            ] else if (authState.status == AuthStatus.error) ...[
               Text('Error: ${authState.errorMessage}'),
            ]
          ],
        ),
      ),
    );
  }
}
