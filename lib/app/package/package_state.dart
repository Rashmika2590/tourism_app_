part of 'package_bloc.dart';

enum PackageStatus { initial, loading, success, failure }

class PackageState extends Equatable {
  final PackageStatus status;
  final List<PackageInfo> packages;
  final String? errorMessage;

  const PackageState({
    this.status = PackageStatus.initial,
    this.packages = const <PackageInfo>[],
    this.errorMessage,
  });

  PackageState copyWith({
    PackageStatus? status,
    List<PackageInfo>? packages,
    String? errorMessage,
  }) {
    return PackageState(
      status: status ?? this.status,
      packages: packages ?? this.packages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, packages, errorMessage];
}
