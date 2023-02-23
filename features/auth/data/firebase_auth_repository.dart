import 'dart:async';

import 'package:Bootke/features/core/typedefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_auth/smart_auth.dart';

import '../../../global_variables.dart';
import '../domain/auth_repository.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../domain/enums/auth_failure.dart';
import '../domain/models/auth_user.dart';

class AuthRepositoryFirebase implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';

  @override
  bool get isAlreadyLoggedIn => userId != null;

  @override
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;

  @override
  Future<Either<AuthFailure, bool>> validatePhoneNumber({
    required PhoneNumber phoneNumber,
  }) async {
    // todo optional if needed to validate the phone number through the backend
   // implement your own method
    final functions = FirebaseFunctions.instance;

    try {
      final HttpsCallableResult result = await functions
          .httpsCallable('validatePhone')
          .call({"phoneNumber": phoneNumber});

      if (result.data["validated"]) {
        return Right(true);
      } else {
        return Left(AuthFailure.phoneNumberNotAllowed);
      }
    } on FirebaseFunctionsException catch (error) {
      print(error.code);
      print(error.details);
      print(error.message);
      return Left(AuthFailure.serverError);
    } catch (e) {
      print(e);
      return Left(AuthFailure.serverError);
    }
  }

  @override
  Stream<Either<AuthFailure, VerificationId>> signInWithPhoneNumberNative({
    required String phoneNumber,
    required Duration timeout,
  }) async* {
    final StreamController<Either<AuthFailure, VerificationId>>
        streamController =
        StreamController<Either<AuthFailure, VerificationId>>();
    await _firebaseAuth.verifyPhoneNumber(
        timeout: timeout,
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!
          // Sign the user in (or link) with the auto-generated credential.
          // The feature is currently disabled for the sake of simplicity of the tutorial.
        },
        codeSent: (String verificationId, int? resendToken) async {
          // Update the UI - wait for the user to enter the SMS code
          streamController.add(right(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
          streamController.add(left(AuthFailure.smsTimeout));
        },
        verificationFailed: (FirebaseAuthException e) {
          late final Either<AuthFailure, String> result;
          if (e.code == 'invalid-phone-number') {
            result = left(AuthFailure.invalidPhoneNumber);
          } else if (e.code == 'too-many-requests') {
            result = left(AuthFailure.tooManyRequests);
          } else if (e.code == 'app-not-authorized') {
            result = left(AuthFailure.deviceNotSupported);
          } else {
            result = left(AuthFailure.serverError);
          }
          streamController.add(result);
        });
    yield* streamController.stream;
  }

  @override
  Future<Either<AuthFailure, AuthUser>> verifySmsCodeNative({
    required SmsCode smsCode,
    required VerificationId verificationId,
  }) async {
    try {
      final PhoneAuthCredential phoneAuthCredential =
          PhoneAuthProvider.credential(
              smsCode: smsCode, verificationId: verificationId);

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      AuthUser user = AuthUser(
          userId: userCredential.user!.uid,
          phoneNumber: userCredential.user!.phoneNumber ?? "",
          fullName: userCredential.user!.displayName ?? "");
      return right(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == "session-expired") {
        return left(AuthFailure.sessionExpired);
      } else if (e.code == "ınvalıd-verıfıcatıon-code" ||
          e.code == "invalid-verification-code") {
        return left(AuthFailure.invalidVerificationCode);
      }
      return left(AuthFailure.serverError);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<Either<AuthFailure, AuthUser>> autoGetSmsCode(
      {required VerificationId verificationId}) async {
    SmartAuth smartAuth = SmartAuth();
    final res = await smartAuth.getSmsCode();
    if (res.succeed) {
      try {
        Either<AuthFailure, AuthUser> result = await verifySmsCodeNative(
            smsCode: res.code!, verificationId: verificationId);
        return result;
      } catch (e) {
        return left(AuthFailure.serverError);
      }
    } else {
      return left(AuthFailure.serverError);
    }
  }

  Future<void> getUserData(PhoneNumber phoneNumber) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("users")
        .where("phoneNumber", isEqualTo: phoneNumber)
        .get();

    String name = snapshot.docs.first.get("name");
    print(name);

    await _firebaseAuth.currentUser?.updateDisplayName(name);
  }

  @override
  Stream<AuthUser> get authStateChanges {
    return _firebaseAuth.authStateChanges().map(
      (User? user) {

        if (user == null) {
          return AuthUser(userId: "", fullName: "", phoneNumber: "");
        } else {
          currentUser = user;
          Map<String, dynamic> userMap = {
            "userId": user.uid,
            "phoneNumber": user.phoneNumber,
            "fullName": user.displayName,
          };
          return AuthUser.fromJson(userMap);
        }
      },
    );
  }
}
