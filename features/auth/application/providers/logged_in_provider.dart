import 'package:Bootke/features/auth/domain/models/auth_user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'auth_user_provider.dart';


final isLoggedInProvider = Provider<bool>((ref) {
  final AuthUser authUser = ref.watch(authUserProvider);
  print("kami");
  print(authUser);

  return '' != authUser.userId;
});