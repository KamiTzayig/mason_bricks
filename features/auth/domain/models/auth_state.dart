import 'package:equatable/equatable.dart';

import '../../../core/typedefs.dart';
import '../enums/auth_failure.dart';

/// {@template auth_state}
/// AuthState description
/// {@endtemplate}
class AuthState extends Equatable {
  /// {@macro auth_state}
  const AuthState({ 
    required this.isLoading,
    required this.authFailure,
    required this.phoneNumber,
    required this.smsCode,
    required this.verificationCode,
  });

  
        /// initial constructor for AuthState
      const AuthState.unknown():
        isLoading = false ,
        authFailure = AuthFailure.none ,
        phoneNumber = "" ,
        smsCode = "" ,
        verificationCode = null;
    





  /// A description for isLoading
  final bool isLoading;

  /// A description for authFailure
  final AuthFailure authFailure;

  /// A description for phoneNumber
  final PhoneNumber phoneNumber;

  /// A description for smsCode
  final SmsCode smsCode;

  /// A description for verificationCode
  final VerificationId? verificationCode;

    /// Creates a copy of the current AuthState with property changes
  AuthState copyWith({ 
    bool? isLoading,
    AuthFailure? authFailure,
    PhoneNumber? phoneNumber,
    SmsCode? smsCode,
    VerificationId? verificationCode,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      authFailure: authFailure ?? this.authFailure,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      smsCode: smsCode ?? this.smsCode,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }


    @override
  List<Object?> get props => [
        isLoading,
        authFailure,
        phoneNumber,
        smsCode,
        verificationCode,
      ];

}
