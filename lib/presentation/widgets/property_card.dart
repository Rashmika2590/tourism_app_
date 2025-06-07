// lib/presentation/widgets/property_card.dart
import 'package:flutter/material.dart';
import 'package:tourism_app/data/models/models.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (property.propertyImage.primaryImageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    property.propertyImage.primaryImageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(height: 150, color: Colors.grey[300], child: Icon(Icons.broken_image, size: 50)),
                  ),
                ),
              const SizedBox(height: 8),
              Text(property.propertyName, style: Theme.of(context).textTheme.titleLarge),
              Text('${property.propertyType.name} in ${property.address.city}', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              if (property.allowShortStays && property.pricePerHourShortStay != null)
                Text('\$${property.pricePerHourShortStay?.toStringAsFixed(2)} / hour', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.green)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(' ${property.averageRating.toStringAsFixed(1)} (${property.reviewCount} reviews)'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
