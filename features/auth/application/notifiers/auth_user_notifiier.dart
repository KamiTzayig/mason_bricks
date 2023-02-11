import 'dart:async';

import 'package:Bootke/features/auth/domain/models/auth_user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/firebase_auth_repository.dart';
import '../../domain/auth_repository.dart';

class AuthUserNotifier extends StateNotifier<AuthUser>{
  AuthUserNotifier() : super(AuthUser(userId: "", phoneNumber: "", fullName: ""));
  final AuthRepository _repository = AuthRepositoryFirebase();
  StreamSubscription? _authStateSubscription;

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  void authStateChanges (){
    _authStateSubscription = _repository.authStateChanges.listen((AuthUser authUser) {
      state = authUser;
    });
  }

}