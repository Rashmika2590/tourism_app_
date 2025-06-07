part of 'my_short_stays_bloc.dart';

enum MyShortStaysStatus { initial, loading, success, failure }

class MyShortStaysState extends Equatable {
  final MyShortStaysStatus status;
  final List<ShortStayBooking> bookings;
  final String? errorMessage;

  const MyShortStaysState({
    this.status = MyShortStaysStatus.initial,
    this.bookings = const <ShortStayBooking>[],
    this.errorMessage,
  });

  MyShortStaysState copyWith({
    MyShortStaysStatus? status,
    List<ShortStayBooking>? bookings,
    String? errorMessage,
  }) {
    return MyShortStaysState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bookings, errorMessage];
}
