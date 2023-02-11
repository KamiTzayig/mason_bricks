import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../../../core/typedefs.dart';


 
part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// {@template auth_user}
/// AuthUser description
/// {@endtemplate}
@freezed
class AuthUser with _$AuthUser {
  /// {@macro auth_user}
  const factory AuthUser({ 
    required UserId userId,
    required PhoneNumber phoneNumber,
    required String fullName,
  }) = _AuthUser;
  
    /// Creates a AuthUser from Json map
  factory AuthUser.fromJson(Map<String, dynamic> data) => _$AuthUserFromJson(data);


}
