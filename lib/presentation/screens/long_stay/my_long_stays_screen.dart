// lib/presentation/screens/long_stay/my_long_stays_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/app/auth/auth_bloc.dart';
import 'package:tourism_app/app/my_long_stays/my_long_stays_bloc.dart';
import 'package:tourism_app/data/services/dummy_data_service.dart';
import 'package:tourism_app/presentation/widgets/long_stay_booking_card.dart';

class MyLongStaysScreen extends StatelessWidget {
  const MyLongStaysScreen({Key? key}) : super(key: key);

  static const String routeName = '/my-long-stays';

  static Route route() {
    return MaterialPageRoute(
      builder: (context) {
        final authState = context.read<AuthBloc>().state;
        String? userId;
        if (authState.status == AuthStatus.authenticated && authState.user != null) {
          userId = authState.user!.uid;
        }

        return BlocProvider(
          create: (context) => MyLongStaysBloc(dummyDataService: context.read<DummyDataService>())
            ..add(LoadMyLongStaysRequested(userId: userId ?? 'unknown_user')),
          child: const MyLongStaysScreen(),
        );
      },
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState.status != AuthStatus.authenticated) {
         WidgetsBinding.instance.addPostFrameCallback((_) {
             Navigator.of(context).popUntil((route) => route.isFirst);
        });
        return const Scaffold(body: Center(child: Text("Redirecting...")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Long Stay Bookings')),
      body: BlocBuilder<MyLongStaysBloc, MyLongStaysState>(
        builder: (context, state) {
          if (state.status == MyLongStaysStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == MyLongStaysStatus.failure) {
            return Center(child: Text('Failed to load bookings: ${state.errorMessage}'));
          }
          if (state.status == MyLongStaysStatus.success && state.bookings.isEmpty) {
            return const Center(child: Text('You have no long stay bookings yet.'));
          }
          if (state.status == MyLongStaysStatus.success) {
            return ListView.builder(
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return LongStayBookingCard(booking: booking);
              },
            );
          }
          return const Center(child: Text('Loading your bookings...'));
        },
      ),
    );
  }
}
