import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:tourism_app/app/property_search/property_search_bloc.dart';
import 'package:tourism_app/data/models/models.dart';
import 'package:tourism_app/data/services/dummy_data_service.dart';
import 'package:tourism_app/presentation/widgets/property_card.dart';
import 'package:tourism_app/presentation/screens/long_stay/long_stay_property_detail_screen.dart'; // To be created

class LongStaySearchScreen extends StatefulWidget {
  const LongStaySearchScreen({Key? key}) : super(key: key);

  static const String routeName = '/long-stay-search';
  static Route route() => MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => PropertySearchBloc(dummyDataService: context.read<DummyDataService>())
                              ..add(const SearchPropertiesRequested(stayType: PackageType.longStay)), // Initial load for long stays
          child: const LongStaySearchScreen(),
        ),
        settings: RouteSettings(name: routeName),
      );

  @override
  State<LongStaySearchScreen> createState() => _LongStaySearchScreenState();
}

class _LongStaySearchScreenState extends State<LongStaySearchScreen> {
  final _cityController = TextEditingController();
  final _guestsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: isStartDate ? 0 : -30)), // Allow past end date for selection flexibility
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null; // Reset end date if it's before new start date
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _performSearch() {
    final guests = int.tryParse(_guestsController.text);
    context.read<PropertySearchBloc>().add(SearchPropertiesRequested(
          stayType: PackageType.longStay,
          city: _cityController.text.isEmpty ? null : _cityController.text,
          numOfGuests: guests,
          startDate: _startDate,
          endDate: _endDate,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Long Stay')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City (e.g., Metropolis)'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: Icon(Icons.calendar_today),
                        label: Text(_startDate == null ? 'Select Start Date' : _dateFormat.format(_startDate!)),
                        onPressed: () => _selectDate(context, true),
                      ),
                    ),
                    const SizedBox(width:8),
                     Expanded(
                      child: TextButton.icon(
                        icon: Icon(Icons.calendar_today),
                        label: Text(_endDate == null ? 'Select End Date' : _dateFormat.format(_endDate!)),
                        onPressed: () => _selectDate(context, false),
                      ),
                    ),
                  ],
                ),
                 if (_startDate != null && _endDate != null && _endDate!.isBefore(_startDate!))
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('End date must be after start date.', style: TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 8),
                TextField(
                  controller: _guestsController,
                  decoration: const InputDecoration(labelText: 'Number of Guests (e.g., 2)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: (_startDate != null && _endDate != null && _endDate!.isBefore(_startDate!)) ? null : _performSearch,
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
                  // Filter further to ensure only properties allowing long stays are shown
                  final longStayProperties = state.properties.where((p) => p.allowLongStays).toList();
                  if (longStayProperties.isEmpty) {
                    return const Center(child: Text('No properties found allowing long stays for your criteria.'));
                  }
                  return ListView.builder(
                    itemCount: longStayProperties.length,
                    itemBuilder: (context, index) {
                      final property = longStayProperties[index];
                      return PropertyCard( // Reusing PropertyCard
                        property: property,
                        onTap: () {
                           Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => LongStayPropertyDetailScreen(property: property) // To be created
                          ));
                        },
                      );
                    },
                  );
                }
                return const Center(child: Text('Enter criteria and search.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
