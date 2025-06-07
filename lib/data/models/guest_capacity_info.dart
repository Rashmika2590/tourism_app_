import 'package:equatable/equatable.dart';

class GuestCapacityInfo extends Equatable {
  // final GuestTypeEnum guestType; // API has this, can add if needed
  final int maxGuests;
  final String description; // e.g., "Adults", "Children"

  const GuestCapacityInfo({required this.maxGuests, required this.description});

  @override
  List<Object?> get props => [maxGuests, description];
}
