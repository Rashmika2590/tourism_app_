part of 'short_stay_booking_bloc.dart';

enum ShortStayBookingStatus { initial, loading, success, failure }

class ShortStayBookingState extends Equatable {
  final ShortStayBookingStatus status;
  final ShortStayBooking? booking;
  final String? errorMessage;

  const ShortStayBookingState({
    this.status = ShortStayBookingStatus.initial,
    this.booking,
    this.errorMessage,
  });

  ShortStayBookingState copyWith({
    ShortStayBookingStatus? status,
    ShortStayBooking? booking,
    String? errorMessage,
  }) {
    return ShortStayBookingState(
      status: status ?? this.status,
      booking: booking ?? this.booking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, booking, errorMessage];
}
