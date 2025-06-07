part of 'my_short_stays_bloc.dart';

abstract class MyShortStaysEvent extends Equatable {
  const MyShortStaysEvent();
  @override
  List<Object> get props => [];
}

class LoadMyShortStaysRequested extends MyShortStaysEvent {
  final String userId;
  const LoadMyShortStaysRequested({required this.userId});
  @override
  List<Object> get props => [userId];
}
