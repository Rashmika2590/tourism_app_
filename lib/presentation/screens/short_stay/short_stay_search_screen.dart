import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/app/property_search/property_search_bloc.dart';
import 'package:tourism_app/data/models/models.dart';
import 'package:tourism_app/data/services/dummy_data_service.dart'; // For BLoC provider
import 'package:tourism_app/presentation/widgets/property_card.dart'; // To be created
import 'package:tourism_app/presentation/screens/short_stay/short_stay_property_detail_screen.dart'; // To be created

class ShortStaySearchScreen extends StatefulWidget {
  const ShortStaySearchScreen({Key? key}) : super(key: key);

  static const String routeName = '/short-stay-search';
  static Route route() => MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => PropertySearchBloc(dummyDataService: context.read<DummyDataService>())
                              ..add(const SearchPropertiesRequested(stayType: PackageType.shortStay)), // Initial load
          child: const ShortStaySearchScreen(),
        ),
        settings: RouteSettings(name: routeName),
      );

  @override
  State<ShortStaySearchScreen> createState() => _ShortStaySearchScreenState();
}

class _ShortStaySearchScreenState extends State<ShortStaySearchScreen> {
  final _cityController = TextEditingController();
  final _hoursController = TextEditingController();

  void _performSearch() {
    final hours = int.tryParse(_hoursController.text);
    context.read<PropertySearchBloc>().add(SearchPropertiesRequested(
          stayType: PackageType.shortStay,
          city: _cityController.text.isEmpty ? null : _cityController.text,
          numOfHours: hours,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Short Stay')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City (e.g., Metropolis)', hintText: 'Enter city name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _hoursController,
                  decoration: const InputDecoration(labelText: 'Minimum Hours (e.g., 3)', hintText: 'Enter desired hours'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _performSearch,
                  child: const Text('Search Properties'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<PropertySearchBloc, PropertySearchState>(
              builder: (context, state) {
                if (state.status == PropertySearchStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == PropertySearchStatus.failure) {
                  return Center(child: Text('Failed to load properties: ${state.errorMessage}'));
                }
                if (state.status == PropertySearchStatus.success && state.properties.isEmpty) {
                  return const Center(child: Text('No properties found for your criteria.'));
                }
                if (state.status == PropertySearchStatus.success) {
                  return ListView.builder(
                    itemCount: state.properties.length,
                    itemBuilder: (context, index) {
                      final property = state.properties[index];
                      return PropertyCard(
                        property: property,
                        onTap: () {
                           Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => BlocProvider.value( // Pass existing BLoC if needed or create new for detail
                                value: BlocProvider.of<PropertySearchBloc>(context), // Example, might not be needed
                                child: ShortStayPropertyDetailScreen(property: property),
                              )
                          ));
                        },
                      );
                    },
                  );
                }
                return const Center(child: Text('Enter criteria and search.')); // Initial state
              },
            ),
          ),
        ],
      ),
    );
  }
}
