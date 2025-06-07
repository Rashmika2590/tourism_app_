// lib/data/services/dummy_data_service.dart
import 'package:tourism_app/data/models/models.dart'; // Assuming models.dart exports all models
import 'package:uuid/uuid.dart'; // For generating unique IDs for dummy data

// Barrel file for models (create this if it doesn't exist)
// lib/data/models/models.dart
/*
export 'enums/property_type_enum.dart';
export 'enums/package_type_enum.dart';
export 'enums/guest_stay_type_enum.dart';
export 'enums/property_availability_enum.dart';
export 'enums/booking_status_enum.dart';
export 'address_info.dart';
export 'property_image_info.dart';
export 'guest_capacity_info.dart';
export 'activity.dart';
export 'package_price_detail_info.dart';
export 'package_info.dart';
export 'property.dart';
export 'short_stay_booking.dart';
export 'long_stay_booking.dart';
export 'user_profile.dart';
*/

class DummyDataService {
  final Uuid _uuid = Uuid();
  late List<Property> _properties;
  late List<PackageInfo> _packages;
  late List<Activity> _activities;
  final List<ShortStayBooking> _shortStayBookings = [];
  final List<LongStayBooking> _longStayBookings = [];

  DummyDataService() {
    _generateDummyData();
  }

  void _generateDummyData() {
    _activities = [
      Activity(id: _uuid.v4(), name: 'Guided City Tour', description: 'Explore the city highlights with a local guide.', imageUrl: 'https://picsum.photos/seed/citytour/300/200'),
      Activity(id: _uuid.v4(), name: 'Cooking Class', description: 'Learn to cook local delicacies.', imageUrl: 'https://picsum.photos/seed/cooking/300/200'),
      Activity(id: _uuid.v4(), name: 'Beach Yoga', description: 'Morning yoga session by the beach.', imageUrl: 'https://picsum.photos/seed/yoga/300/200'),
      Activity(id: _uuid.v4(), name: 'Snorkeling Trip', description: 'Discover underwater marine life.', imageUrl: 'https://picsum.photos/seed/snorkeling/300/200'),
      Activity(id: _uuid.v4(), name: 'Mountain Hiking', description: 'Scenic hike through mountain trails.', imageUrl: 'https://picsum.photos/seed/hiking/300/200'),
    ];

    _packages = [
      // Packages for Property 1 (ID: 'prop1') - Long Stays
      PackageInfo(
          id: _uuid.v4(), propertyId: 'prop1', packageName: 'Weekend Getaway', packageType: PackageType.longStay, durationDays: 3,
          packageImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/pkg1/400/300', secondaryImageUrls: ['https://picsum.photos/seed/pkg1_1/300/200']),
          priceDetail: const PackagePriceDetailInfo(basePrice: 250, weekendPrice: 280, isWiFiIncluded: true),
          description: 'A relaxing 3-day weekend stay with complimentary breakfast.', activities: [_activities[0], _activities[1]]),
      PackageInfo(
          id: _uuid.v4(), propertyId: 'prop1', packageName: 'Full Week Retreat', packageType: PackageType.longStay, durationDays: 7,
          packageImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/pkg2/400/300'),
          priceDetail: const PackagePriceDetailInfo(basePrice: 550, monthlyDiscount: 50, isParkingIncluded: true, parkingPrice: 0),
          description: 'Enjoy a full week of peace and exploration.', activities: [_activities[0], _activities[1], _activities[2]]),

      // Packages for Property 3 (ID: 'prop3') - Long Stays
       PackageInfo(
          id: _uuid.v4(), propertyId: 'prop3', packageName: 'Adventure Seeker', packageType: PackageType.longStay, durationDays: 5,
          packageImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/pkg3/400/300'),
          priceDetail: const PackagePriceDetailInfo(basePrice: 700, isWiFiIncluded: true),
          description: '5 days of thrilling activities and comfortable stay.', activities: [_activities[3], _activities[4]]),
    ];

    // Add dummy packages for short stays if needed, or handle short stays without explicit packages
    // For now, short stays are handled by properties directly if allowShortStays = true

    _properties = [
      Property(
        id: 'prop1', propertyName: 'Grand City Hotel', propertyType: PropertyType.hotel,
        address: const AddressInfo(city: 'Metropolis', street: '123 Main St', country: 'Wonderland', latitude: 34.0522, longitude: -118.2437),
        propertyImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/hotel1/600/400', secondaryImageUrls: ['https://picsum.photos/seed/hotel1_1/300/200', 'https://picsum.photos/seed/hotel1_2/300/200']),
        allowShortStays: true, numOfHoursForShortStay: 3, pricePerHourShortStay: 25.0,
        allowLongStays: true, packages: _packages.where((p) => p.propertyId == 'prop1').toList(),
        description: 'A luxurious hotel in the heart of the city, offering world-class amenities and comfort.',
        amenities: ['WiFi', 'Pool', 'Gym', 'Restaurant', 'Parking'], averageRating: 4.5, reviewCount: 120,
        guestCapacities: [const GuestCapacityInfo(maxGuests: 2, description: 'Standard Room'), const GuestCapacityInfo(maxGuests: 4, description: 'Family Suite')],
        availability: PropertyAvailability.available, guestStayType: GuestStayType.any
      ),
      Property(
        id: 'prop2', propertyName: 'Seaside Villa', propertyType: PropertyType.villa,
        address: const AddressInfo(city: 'Coastline City', street: '45 Beach Rd', country: 'Wonderland', latitude: 33.9000, longitude: -118.4000),
        propertyImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/villa1/600/400', secondaryImageUrls: ['https://picsum.photos/seed/villa1_1/300/200']),
        allowShortStays: false, // This villa is only for long stays
        allowLongStays: true, packages: [ /* Add specific packages for prop2 if any, or leave empty if managed globally */ ],
        description: 'A beautiful villa with stunning ocean views. Perfect for a getaway.',
        amenities: ['WiFi', 'Private Pool', 'Kitchen', 'Beach Access'], averageRating: 4.8, reviewCount: 85,
        guestCapacities: [const GuestCapacityInfo(maxGuests: 6, description: 'Entire Villa')],
        availability: PropertyAvailability.onRequest, guestStayType: GuestStayType.family
      ),
      Property(
        id: 'prop3', propertyName: 'Mountain Lodge', propertyType: PropertyType.chalet,
        address: const AddressInfo(city: 'Hilltop Town', street: '789 Summit Trail', country: 'Wonderland', latitude: 34.1500, longitude: -118.5000),
        propertyImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/lodge1/600/400'),
        allowShortStays: true, numOfHoursForShortStay: 4, pricePerHourShortStay: 20.0,
        allowLongStays: true, packages: _packages.where((p) => p.propertyId == 'prop3').toList(),
        description: 'Cozy lodge with breathtaking mountain scenery. Ideal for nature lovers.',
        amenities: ['WiFi', 'Fireplace', 'Hiking Trails', 'Pet-friendly'], averageRating: 4.3, reviewCount: 60,
        availability: PropertyAvailability.limited, guestStayType: GuestStayType.any
      ),
      // Add 7 more properties to reach ~10
      Property(
        id: 'prop4', propertyName: 'Urban Apartment', propertyType: PropertyType.apartment,
        address: const AddressInfo(city: 'Metropolis', street: '202 High Rise Ave', country: 'Wonderland'),
        propertyImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/apt1/600/400'),
        allowShortStays: true, numOfHoursForShortStay: 2, pricePerHourShortStay: 30.0,
        allowLongStays: false,
        description: 'Modern apartment in downtown, close to attractions.',
        amenities: ['WiFi', 'Kitchenette', 'Gym Access'], averageRating: 4.1, reviewCount: 45
      ),
      Property(
        id: 'prop5', propertyName: 'Quiet Homestay', propertyType: PropertyType.homestay,
        address: const AddressInfo(city: 'Suburbia', street: '15 Maple Drive', country: 'Wonderland'),
        propertyImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/home1/600/400'),
        allowShortStays: false,
        allowLongStays: true, packages: [], // Assuming simple homestay might not have complex packages
        description: 'Experience local life in a comfortable and quiet homestay.',
        amenities: ['WiFi', 'Home-cooked meals option'], averageRating: 4.9, reviewCount: 30
      ),
      Property(
        id: 'prop6', propertyName: 'Luxury Resort & Spa', propertyType: PropertyType.resort,
        address: const AddressInfo(city: 'Paradise Island', street: '1 Resort Blvd', country: 'Wonderland'),
        propertyImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/resort1/600/400'),
        allowShortStays: true, numOfHoursForShortStay: 5, pricePerHourShortStay: 50.0,
        allowLongStays: true, packages: [ /* Add specific packages for prop6 */ ],
        description: 'Indulge in luxury with our all-inclusive resort and spa.',
        amenities: ['WiFi', 'Multiple Pools', 'Spa', 'Restaurants', 'Kids Club'], averageRating: 4.7, reviewCount: 250
      ),
      Property(
        id: 'prop7', propertyName: 'Budget Hostel Central', propertyType: PropertyType.hostel,
        address: const AddressInfo(city: 'Metropolis', street: '77 Backpacker Ln', country: 'Wonderland'),
        propertyImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/hostel1/600/400'),
        allowShortStays: true, numOfHoursForShortStay: 0, pricePerHourShortStay: 10.0, // Price per night effectively for hostels
        allowLongStays: true, packages: [],
        description: 'Affordable and centrally located hostel for travelers.',
        amenities: ['WiFi', 'Shared Kitchen', 'Lockers'], averageRating: 3.9, reviewCount: 180
      ),
       Property(
        id: 'prop8', propertyName: 'Riverside Cottage', propertyType: PropertyType.cottage,
        address: const AddressInfo(city: 'Riverbend Village', street: '33 Willow Creek Rd', country: 'Wonderland'),
        propertyImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/cottage1/600/400'),
        allowShortStays: false,
        allowLongStays: true, packages: [ /* Add specific packages */ ],
        description: 'Charming cottage by the river, perfect for a peaceful retreat.',
        amenities: ['WiFi', 'Kitchen', 'Fishing Gear', 'Patio'], averageRating: 4.6, reviewCount: 70
      ),
      Property(
        id: 'prop9', propertyName: 'Downtown Guest House', propertyType: PropertyType.guestHouse,
        address: const AddressInfo(city: 'Metropolis', street: '500 Central Ave', country: 'Wonderland'),
        propertyImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/guest1/600/400'),
        allowShortStays: true, numOfHoursForShortStay: 3, pricePerHourShortStay: 22.0,
        allowLongStays: true, packages: [],
        description: 'Comfortable guest house with easy access to city center.',
        amenities: ['WiFi', 'Breakfast Included', 'Shared Lounge'], averageRating: 4.2, reviewCount: 95
      ),
      Property(
        id: 'prop10', propertyName: 'Eco Pod Retreat', propertyType: PropertyType.other, // Using 'other' for unique type
        address: const AddressInfo(city: 'Wilderness Area', street: '1 Nature Path', country: 'Wonderland'),
        propertyImage: const PropertyImageInfo(primaryImageUrl: 'https://picsum.photos/seed/eco1/600/400'),
        allowShortStays: false,
        allowLongStays: true, packages: [ /* Add specific eco packages */ ],
        description: 'Unique eco-friendly pods offering an off-grid experience.',
        amenities: ['Solar Power', 'Composting Toilet', 'Nature Trails'], averageRating: 4.9, reviewCount: 40
      ),
    ];
  }

  // --- Property Methods ---
  Future<List<Property>> getProperties({
      PackageType? stayType, // Corresponds to API's PackageTypeEnum
      String? city,
      int? numOfGuests, // Simplified: any property that can host this many
      int? numOfHours, // For short stay
      DateTime? date, // For long stay availability (simplified)
  }) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    List<Property> filtered = List.from(_properties);

    if (stayType != null) {
        filtered = filtered.where((p) =>
            (stayType == PackageType.shortStay && p.allowShortStays) ||
            (stayType == PackageType.longStay && p.allowLongStays)
        ).toList();
    }
    if (city != null && city.isNotEmpty) {
        filtered = filtered.where((p) => p.address.city.toLowerCase().contains(city.toLowerCase())).toList();
    }
    if (numOfGuests != null && numOfGuests > 0) {
        filtered = filtered.where((p) {
            if (p.guestCapacities.isNotEmpty) {
                return p.guestCapacities.any((gc) => gc.maxGuests >= numOfGuests);
            }
            return true; // Default if no capacity info
        }).toList();
    }
     if (stayType == PackageType.shortStay && numOfHours != null && numOfHours > 0) {
        filtered = filtered.where((p) => p.numOfHoursForShortStay != null && p.numOfHoursForShortStay! >= numOfHours).toList();
    }
    // Simplified date check for long stays - just check if it allows long stays
    if (stayType == PackageType.longStay && date != null) {
         filtered = filtered.where((p) => p.allowLongStays).toList();
    }

    return filtered;
  }

  Future<Property?> getPropertyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _properties.firstWhere((prop) => prop.id == id);
    } catch (e) {
      return null;
    }
  }

  // --- Package Methods ---
  Future<List<PackageInfo>> getPackagesByPropertyId(String propertyId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _packages.where((pkg) => pkg.propertyId == propertyId).toList();
  }

  Future<PackageInfo?> getPackageById(String packageId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _packages.firstWhere((pkg) => pkg.id == packageId);
    } catch (e) {
      return null;
    }
  }

  // --- Booking Methods (Simulated) ---
  Future<ShortStayBooking> createShortStayBooking({
    required String propertyId,
    required String userId,
    required DateTime checkInDateTime,
    required int durationHours,
    required double totalPrice,
    required String propertyName, // Denormalized
    required String propertyImageUrl, // Denormalized
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final booking = ShortStayBooking(
      id: _uuid.v4(),
      propertyId: propertyId,
      userId: userId,
      checkInDateTime: checkInDateTime,
      durationHours: durationHours,
      totalPrice: totalPrice,
      status: BookingStatus.confirmed, // Default to confirmed for dummy
      propertyName: propertyName,
      propertyImageUrl: propertyImageUrl,
    );
    _shortStayBookings.add(booking);
    return booking;
  }

  Future<LongStayBooking> createLongStayBooking({
    required String packageId,
    required String propertyId,
    required String userId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int noOfGuests,
    required double totalPrice,
    required String packageName, // Denormalized
    required String propertyName, // Denormalized
    required String packageImageUrl, // Denormalized
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final booking = LongStayBooking(
      id: _uuid.v4(),
      packageId: packageId,
      propertyId: propertyId,
      userId: userId,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      noOfGuests: noOfGuests,
      totalPrice: totalPrice,
      status: BookingStatus.confirmed, // Default to confirmed
      packageName: packageName,
      propertyName: propertyName,
      packageImageUrl: packageImageUrl,
    );
    _longStayBookings.add(booking);
    return booking;
  }

  Future<List<ShortStayBooking>> getShortStayBookingsForUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _shortStayBookings.where((b) => b.userId == userId).toList();
  }

  Future<List<LongStayBooking>> getLongStayBookingsForUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _longStayBookings.where((b) => b.userId == userId).toList();
  }
}
