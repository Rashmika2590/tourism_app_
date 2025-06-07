import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tourism_app/data/models/models.dart';
import 'package:tourism_app/data/services/dummy_data_service.dart';

part 'short_stay_booking_event.dart';
part 'short_stay_booking_state.dart';

class ShortStayBookingBloc extends Bloc<ShortStayBookingEvent, ShortStayBookingState> {
  final DummyDataService _dummyDataService;

  ShortStayBookingBloc({required DummyDataService dummyDataService})
      : _dummyDataService = dummyDataService,
        super(const ShortStayBookingState()) {
    on<CreateShortStayBookingRequested>(_onCreateShortStayBookingRequested);
  }

  Future<void> _onCreateShortStayBookingRequested(
      CreateShortStayBookingRequested event, Emitter<ShortStayBookingState> emit) async {
    emit(state.copyWith(status: ShortStayBookingStatus.loading));
    try {
      final newBooking = await _dummyDataService.createShortStayBooking(
        propertyId: event.propertyId,
        userId: event.userId,
        checkInDateTime: event.checkInDateTime,
        durationHours: event.durationHours,
        totalPrice: event.totalPrice,
        propertyName: event.propertyName,
        propertyImageUrl: event.propertyImageUrl,
      );
      emit(state.copyWith(status: ShortStayBookingStatus.success, booking: newBooking));
    } catch (e) {
      emit(state.copyWith(status: ShortStayBookingStatus.failure, errorMessage: e.toString()));
    }
  }
}
