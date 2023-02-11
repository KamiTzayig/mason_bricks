import '../../domain/models/auth_state.dart';
import '../notifiers/auth_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
return AuthStateNotifier();
});

