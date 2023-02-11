import 'package:Bootke/features/auth/domain/models/auth_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/enums/auth_failure.dart';
import 'auth_state_provider.dart';

final authFailureProvider = Provider<AuthFailure>((ref) {
  AuthFailure authFailure = ref.watch<AuthFailure>(
    authStateProvider.select(
      (AuthState authState) => authState.authFailure,
    ),
  );
  return authFailure;
});
