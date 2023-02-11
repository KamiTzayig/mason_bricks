import 'dart:async';

import 'package:Bootke/features/auth/domain/models/auth_state.dart';
import 'package:dartz/dartz.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/typedefs.dart';
import '../../data/firebase_auth_repository.dart';
import '../../domain/auth_repository.dart';
import '../../domain/enums/auth_failure.dart';
import '../../domain/models/auth_user.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState.unknown());
  final AuthRepository _repository = AuthRepositoryFirebase();
  final Duration verificationCodeTimeout = const Duration(seconds: 60);
  StreamSubscription<Either<AuthFailure,
      VerificationId>>? _phoneNumberSignInNativeSubscription;

  @override
  void dispose() {
    _phoneNumberSignInNativeSubscription?.cancel();
    super.dispose();
  }

  void updatePhoneNumber(String phoneNumber){
    state = state.copyWith(phoneNumber: phoneNumber);

  }

  void updateSmsCode(String smsCode){
    state = state.copyWith(smsCode: smsCode);

  }


  Future<bool> validatePhoneNumber(PhoneNumber phoneNumber) async {
    state = state.copyWith(isLoading: true, authFailure: AuthFailure.none);

    //regex phone a valid phone number
    RegExp regex = RegExp(r"^[0][5]\d{8}$");

    if (!regex.hasMatch(phoneNumber.trim())) {
      await Future.delayed(Duration(milliseconds: 12));
      state = state.copyWith(authFailure: AuthFailure.invalidPhoneNumber, isLoading: false);
      return false;
    }

    PhoneNumber number = "+972${phoneNumber.substring(1)}";
    final Either<AuthFailure, bool> phoneValidationResult =
    await _repository.validatePhoneNumber(phoneNumber: number);
    phoneValidationResult.fold(
          (AuthFailure authFailure) {
        state = state.copyWith(
          authFailure: authFailure,
          isLoading: false,
        );
      },
          (bool success) {
        state = state.copyWith(
          phoneNumber: number,
          isLoading: false,
          authFailure: AuthFailure.none,
        );
      },
    );

    return phoneValidationResult.isRight();
  }

  void signInWithPhoneNumberNative({
    required String phoneNumber,
  }) {
    {
      state = state.copyWith(isLoading: true, authFailure: AuthFailure.none,);

      _phoneNumberSignInNativeSubscription = _repository
          .signInWithPhoneNumberNative(
          phoneNumber: state.phoneNumber, timeout: verificationCodeTimeout)
          .listen(
            (Either<AuthFailure, VerificationId> failureOrVerificationId) =>
            failureOrVerificationId.fold(
                  (AuthFailure authFailure) {
                //This is the part where we receive failures like 'invalidPhoneNumber', 'smsTimeout' etc.
               state = state.copyWith(
                    authFailure: authFailure, isLoading: false);
              },

                  (VerificationId verificationId) async{
                // Catch this in Bloc Listener and take the user to SMS code entry page.

                state = state.copyWith(
                  verificationCode: verificationId,
                  isLoading: false,
                );

                 await _repository.autoGetSmsCode(verificationId: verificationId);
              },
            ),
      );
    }
  }

  void verifySmsCodeNative() async {
    if (state.verificationCode != null) {
      state = state.copyWith(
        isLoading: true,
        authFailure: AuthFailure.none,
      );
      final Either<AuthFailure, AuthUser> failureOrSuccess =
      await _repository.verifySmsCodeNative(
          smsCode: state.smsCode, verificationId: state.verificationCode!);

      failureOrSuccess.fold(
            (AuthFailure authFailure) {
         state = state.copyWith(authFailure: authFailure, isLoading: false,);
        },
            (AuthUser authUser) {
         state = state.copyWith(isLoading: false);
          // Verification completed successfully case.
          // Bloc Listener in the UI should listen to Auth Listener State and if user is authenticated and not anonymous, we should take them to Registration page or Feed Page.
        },
      );
    }
  }

  Future<void> signOut() async{
    await _repository.signOut();
    state = AuthState.unknown();
  }

}


