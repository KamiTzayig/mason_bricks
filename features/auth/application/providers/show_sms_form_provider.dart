import 'package:Bootke/features/auth/application/providers/auth_state_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final showSmsFormProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).verificationCode != null;
});