import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tourism_app/data/models/models.dart'; // Barrel file
import 'package:tourism_app/data/services/dummy_data_service.dart'; // Adjust path

part 'property_search_event.dart';
part 'property_search_state.dart';

class PropertySearchBloc extends Bloc<PropertySearchEvent, PropertySearchState> {
  final DummyDataService _dummyDataService;

  PropertySearchBloc({required DummyDataService dummyDataService})
      : _dummyDataService = dummyDataService,
        super(const PropertySearchState()) {
    on<SearchPropertiesRequested>(_onSearchPropertiesRequested);
  }

  Future<void> _onSearchPropertiesRequested(
      SearchPropertiesRequested event, Emitter<PropertySearchState> emit) async {
    emit(state.copyWith(status: PropertySearchStatus.loading));
    try {
      final properties = await _dummyDataService.getProperties(
        stayType: event.stayType,
        city: event.city,
        numOfGuests: event.numOfGuests,
                numOfHours: event.numOfHours,
                date: event.startDate, // Using 'date' parameter of getProperties for startDate for now
                                       // DummyDataService.getProperties might need adjustment if complex date range logic is required.
                                       // For now, it just checks if allowLongStays is true if a date is provided.
      );
      emit(state.copyWith(status: PropertySearchStatus.success, properties: properties));
    } catch (e) {
      emit(state.copyWith(status: PropertySearchStatus.failure, errorMessage: e.toString()));
    }
  }
}
