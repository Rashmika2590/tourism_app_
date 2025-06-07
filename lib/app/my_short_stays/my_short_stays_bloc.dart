import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tourism_app/data/models/models.dart';
import 'package:tourism_app/data/services/dummy_data_service.dart';

part 'my_short_stays_event.dart';
part 'my_short_stays_state.dart';

class MyShortStaysBloc extends Bloc<MyShortStaysEvent, MyShortStaysState> {
  final DummyDataService _dummyDataService;

  MyShortStaysBloc({required DummyDataService dummyDataService})
      : _dummyDataService = dummyDataService,
        super(const MyShortStaysState()) {
    on<LoadMyShortStaysRequested>(_onLoadMyShortStaysRequested);
  }

  Future<void> _onLoadMyShortStaysRequested(
      LoadMyShortStaysRequested event, Emitter<MyShortStaysState> emit) async {
    emit(state.copyWith(status: MyShortStaysStatus.loading));
    try {
      final bookings = await _dummyDataService.getShortStayBookingsForUser(event.userId);
      emit(state.copyWith(status: MyShortStaysStatus.success, bookings: bookings));
    } catch (e) {
      emit(state.copyWith(status: MyShortStaysStatus.failure, errorMessage: e.toString()));
    }
  }
}
