part of 'long_stay_booking_bloc.dart';

abstract class LongStayBookingEvent extends Equatable {
  const LongStayBookingEvent();
  @override
  List<Object> get props => [];
}

class CreateLongStayBookingRequested extends LongStayBookingEvent {
  final String packageId;
  final String propertyId;
  final String userId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int noOfGuests;
  final double totalPrice;
  // Denormalized data for creating the booking object in dummy service
  final String packageName;
  final String propertyName;
  final String packageImageUrl;


  const CreateLongStayBookingRequested({
    required this.packageId,
    required this.propertyId,
    required this.userId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.noOfGuests,
    required this.totalPrice,
    required this.packageName,
    required this.propertyName,
    required this.packageImageUrl,
  });

  @override
  List<Object> get props => [packageId, propertyId, userId, checkInDate, checkOutDate, noOfGuests, totalPrice, packageName, propertyName, packageImageUrl];
}
