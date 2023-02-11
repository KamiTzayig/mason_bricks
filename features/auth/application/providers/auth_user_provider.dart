import 'package:Bootke/features/auth/domain/models/auth_user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifiers/auth_user_notifiier.dart';


final authUserProvider = StateNotifierProvider<AuthUserNotifier, AuthUser>((ref) {
  return AuthUserNotifier();
});

