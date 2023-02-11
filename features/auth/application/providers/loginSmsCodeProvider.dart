import 'package:Bootke/features/auth/application/providers/auth_state_provider.dart';
import 'package:Bootke/features/core/typedefs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final loginSmsCodeProvider = Provider<SmsCode>((ref) {
  return ref.watch(authStateProvider).smsCode;
});