import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/app/auth/auth_bloc.dart'; // To get current user ID
import 'package:tourism_app/app/short_stay_booking/short_stay_booking_bloc.dart';
import 'package:tourism_app/data/models/models.dart';
import 'package:tourism_app/data/services/dummy_data_service.dart';

class ShortStayPropertyDetailScreen extends StatefulWidget {
  final Property property;

  const ShortStayPropertyDetailScreen({Key? key, required this.property}) : super(key: key);

  // No static routeName needed if pushed directly with MaterialPageRoute and arguments

  @override
  State<ShortStayPropertyDetailScreen> createState() => _ShortStayPropertyDetailScreenState();
}

class _ShortStayPropertyDetailScreenState extends State<ShortStayPropertyDetailScreen> {
  int _selectedHours = 3; // Default or from property

  @override
  void initState() {
    super.initState();
    _selectedHours = widget.property.numOfHoursForShortStay ?? 3;
  }

  void _handleBooking(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState.status != AuthStatus.authenticated || authState.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to book.')),
      );
      // Optionally navigate to login screen
      // Navigator.of(context).pushNamed(LoginScreen.routeName);
      return;
    }
    if (widget.property.pricePerHourShortStay == null) {
         ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Price per hour not available for this property.')));
        return;
    }

    context.read<ShortStayBookingBloc>().add(CreateShortStayBookingRequested(
          propertyId: widget.property.id,
          userId: authState.user!.uid,
          checkInDateTime: DateTime.now(), // Simplified
          durationHours: _selectedHours,
          totalPrice: (_selectedHours * (widget.property.pricePerHourShortStay ?? 0.0)),
          propertyName: widget.property.propertyName,
          propertyImageUrl: widget.property.propertyImage.primaryImageUrl,
        ));
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShortStayBookingBloc(dummyDataService: context.read<DummyDataService>()),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.property.propertyName)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.property.propertyImage.primaryImageUrl.isNotEmpty)
                ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(widget.property.propertyImage.primaryImageUrl, height: 250, width: double.infinity, fit: BoxFit.cover)),
              const SizedBox(height: 16),
              Text(widget.property.propertyName, style: Theme.of(context).textTheme.headlineSmall),
              Text('${widget.property.propertyType.name} in ${widget.property.address.city}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(children: [Icon(Icons.star, color: Colors.amber), Text(' ${widget.property.averageRating} (${widget.property.reviewCount} reviews)')]),
              const SizedBox(height: 16),
              Text('Description:', style: Theme.of(context).textTheme.titleSmall),
              Text(widget.property.description),
              const SizedBox(height: 16),
              Text('Amenities:', style: Theme.of(context).textTheme.titleSmall),
              Wrap(spacing: 8, children: widget.property.amenities.map((a) => Chip(label: Text(a))).toList()),
              const SizedBox(height: 16),

              if (widget.property.allowShortStays && widget.property.pricePerHourShortStay != null) ...[
                Text('Book Short Stay:', style: Theme.of(context).textTheme.titleSmall),
                // Simple hour selection for now, could be a dropdown if property has variable hours
                Row(
                  children: [
                    Text('Hours: '),
                    Expanded(
                      child: Slider(
                        value: _selectedHours.toDouble(),
                        min: 1,
                        max: (widget.property.numOfHoursForShortStay ?? 12).toDouble(), // Max hours for this property
                        divisions: (widget.property.numOfHoursForShortStay ?? 12) -1,
                        label: _selectedHours.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _selectedHours = value.round();
                          });
                        },
                      ),
                    ),
                     Text('$_selectedHours hr(s)'),
                  ],
                ),
                Text('Price: \$${(_selectedHours * (widget.property.pricePerHourShortStay ?? 0.0)).toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.green)),
                const SizedBox(height: 20),
                BlocConsumer<ShortStayBookingBloc, ShortStayBookingState>(
                  listener: (context, state) {
                    if (state.status == ShortStayBookingStatus.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Booking successful! ID: ${state.booking?.id}')),
                      );
                      Navigator.of(context).popUntil((route) => route.isFirst); // Go back to home or search
                    } else if (state.status == ShortStayBookingStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Booking failed: ${state.errorMessage}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.status == ShortStayBookingStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Center(
                      child: ElevatedButton(
                        onPressed: () => _handleBooking(context),
                        child: const Text('Book Now'),
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                      ),
                    );
                  },
                ),
              ] else ... [
                Text('Short stays not available or price not set for this property.', style: TextStyle(color: Colors.red)),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
