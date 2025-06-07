part of 'my_long_stays_bloc.dart';

enum MyLongStaysStatus { initial, loading, success, failure }

class MyLongStaysState extends Equatable {
  final MyLongStaysStatus status;
  final List<LongStayBooking> bookings;
  final String? errorMessage;

  const MyLongStaysState({
    this.status = MyLongStaysStatus.initial,
    this.bookings = const <LongStayBooking>[],
    this.errorMessage,
  });

  MyLongStaysState copyWith({
    MyLongStaysStatus? status,
    List<LongStayBooking>? bookings,
    String? errorMessage,
  }) {
    return MyLongStaysState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, bookings, errorMessage];
}
