part of 'my_long_stays_bloc.dart';

abstract class MyLongStaysEvent extends Equatable {
  const MyLongStaysEvent();
  @override
  List<Object> get props => [];
}

class LoadMyLongStaysRequested extends MyLongStaysEvent {
  final String userId;
  const LoadMyLongStaysRequested({required this.userId});
  @override
  List<Object> get props => [userId];
}
