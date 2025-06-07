import 'package:equatable/equatable.dart';

class PropertyImageInfo extends Equatable {
  final String primaryImageUrl;
  final List<String> secondaryImageUrls;

  const PropertyImageInfo({
    required this.primaryImageUrl,
    this.secondaryImageUrls = const [],
  });

  @override
  List<Object?> get props => [primaryImageUrl, secondaryImageUrls];
}
