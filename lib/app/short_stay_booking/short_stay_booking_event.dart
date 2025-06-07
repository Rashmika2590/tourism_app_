part of 'short_stay_booking_bloc.dart';

abstract class ShortStayBookingEvent extends Equatable {
  const ShortStayBookingEvent();
  @override
  List<Object> get props => [];
}

class CreateShortStayBookingRequested extends ShortStayBookingEvent {
  final String propertyId;
  final String userId; // Will get this from AuthBloc later
  final DateTime checkInDateTime; // For now, can be DateTime.now()
  final int durationHours;
  final double totalPrice;
  final String propertyName;
  final String propertyImageUrl;

  const CreateShortStayBookingRequested({
    required this.propertyId,
    required this.userId,
    required this.checkInDateTime,
    required this.durationHours,
    required this.totalPrice,
    required this.propertyName,
    required this.propertyImageUrl,
  });

  @override
  List<Object> get props => [propertyId, userId, checkInDateTime, durationHours, totalPrice, propertyName, propertyImageUrl];
}
