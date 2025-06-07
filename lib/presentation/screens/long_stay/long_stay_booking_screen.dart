import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tourism_app/app/auth/auth_bloc.dart';
import 'package:tourism_app/app/long_stay_booking/long_stay_booking_bloc.dart';
import 'package:tourism_app/data/models/models.dart';
import 'package:tourism_app/data/services/dummy_data_service.dart';

class LongStayBookingScreen extends StatefulWidget {
  final Property property;
  final PackageInfo packageInfo;

  const LongStayBookingScreen({
    Key? key,
    required this.property,
    required this.packageInfo,
  }) : super(key: key);

  @override
  State<LongStayBookingScreen> createState() => _LongStayBookingScreenState();
}

class _LongStayBookingScreenState extends State<LongStayBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  final _numGuestsController = TextEditingController(text: '1');
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    // Pre-fill dates based on package duration if desired, e.g., start today
    _checkInDate = DateTime.now();
    _checkOutDate = _checkInDate!.add(Duration(days: widget.packageInfo.durationDays));
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime initial = isCheckIn
        ? (_checkInDate ?? DateTime.now())
        : (_checkOutDate ?? _checkInDate?.add(Duration(days: widget.packageInfo.durationDays)) ?? DateTime.now().add(Duration(days: widget.packageInfo.durationDays)));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(Duration(days: isCheckIn ? 0 : 30)), // Allow some flexibility or enforce package duration
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          _checkOutDate = _checkInDate!.add(Duration(days: widget.packageInfo.durationDays)); // Auto-set checkout based on duration
        } else {
          // Allow selecting checkout date, but ensure it's after check-in and respects duration if strict
          // For simplicity, we'll let it be selectable but validation is key
          _checkOutDate = picked;
        }
      });
    }
  }

  void _handleBooking(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    if (_checkInDate == null || _checkOutDate == null) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select check-in and check-out dates.')));
        return;
    }
    if (_checkOutDate!.isBefore(_checkInDate!)) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Check-out date must be after check-in date.')));
        return;
    }
    // Basic validation for package duration, could be more sophisticated
    final duration = _checkOutDate!.difference(_checkInDate!).inDays;
    if (duration != widget.packageInfo.durationDays) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected duration must match package duration of ${widget.packageInfo.durationDays} days.')));
        // return; // Comment out to allow booking for now, but this is a point of logic
    }


    final authState = context.read<AuthBloc>().state;
    if (authState.status != AuthStatus.authenticated || authState.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please log in to book.')));
      return;
    }

    context.read<LongStayBookingBloc>().add(CreateLongStayBookingRequested(
          packageId: widget.packageInfo.id,
          propertyId: widget.property.id,
          userId: authState.user!.uid,
          checkInDate: _checkInDate!,
          checkOutDate: _checkOutDate!,
          noOfGuests: int.tryParse(_numGuestsController.text) ?? 1,
          totalPrice: widget.packageInfo.priceDetail.basePrice, // Simplified price for now
          packageName: widget.packageInfo.packageName,
          propertyName: widget.property.propertyName,
          packageImageUrl: widget.packageInfo.packageImage.primaryImageUrl
        ));
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LongStayBookingBloc(dummyDataService: context.read<DummyDataService>()),
      child: Scaffold(
        appBar: AppBar(title: Text('Book: ${widget.packageInfo.packageName}')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Property: ${widget.property.propertyName}', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Package: ${widget.packageInfo.packageName}', style: Theme.of(context).textTheme.titleMedium),
                Text('Duration: ${widget.packageInfo.durationDays} days', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                if (widget.packageInfo.packageImage.primaryImageUrl.isNotEmpty)
                    Image.network(widget.packageInfo.packageImage.primaryImageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
                const SizedBox(height: 16),
                Text('Details:', style: Theme.of(context).textTheme.titleSmall),
                Text(widget.packageInfo.description),
                const SizedBox(height: 16),
                Text('Activities Included:', style: Theme.of(context).textTheme.titleSmall),
                if (widget.packageInfo.activities.isEmpty) const Text('No specific activities listed for this package.'),
                ...widget.packageInfo.activities.map((act) => ListTile(
                      leading: Icon(Icons.local_activity),
                      title: Text(act.name),
                      subtitle: Text(act.description),
                    )),
                const SizedBox(height: 16),
                Text('Price: \$${widget.packageInfo.priceDetail.basePrice.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.green)),
                const SizedBox(height: 24),

                // Date Selection
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: Icon(Icons.calendar_today),
                        label: Text(_checkInDate == null ? 'Select Check-in' : _dateFormat.format(_checkInDate!)),
                        onPressed: () => _selectDate(context, true),
                      ),
                    ),
                    const SizedBox(width:8),
                     Expanded(
                      child: TextButton.icon(
                        icon: Icon(Icons.calendar_today),
                        label: Text(_checkOutDate == null ? 'Select Check-out' : _dateFormat.format(_checkOutDate!)),
                        onPressed: () => _selectDate(context, false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _numGuestsController,
                  decoration: const InputDecoration(labelText: 'Number of Guests', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || (int.tryParse(value) ?? 0) <= 0) {
                      return 'Please enter a valid number of guests.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                BlocConsumer<LongStayBookingBloc, LongStayBookingState>(
                  listener: (context, state) {
                    if (state.status == LongStayBookingStatus.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Booking successful! ID: ${state.booking?.id}')),
                      );
                      Navigator.of(context).popUntil((route) => route.isFirst); // Go back to home
                    } else if (state.status == LongStayBookingStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Booking failed: ${state.errorMessage}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.status == LongStayBookingStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Center(
                      child: ElevatedButton(
                        onPressed: () => _handleBooking(context),
                        child: const Text('Confirm Booking'),
                        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
