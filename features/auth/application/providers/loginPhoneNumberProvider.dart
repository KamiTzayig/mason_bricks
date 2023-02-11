import 'package:Bootke/features/auth/application/providers/auth_state_provider.dart';
import 'package:Bootke/features/core/typedefs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final loginPhoneNumberProvider = Provider<PhoneNumber>((ref) {
  return ref.watch(authStateProvider).phoneNumber;
});