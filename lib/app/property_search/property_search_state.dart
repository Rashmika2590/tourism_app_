part of 'property_search_bloc.dart';

enum PropertySearchStatus { initial, loading, success, failure }

class PropertySearchState extends Equatable {
  final PropertySearchStatus status;
  final List<Property> properties;
  final String? errorMessage;

  const PropertySearchState({
    this.status = PropertySearchStatus.initial,
    this.properties = const <Property>[],
    this.errorMessage,
  });

  PropertySearchState copyWith({
    PropertySearchStatus? status,
    List<Property>? properties,
    String? errorMessage,
  }) {
    return PropertySearchState(
      status: status ?? this.status,
      properties: properties ?? this.properties,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, properties, errorMessage];
}
