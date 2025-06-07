import 'package:equatable/equatable.dart';

class PackagePriceDetailInfo extends Equatable {
  final double basePrice;
  final double? weekendPrice;
  final double? monthlyDiscount;
  final bool isWiFiIncluded;
  final double? wiFiPrice;
  final bool isParkingIncluded;
  final double? parkingPrice;

  const PackagePriceDetailInfo({
    required this.basePrice,
    this.weekendPrice,
    this.monthlyDiscount,
    this.isWiFiIncluded = false,
    this.wiFiPrice,
    this.isParkingIncluded = false,
    this.parkingPrice,
  });

  @override
  List<Object?> get props => [basePrice, weekendPrice, monthlyDiscount, isWiFiIncluded, wiFiPrice, isParkingIncluded, parkingPrice];
}
