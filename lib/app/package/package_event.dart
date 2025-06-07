part of 'package_bloc.dart';

abstract class PackageEvent extends Equatable {
  const PackageEvent();
  @override
  List<Object> get props => [];
}

class LoadPackagesRequested extends PackageEvent {
  final String propertyId;
  const LoadPackagesRequested({required this.propertyId});
  @override
  List<Object> get props => [propertyId];
}
