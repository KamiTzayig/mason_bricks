//example of an abstract repository which the data layer will implement
import 'package:dartz/dartz.dart';
import '../../core/typedefs.dart';
import 'enums/auth_failure.dart';
import 'models/auth_user.dart';

abstract class AuthRepository {
  //getters
  UserId? get userId;

  bool get isAlreadyLoggedIn;

  String get displayName;

  //Notifies when the authentication status changes.
  // Stream<AuthUserModel> get authStateChanges;
  //Logs out from the service.
  Future<void> signOut();

  //Sends phone number to the backend, emit error messages, if any.
  Stream<Either<AuthFailure, VerificationId>> signInWithPhoneNumberNative({
    required PhoneNumber phoneNumber,
    required Duration timeout,
  });

  //Sends SMS code to the backend for verification, emit error messages, if any.
  Future<Either<AuthFailure, AuthUser>> verifySmsCodeNative({
    required SmsCode smsCode,
    required VerificationId verificationId,
  });

  Future<Either<AuthFailure, bool>> validatePhoneNumber({
    required PhoneNumber phoneNumber,
  });

  Future<Either<AuthFailure, AuthUser>> autoGetSmsCode({
    required VerificationId verificationId,
  });


  Stream<AuthUser> get authStateChanges;

// Future<CurrentAuthState> verifyPhoneNumber(
//     {required PhoneNumber phoneNumber,}
// );
// Future<CurrentAuthState> signInWeb(PhoneNumber phoneNumber);
// Future<CurrentAuthState> confirmNumberWeb(String sms);

}
