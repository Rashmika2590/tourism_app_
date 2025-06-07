import 'package:equatable/equatable.dart';

class AddressInfo extends Equatable {
  final String? no;
  final String? street;
  final String city;
  final String? province;
  final String? country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;

  const AddressInfo({
    this.no,
    this.street,
    required this.city,
    this.province,
    this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [no, street, city, province, country, postalCode, latitude, longitude];
}
