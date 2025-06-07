import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tourism_app/data/models/models.dart';
import 'package:tourism_app/data/services/dummy_data_service.dart';

part 'package_event.dart';
part 'package_state.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  final DummyDataService _dummyDataService;

  PackageBloc({required DummyDataService dummyDataService})
      : _dummyDataService = dummyDataService,
        super(const PackageState()) {
    on<LoadPackagesRequested>(_onLoadPackagesRequested);
  }

  Future<void> _onLoadPackagesRequested(
      LoadPackagesRequested event, Emitter<PackageState> emit) async {
    emit(state.copyWith(status: PackageStatus.loading));
    try {
      // Filter only long stay packages, assuming DummyDataService returns all for property
      final allPackages = await _dummyDataService.getPackagesByPropertyId(event.propertyId);
      final longStayPackages = allPackages.where((pkg) => pkg.packageType == PackageType.longStay).toList();
      emit(state.copyWith(status: PackageStatus.success, packages: longStayPackages));
    } catch (e) {
      emit(state.copyWith(status: PackageStatus.failure, errorMessage: e.toString()));
    }
  }
}
