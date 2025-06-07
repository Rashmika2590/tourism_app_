// lib/presentation/screens/short_stay/my_short_stays_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/app/auth/auth_bloc.dart';
import 'package:tourism_app/app/my_short_stays/my_short_stays_bloc.dart';
import 'package:tourism_app/data/services/dummy_data_service.dart';
import 'package:tourism_app/presentation/widgets/short_stay_booking_card.dart';

class MyShortStaysScreen extends StatelessWidget {
  const MyShortStaysScreen({Key? key}) : super(key: key);

  static const String routeName = '/my-short-stays';

  static Route route() {
    return MaterialPageRoute(
      builder: (context) {
        final authState = context.read<AuthBloc>().state;
        String? userId;
        if (authState.status == AuthStatus.authenticated && authState.user != null) {
          userId = authState.user!.uid;
        }

        return BlocProvider(
          create: (context) => MyShortStaysBloc(dummyDataService: context.read<DummyDataService>())
            ..add(LoadMyShortStaysRequested(userId: userId ?? 'unknown_user')), // Handle case where user might not be available, though ideally screen is protected
          child: const MyShortStaysScreen(),
        );
      },
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check auth state again, potentially redirect if unauthenticated
    final authState = context.watch<AuthBloc>().state;
    if (authState.status != AuthStatus.authenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
             Navigator.of(context).popUntil((route) => route.isFirst); // Or to login
        });
        return const Scaffold(body: Center(child: Text("Redirecting...")));
    }


    return Scaffold(
      appBar: AppBar(title: const Text('My Short Stay Bookings')),
      body: BlocBuilder<MyShortStaysBloc, MyShortStaysState>(
        builder: (context, state) {
          if (state.status == MyShortStaysStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == MyShortStaysStatus.failure) {
            return Center(child: Text('Failed to load bookings: ${state.errorMessage}'));
          }
          if (state.status == MyShortStaysStatus.success && state.bookings.isEmpty) {
            return const Center(child: Text('You have no short stay bookings yet.'));
          }
          if (state.status == MyShortStaysStatus.success) {
            return ListView.builder(
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return ShortStayBookingCard(booking: booking);
              },
            );
          }
          return const Center(child: Text('Loading your bookings...')); // Initial state
        },
      ),
    );
  }
}
