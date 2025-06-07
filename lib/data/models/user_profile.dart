import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final bool isAnonymous;

  const UserProfile({
    required this.uid,
    this.email,
    this.displayName,
    required this.isAnonymous,
  });

  // Factory constructor to create from Firebase User
  factory UserProfile.fromFirebaseUser(dynamic firebaseUser) { // Use dynamic or User from firebase_auth
    return UserProfile(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      isAnonymous: firebaseUser.isAnonymous,
    );
  }

  @override
  List<Object?> get props => [uid, email, displayName, isAnonymous];
}
