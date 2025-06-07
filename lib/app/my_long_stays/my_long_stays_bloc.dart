import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tourism_app/data/models/models.dart';
import 'package:tourism_app/data/services/dummy_data_service.dart';

part 'my_long_stays_event.dart';
part 'my_long_stays_state.dart';

class MyLongStaysBloc extends Bloc<MyLongStaysEvent, MyLongStaysState> {
  final DummyDataService _dummyDataService;

  MyLongStaysBloc({required DummyDataService dummyDataService})
      : _dummyDataService = dummyDataService,
        super(const MyLongStaysState()) {
    on<LoadMyLongStaysRequested>(_onLoadMyLongStaysRequested);
  }

  Future<void> _onLoadMyLongStaysRequested(
      LoadMyLongStaysRequested event, Emitter<MyLongStaysState> emit) async {
    emit(state.copyWith(status: MyLongStaysStatus.loading));
    try {
      final bookings = await _dummyDataService.getLongStayBookingsForUser(event.userId);
      emit(state.copyWith(status: MyLongStaysStatus.success, bookings: bookings));
    } catch (e) {
      emit(state.copyWith(status: MyLongStaysStatus.failure, errorMessage: e.toString()));
    }
  }
}
