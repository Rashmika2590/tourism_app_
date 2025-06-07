import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/app/package/package_bloc.dart';
import 'package:tourism_app/data/models/models.dart';
import 'package:tourism_app/data/services/dummy_data_service.dart';
import 'package:tourism_app/presentation/widgets/package_card.dart';
import 'package:tourism_app/presentation/screens/long_stay/long_stay_booking_screen.dart'; // To be created

class LongStayPropertyDetailScreen extends StatelessWidget {
  final Property property;

  const LongStayPropertyDetailScreen({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PackageBloc(dummyDataService: context.read<DummyDataService>())
                          ..add(LoadPackagesRequested(propertyId: property.id)),
      child: Scaffold(
        appBar: AppBar(title: Text(property.propertyName)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Details Section (similar to ShortStayPropertyDetailScreen)
              if (property.propertyImage.primaryImageUrl.isNotEmpty)
                ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(property.propertyImage.primaryImageUrl, height: 250, width: double.infinity, fit: BoxFit.cover)),
              const SizedBox(height: 16),
              Text(property.propertyName, style: Theme.of(context).textTheme.headlineSmall),
              Text('${property.propertyType.name} in ${property.address.city}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(children: [Icon(Icons.star, color: Colors.amber), Text(' ${property.averageRating} (${property.reviewCount} reviews)')]),
              const SizedBox(height: 16),
              Text('Description:', style: Theme.of(context).textTheme.titleSmall),
              Text(property.description),
              const SizedBox(height: 16),
              Text('Amenities:', style: Theme.of(context).textTheme.titleSmall),
              Wrap(spacing: 8, children: property.amenities.map((a) => Chip(label: Text(a))).toList()),
              const SizedBox(height: 24),

              // Packages Section
              Text('Available Long Stay Packages:', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              BlocBuilder<PackageBloc, PackageState>(
                builder: (context, state) {
                  if (state.status == PackageStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == PackageStatus.failure) {
                    return Center(child: Text('Failed to load packages: ${state.errorMessage}'));
                  }
                  if (state.status == PackageStatus.success && state.packages.isEmpty) {
                    return const Center(child: Text('No long stay packages currently available for this property.'));
                  }
                  if (state.status == PackageStatus.success) {
                    return ListView.builder(
                      shrinkWrap: true, // Important for ListView inside SingleChildScrollView
                      physics: const NeverScrollableScrollPhysics(), // Disable scrolling for inner ListView
                      itemCount: state.packages.length,
                      itemBuilder: (context, index) {
                        final package = state.packages[index];
                        return PackageCard(
                          packageInfo: package,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => LongStayBookingScreen(property: property, packageInfo: package) // To be created
                            ));
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink(); // Should not happen if initial load is handled
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
