part of 'property_search_bloc.dart';

abstract class PropertySearchEvent extends Equatable {
  const PropertySearchEvent();
  @override
  List<Object?> get props => [];
}

class SearchPropertiesRequested extends PropertySearchEvent {
  final PackageType stayType; // To specify short or long stay search
  final String? city;
  final int? numOfGuests;
  final int? numOfHours; // Specific to short stay
  final DateTime? startDate; // New for long stay
  final DateTime? endDate; // New for long stay
  // Add other filters like date for long stay later if needed

  const SearchPropertiesRequested({
    required this.stayType,
    this.city,
    this.numOfGuests,
    this.numOfHours,
    this.startDate, // New
    this.endDate, // New
  });

  @override
  List<Object?> get props => [stayType, city, numOfGuests, numOfHours, startDate, endDate]; // Add new props
}
