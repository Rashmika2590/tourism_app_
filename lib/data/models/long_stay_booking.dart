import 'package:equatable/equatable.dart';
import 'package:tourism_app/data/models/enums/booking_status_enum.dart'; // Adjust path

class LongStayBooking extends Equatable {
  final String id;
  final String packageId;
  final String propertyId; // Denormalized
  final String userId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int noOfGuests;
  final double totalPrice;
  final BookingStatus status;
  final String packageName; // Denormalized
  final String propertyName; // Denormalized
  final String packageImageUrl; // Denormalized


  const LongStayBooking({
    required this.id,
    required this.packageId,
    required this.propertyId,
    required this.userId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.noOfGuests,
    required this.totalPrice,
    required this.status,
    required this.packageName,
    required this.propertyName,
    required this.packageImageUrl,
  });

  @override
  List<Object?> get props => [
                id, packageId, propertyId, userId, checkInDate, checkOutDate,
                noOfGuests, totalPrice, status, packageName, propertyName, packageImageUrl
              ];
}
