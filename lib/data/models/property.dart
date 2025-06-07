import 'package:equatable/equatable.dart';
import 'package:tourism_app/data/models/enums/property_type_enum.dart'; // Adjust path
import 'package:tourism_app/data/models/enums/property_availability_enum.dart'; // Adjust path
import 'package:tourism_app/data/models/enums/guest_stay_type_enum.dart'; // Adjust path
import 'package:tourism_app/data/models/address_info.dart'; // Adjust path
import 'package:tourism_app/data/models/property_image_info.dart'; // Adjust path
import 'package:tourism_app/data/models/guest_capacity_info.dart'; // Adjust path
import 'package:tourism_app/data/models/package_info.dart'; // Adjust path

class Property extends Equatable {
  final String id;
  final String propertyName;
  final PropertyType propertyType;
  final PropertyAvailability availability;
  final bool allowShortStays;
  final bool allowLongStays;
  // final UserRoleEnum userRole; // From API, not needed for client app's property model
  final int? numOfHoursForShortStay; // if allowShortStays is true
  final double? pricePerHourShortStay; // Added for dummy data
  final GuestStayType guestStayType;
  final AddressInfo address;
  final PropertyImageInfo propertyImage;
  final List<GuestCapacityInfo> guestCapacities;
  final String description;
  final List<String> amenities;
  final double averageRating;
  final int reviewCount;
  final List<PackageInfo> packages; // For long stays

  const Property({
    required this.id,
    required this.propertyName,
    required this.propertyType,
    this.availability = PropertyAvailability.available,
    required this.allowShortStays,
    required this.allowLongStays,
    this.numOfHoursForShortStay,
    this.pricePerHourShortStay,
    this.guestStayType = GuestStayType.any,
    required this.address,
    required this.propertyImage,
    this.guestCapacities = const [],
    required this.description,
    this.amenities = const [],
    this.averageRating = 0.0,
    this.reviewCount = 0,
    this.packages = const [],
  });

  @override
  List<Object?> get props => [
                id, propertyName, propertyType, availability, allowShortStays, allowLongStays,
                numOfHoursForShortStay, pricePerHourShortStay, guestStayType, address, propertyImage,
                guestCapacities, description, amenities, averageRating, reviewCount, packages
              ];
}
