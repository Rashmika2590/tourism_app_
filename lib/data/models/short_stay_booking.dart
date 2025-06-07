import 'package:equatable/equatable.dart';
import 'package:tourism_app/data/models/enums/booking_status_enum.dart'; // Adjust path

class ShortStayBooking extends Equatable {
  final String id;
  final String propertyId;
  final String userId;
  final DateTime checkInDateTime;
  final int durationHours;
  final double totalPrice;
  final BookingStatus status;
  final String propertyName; // Denormalized for easy display
  final String propertyImageUrl; // Denormalized

  const ShortStayBooking({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.checkInDateTime,
    required this.durationHours,
    required this.totalPrice,
    required this.status,
    required this.propertyName,
    required this.propertyImageUrl,
  });

  @override
  List<Object?> get props => [id, propertyId, userId, checkInDateTime, durationHours, totalPrice, status, propertyName, propertyImageUrl];
}
