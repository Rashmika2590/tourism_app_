// lib/presentation/widgets/long_stay_booking_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tourism_app/data/models/models.dart';

class LongStayBookingCard extends StatelessWidget {
  final LongStayBooking booking;

  const LongStayBookingCard({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            if (booking.packageImageUrl.isNotEmpty) // Assuming packageImageUrl from denormalized data
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  booking.packageImageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(width: 100, height: 100, color: Colors.grey[300], child: Icon(Icons.broken_image, size: 40)),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.packageName, style: Theme.of(context).textTheme.titleMedium),
                  Text('Property: ${booking.propertyName}', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text('Check-in: ${dateFormat.format(booking.checkInDate)}'),
                  Text('Check-out: ${dateFormat.format(booking.checkOutDate)}'),
                  Text('Guests: ${booking.noOfGuests}'),
                  Text('Total Price: \$${booking.totalPrice.toStringAsFixed(2)}'),
                  const SizedBox(height: 4),
                  Text('Status: ${booking.status.name}',
                       style: TextStyle(color: booking.status == BookingStatus.confirmed ? Colors.green : Colors.orange)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
