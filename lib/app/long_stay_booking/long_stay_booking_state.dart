part of 'long_stay_booking_bloc.dart';

enum LongStayBookingStatus { initial, loading, success, failure }

class LongStayBookingState extends Equatable {
  final LongStayBookingStatus status;
  final LongStayBooking? booking;
  final String? errorMessage;

  const LongStayBookingState({
    this.status = LongStayBookingStatus.initial,
    this.booking,
    this.errorMessage,
  });

  LongStayBookingState copyWith({
    LongStayBookingStatus? status,
    LongStayBooking? booking,
    String? errorMessage,
  }) {
    return LongStayBookingState(
      status: status ?? this.status,
      booking: booking ?? this.booking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, booking, errorMessage];
}
