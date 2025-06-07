import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tourism_app/data/models/models.dart';
import 'package:tourism_app/data/services/dummy_data_service.dart';

part 'long_stay_booking_event.dart';
part 'long_stay_booking_state.dart';

class LongStayBookingBloc extends Bloc<LongStayBookingEvent, LongStayBookingState> {
  final DummyDataService _dummyDataService;

  LongStayBookingBloc({required DummyDataService dummyDataService})
      : _dummyDataService = dummyDataService,
        super(const LongStayBookingState()) {
    on<CreateLongStayBookingRequested>(_onCreateLongStayBookingRequested);
  }

  Future<void> _onCreateLongStayBookingRequested(
      CreateLongStayBookingRequested event, Emitter<LongStayBookingState> emit) async {
    emit(state.copyWith(status: LongStayBookingStatus.loading));
    try {
      final newBooking = await _dummyDataService.createLongStayBooking(
        packageId: event.packageId,
        propertyId: event.propertyId,
        userId: event.userId,
        checkInDate: event.checkInDate,
        checkOutDate: event.checkOutDate,
        noOfGuests: event.noOfGuests,
        totalPrice: event.totalPrice,
        packageName: event.packageName,
        propertyName: event.propertyName,
        packageImageUrl: event.packageImageUrl,
      );
      emit(state.copyWith(status: LongStayBookingStatus.success, booking: newBooking));
    } catch (e) {
      emit(state.copyWith(status: LongStayBookingStatus.failure, errorMessage: e.toString()));
    }
  }
}
