// lib/presentation/widgets/package_card.dart
import 'package:flutter/material.dart';
import 'package:tourism_app/data/models/models.dart';

class PackageCard extends StatelessWidget {
  final PackageInfo packageInfo;
  final VoidCallback onTap;

  const PackageCard({
    Key? key,
    required this.packageInfo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (packageInfo.packageImage.primaryImageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    packageInfo.packageImage.primaryImageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                     errorBuilder: (context, error, stackTrace) =>
                        Container(height: 120, color: Colors.grey[300], child: Icon(Icons.broken_image, size: 40)),
                  ),
                ),
              const SizedBox(height: 8),
              Text(packageInfo.packageName, style: Theme.of(context).textTheme.titleLarge),
              Text('${packageInfo.durationDays} days', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(packageInfo.description, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text('\$${packageInfo.priceDetail.basePrice.toStringAsFixed(2)}',
                   style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}
