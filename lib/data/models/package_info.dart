import 'package:equatable/equatable.dart';
import 'package:tourism_app/data/models/enums/package_type_enum.dart'; // Adjust path
import 'package:tourism_app/data/models/property_image_info.dart'; // Using this for package images too
import 'package:tourism_app/data/models/package_price_detail_info.dart'; // Adjust path
import 'package:tourism_app/data/models/activity.dart'; // Adjust path


class PackageInfo extends Equatable {
  final String id;
  final String propertyId;
  final String packageName;
  final PackageType packageType;
  final PropertyImageInfo packageImage; // Reusing PropertyImageInfo for simplicity
  final PackagePriceDetailInfo priceDetail;
  final String description;
  final List<Activity> activities; // For long stay packages
  final int durationDays; // For long stay, e.g., 7 days

  const PackageInfo({
    required this.id,
    required this.propertyId,
    required this.packageName,
    required this.packageType,
    required this.packageImage,
    required this.priceDetail,
    required this.description,
    this.activities = const [],
    this.durationDays = 1,
  });

  @override
  List<Object?> get props => [id, propertyId, packageName, packageType, packageImage, priceDetail, description, activities, durationDays];
}
